import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/card_track_widget.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Vista para la pantalla de deslizar canciones específicas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SwipesLibraryView extends ConsumerStatefulWidget {
  /// Lista de ids canciones
  final List<int> tracks;

  const SwipesLibraryView({super.key, required this.tracks});

  @override
  ConsumerState<SwipesLibraryView> createState() => _SwipesLibraryViewState();
}

class _SwipesLibraryViewState extends ConsumerState<SwipesLibraryView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Controlador del CardSwiper
  final CardSwiperController _swiperController = CardSwiperController();

  // Duración máxima del preview (Deezer usa 30s)
  final Duration _previewDuration = const Duration(seconds: 30);

  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // AudioPlayer para reproducir los previews de las canciones
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Lista donde se almacenarán las canciones
  final List<CardTrackWidget> _cards = [];

  // Variable que almacenará la portada de la canción actual
  final ValueNotifier<String?> _backgroundImageNotifier =
      ValueNotifier<String?>(null);

  // Controlador de la animación
  late final AnimationController _animationController;

  // Offset de la animación de fondo
  late final Animation<Offset> _backgroundOffset;

  // Escala de la animación de fondo
  late final Animation<double> _backgroundScale;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Booleano que indica si se están cargando las canciones
  bool _isLoading = false;

  // Variable que indica el índice actual
  int _currentIndex = 0;

  // Variable que almacena la url del previe de la canción actual
  String? _currentTrackUrl;

  // Booleano que indica si es auto play el audio
  bool autoAudio = false;

  // Booleano que indica si se está reproduciendo la canción
  bool _isPlaying = false;

  // Duración actual del preview
  Duration _currentPosition = Duration.zero;

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();

  // Lista donde se almacenarán los swipes
  List<Swipe> swipes = [];

  // Variable que almacena hasta que índice sean cargados los datos de la canción
  int _loadIndex = 0;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;

    for (var i in widget.tracks) {
      print(i);
    }

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

    WidgetsBinding.instance.addObserver(this);
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
    if (_isLoading || _loadIndex >= widget.tracks.length) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    });

    try {
      print('Cargando 10 canciones...');
      final maxIterations = (_loadIndex + 10).clamp(0, widget.tracks.length);
      final idsToLoad = widget.tracks.sublist(_loadIndex, maxIterations);
      final tracks = await Future.wait(
        idsToLoad.map((id) => getTrackById(idTrack: id)),
      );
      _loadIndex = maxIterations;

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
    // Variable donde se almacenará el swipe
    Swipe swipe;

    // print(_cards[currentIndex!].track.id);
    if (currentIndex! >= _cards.length) {
      currentIndex = _cards.length - 1;
    }

    // print('$currentIndex de ${_cards.length}');

    // Comprobamos en que dirección se ha deslizado la canción
    switch (direction) {
      case CardSwiperDirection.top:
        {
          // Skip, no se almacena en la lista de Swipes
          break;
        }
      case CardSwiperDirection.bottom:
        {
          // Volver a la canción anterior, no se almacena en la lista de Swipes
          if (currentIndex > 1) {
            _currentIndex -= 2;
            currentIndex -= 2;
            _swiperController.undo();
            _swiperController.undo();
          } else if (currentIndex > 0) {
            _swiperController.swipe(CardSwiperDirection.bottom);
            _currentIndex--;
            currentIndex--;
            _swiperController.undo();
          }
          break;
        }
      case CardSwiperDirection.left:
        {
          // Dislike
          // print(_cards[_currentIndex].track.title);
          _dislikeTrack();
          break;
        }
      case CardSwiperDirection.right:
        {
          // Like
          _likeTrack();
          break;
        }
      case CardSwiperDirection.none:
        {
          // Nada
          break;
        }
    }

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

    // Nueva verificación: borrar la lista cuando el usuario haya hecho swipe a la última carta
    if (_currentIndex == _cards.length - 1) {
      _audioPlayer.stop();
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _cards.clear();
          });
        }
      });
      return true;
    }

    _playPreview(_cards[currentIndex].track.preview,
        _cards[currentIndex].track.md5Image);

    _currentIndex = currentIndex;

    // if ((currentIndex == _cards.length - 1 || discards == 5) && !_isLoading) {
    //   discards = 0;
    //   // _cards.clear();
    //   _loadTracks();
    // }
    return true;
  }

  void _dislikeTrack() {
    Swipe swipe = Swipe(
        id: _cards[_currentIndex].track.id,
        idAlbum: _cards[_currentIndex].track.album.id,
        idArtist: _cards[_currentIndex].track.artist.id,
        like: 0);
    int existingIndex = swipes.indexWhere((s) => s.id == swipe.id);
    if (existingIndex != -1) {
      if (swipes[existingIndex].like != swipe.like) {
        swipes[existingIndex] = swipe;
      }
    } else {
      swipes.add(swipe);
    }
  }

  void _likeTrack() {
    Swipe swipe = Swipe(
        id: _cards[_currentIndex].track.id,
        idAlbum: _cards[_currentIndex].track.album.id,
        idArtist: _cards[_currentIndex].track.artist.id,
        like: 1);
    int existingIndex = swipes.indexWhere((s) => s.id == swipe.id);
    if (existingIndex != -1) {
      if (swipes[existingIndex].like != swipe.like) {
        swipes[existingIndex] = swipe;
      }
    } else {
      swipes.add(swipe);
    }
  }

  Future<bool> _finalizeSwipes() async {
    bool changes = false;

    if (swipes.isNotEmpty) {
      final List<Future<void>> updates = swipes.map((swipe) {
        return updateSwipe(idTrack: swipe.id, newLike: swipe.like, uid: _uid);
      }).toList();
      await Future.wait(updates);

      changes = true;
    }

    return changes;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // _finalizeSwipes();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _audioPlayer.pause();

      _finalizeSwipes();
    } else if (state == AppLifecycleState.resumed) {
      _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _cards.isNotEmpty
        ? _cards[_currentIndex.clamp(0, _cards.length - 1)].cardBackground
        : Theme.of(context).scaffoldBackgroundColor;
    final isDark = ThemeData.estimateBrightnessForColor(backgroundColor) ==
        Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;
    return WillPopScope(
      onWillPop: () async {
        final hasChanges = await _finalizeSwipes();
        Navigator.pop(context, hasChanges);

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'SWIPES',
              style: TextStyle(fontWeight: FontWeight.bold, color: borderColor),
            ),
            foregroundColor: borderColor,
            backgroundColor: Colors.transparent,
          ),
          body: _userSettings.showTutorial
              ? _buildTutorialWithArrows()
              : _content()),
    );
  }

  Widget _content() {
    final localization = AppLocalizations.of(context)!;

    // Si no hay cartas, usar un Container simple con fondo del scaffold.
    if (_cards.isEmpty) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Text(
                    capitalizeFirstLetter(
                        text: localization.no_more_tracks_discover),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
        ),
      );
    }
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
                    child: _cards.isEmpty && !_isLoading
                        ? Center(
                            child: Text(
                              capitalizeFirstLetter(
                                  text: localization.no_more_tracks_discover),
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : _cards.isEmpty
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
                                        cardBuilder: (context,
                                            index,
                                            percentThresholdX,
                                            percentThresholdY) {
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
                                            // _dislikeTrack();
                                            _swiperController.swipe(
                                                CardSwiperDirection.left);
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
                                              value: _previewDuration
                                                          .inMilliseconds ==
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
                                            // _likeTrack();
                                            _swiperController.swipe(
                                                CardSwiperDirection.right);
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
                                                        setState(() {
                                                          _currentIndex--;
                                                        });
                                                        _swiperController
                                                            .undo();
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
                    updateUserSettings(uid: _uid, settings: _userSettings);
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
