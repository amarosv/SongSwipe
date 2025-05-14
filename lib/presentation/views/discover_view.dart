import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/card_track_widget.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de descubrimiento <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView>
    with SingleTickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  bool _isFirstLoading = true;
  bool _isLoading = false;
  int _currentIndex = 0;
  String? _currentTrackUrl;
  bool autoAudio = false;
  bool _isPlaying = false;
  // Duración actual del preview
  Duration _currentPosition = Duration.zero;
  // Duración máxima del preview (Deezer usa 30s)
  final Duration _previewDuration = const Duration(seconds: 30);

  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();

  // AudioPlayer para reproducir los previews de las canciones
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Lista donde se almacenarán las canciones
  final List<CardTrackWidget> _cards = [];

  // Variable que almacenará la portada de la canción actual
  final ValueNotifier<String?> _backgroundImageNotifier =
      ValueNotifier<String?>(null);

  late final AnimationController _animationController;
  late final Animation<Offset> _backgroundOffset;
  late final Animation<double> _backgroundScale;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    print(_uid);

    // Obtenemos los datos del usuario
    _getUserSettings();

    _loadTracks();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _backgroundOffset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0.06, 0.02))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
                begin: const Offset(0.06, 0.02), end: const Offset(-0.04, 0.05))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(
                begin: const Offset(-0.04, 0.05),
                end: const Offset(0.03, -0.03))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.03, -0.03), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_animationController);

    _backgroundScale = Tween<double>(begin: 1.2, end: 2.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Escuchar cambios de posición del reproductor
    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _currentPosition = p;
        });
      }
    });

    // Escuchar cuando el preview termina para reiniciar la barra de progreso y el estado de reproducción
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          ReleaseMode releaseMode = _audioPlayer.releaseMode;
          _currentPosition = Duration.zero;

          if (releaseMode == ReleaseMode.loop) {
            _audioPlayer.pause();
            _audioPlayer.resume();
          } else {
            _isPlaying = false;
          }
        });
      }
    });
  }

  // Este método será llamado desde HomeScreen para comprobar si hay cambios en los ajustes del usuario
  void refresh() {
    _getUserSettings();

    _loadTracks();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    if (mounted) {
      setState(() {
        _userSettings = settings;
      });
    }
  }

  void _loadTracks() async {
    if (_isLoading) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    });

    try {
      List<Track> tracks = await getDiscoverTracks();

      List<CardTrackWidget> newCards =
          await Future.wait(tracks.map((track) async {
        final color = await extractDominantColor(imagePath: track.md5Image);
        return CardTrackWidget(
          track: track,
          animatedCover: _userSettings.cardAnimatedCover,
          cardBackground: color,
          onlyAudio: _userSettings.audioOnlyAudio,
        );
      }));

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isFirstLoading = false;
              _isLoading = false;
              _cards.addAll(newCards);

              if (_cards.isNotEmpty &&
                  _currentIndex < _cards.length &&
                  _userSettings.audioAutoPlay) {
                autoAudio = true;
                _playPreview(_cards[_currentIndex].track.preview,
                    _cards[_currentIndex].track.md5Image);
              }
            });
          }
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      print('Error cargando pistas: $e');
    }
  }

  Future<void> _playPreview(String url, String imageUrl) async {
    if (_currentTrackUrl == url) return;

    autoAudio = true;

    await _audioPlayer.stop();

    if (_userSettings.audioLoop) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
    }

    _currentTrackUrl = url;
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
    });
    _backgroundImageNotifier.value = imageUrl;
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    print(_cards[currentIndex!].track.id);
    if (currentIndex != null) {
      if (currentIndex >= _cards.length) {
        currentIndex = _cards.length - 1;
      }

      _currentIndex = currentIndex;
      print('$currentIndex de ${_cards.length}');

      // if (direction == CardSwiperDirection.right ||
      //     direction == CardSwiperDirection.bottom) {
      //   _loadRecommendedTracks(_cards[previousIndex].artista.id);
      // } else {
      //   discards++;
      // }

      // trackAction(
      //     trackID: _cards[previousIndex].id,
      //     direction: direction,
      //     artistID: _cards[previousIndex].artista.id);

      // _currentIndex = currentIndex;
      _playPreview(_cards[currentIndex].track.preview,
          _cards[currentIndex].track.md5Image);

      // if ((currentIndex == _cards.length - 1 || discards == 5) && !_isLoading) {
      //   discards = 0;
      //   // _cards.clear();
      //   _loadTracks();
      // }
    }
    return true;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _userSettings.showTutorial ? _buildTutorialWithArrows() : _content());
  }

  Widget _content() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder<String?>(
            valueListenable: _backgroundImageNotifier,
            builder: (context, imageUrl, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Fondo
                  if (_userSettings.cardBlurredCoverAsBackground &&
                      imageUrl != null)
                    Positioned.fill(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedBuilder(
                            animation: _backgroundOffset,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  _backgroundOffset.value.dx *
                                      MediaQuery.of(context).size.width,
                                  _backgroundOffset.value.dy *
                                      MediaQuery.of(context).size.height,
                                ),
                                child: Transform.scale(
                                  scale: _backgroundScale.value,
                                  child: child,
                                ),
                              );
                            },
                            child: ClipRect(
                              child: OverflowBox(
                                // Ampliar el área visible para evitar bordes blancos al mover la imagen
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                          ),
                          BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      color: _cards.isNotEmpty
                          ? _cards[_currentIndex].cardBackground
                          : null,
                    ),
                  SafeArea(
                    child: _cards.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              // Carta
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 50),
                                  child: CardSwiper(
                                    initialIndex: _currentIndex,
                                    cardsCount: _cards.length,
                                    onSwipe: _onSwipe,
                                    controller: _swiperController,
                                    cardBuilder: (context, index,
                                        percentThresholdX, percentThresholdY) {
                                      if (index == _cards.length - 3 &&
                                          !_isLoading) {
                                        _loadTracks();
                                      }
                                      if (_cards.length < index) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return _cards[index];
                                      }
                                    },
                                  ),
                                ),
                              ),
                              // Botones
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _userSettings.cardSkipSongs
                                      ? CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.8),
                                          child: IconButton(
                                            icon: Icon(Icons.skip_next,
                                                color: Colors.white),
                                            onPressed: () {
                                              _swiperController.swipe(
                                                  CardSwiperDirection.top);
                                              _playPreview(
                                                  _cards[_currentIndex]
                                                      .track
                                                      .preview,
                                                  _cards[_currentIndex]
                                                      .track
                                                      .md5Image);
                                            },
                                          ),
                                        )
                                      : Container(),
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.8),
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        // Acción para descartar canción
                                      },
                                    ),
                                  ),
                                  // Play/Pause con progreso
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 56,
                                        width: 56,
                                        child: CircularProgressIndicator(
                                          value:
                                              _previewDuration.inMilliseconds ==
                                                      0
                                                  ? 0
                                                  : _currentPosition
                                                          .inMilliseconds /
                                                      _previewDuration
                                                          .inMilliseconds,
                                          strokeWidth: 5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.8),
                                        child: IconButton(
                                          icon: Icon(
                                            _isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            if (!autoAudio) {
                                              _playPreview(
                                                  _cards[_currentIndex]
                                                      .track
                                                      .preview,
                                                  _cards[_currentIndex]
                                                      .track
                                                      .md5Image);
                                            } else {
                                              if (_isPlaying) {
                                                await _audioPlayer.pause();
                                              } else {
                                                await _audioPlayer.resume();
                                              }
                                              setState(() {
                                                _isPlaying = !_isPlaying;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.8),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Acción para guardar canción
                                      },
                                    ),
                                  ),
                                  _userSettings.cardSkipSongs
                                      ? CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.8),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.replay,
                                              color: _currentIndex == 0
                                                  ? Colors.white
                                                      .withOpacity(0.3)
                                                  : Colors.white,
                                            ),
                                            onPressed: _currentIndex == 0
                                                ? null
                                                : () {
                                                    _currentIndex--;
                                                    _swiperController.undo();
                                                    // _swiperController.swipe(CardSwiperDirection.bottom);
                                                    _playPreview(
                                                        _cards[_currentIndex]
                                                            .track
                                                            .preview,
                                                        _cards[_currentIndex]
                                                            .track
                                                            .md5Image);
                                                  },
                                          ))
                                      : Container()
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                  ),
                ],
              );
            })
      ],
    );
  }

  Widget _buildTutorialWithArrows() {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // Fondo oscuro semitransparente
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        // Flecha arriba y texto "Saltar"
        Positioned(
          top: 50,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: Column(
            children: [
              Icon(Icons.arrow_upward, color: Colors.yellowAccent, size: 40),
              Text(
                capitalizeFirstLetter(text: localization.skip),
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Flecha derecha y texto "Guardar"
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 40,
          right: 20,
          child: Column(
            children: [
              Icon(Icons.arrow_forward, color: Colors.greenAccent, size: 40),
              Text(
                capitalizeFirstLetter(text: localization.save),
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Flecha abajo y texto "Retroceder"
        Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: Column(
            children: [
              Icon(Icons.arrow_downward, color: Colors.blueAccent, size: 40),
              Text(
                capitalizeFirstLetter(text: localization.back),
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Flecha izquierda y texto "Descartar"
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 40,
          left: 20,
          child: Column(
            children: [
              Icon(Icons.arrow_back, color: Colors.redAccent, size: 40),
              Text(
                capitalizeFirstLetter(text: localization.discard),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Botón "Entendido"
        Center(
          child: ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _userSettings.showTutorial = false;
                    });
                    updateUserSettings(_userSettings);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                capitalizeFirstLetter(text: localization.ok),
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
