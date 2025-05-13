import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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

class _DiscoverViewState extends State<DiscoverView> with SingleTickerProviderStateMixin {
  bool _isFirstLoading = true;
  bool _isLoading = false;
  int _currentIndex = 0;
  bool _showTutorial = true;
  String? _currentTrackUrl;

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

    // Obtenemos los datos del usuario
    _getUserSettings();

    _loadTracks();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _backgroundOffset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0.06, 0.02)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.06, 0.02), end: const Offset(-0.04, 0.05)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.04, 0.05), end: const Offset(0.03, -0.03)).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.03, -0.03), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_animationController);

    _backgroundScale = Tween<double>(begin: 1.2, end: 1.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
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

      List<CardTrackWidget> newCards = await Future.wait(tracks.map((track) async {
        final color = await extractDominantColor(imagePath: track.md5Image);
        return CardTrackWidget(
          track: track,
          animatedCover: _userSettings.cardAnimatedCover,
          cardBackground: color,
        );
      }));

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isFirstLoading = false;
              _isLoading = false;
              _cards.addAll(newCards);

              if (_cards.isNotEmpty && _currentIndex < _cards.length) {
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

    await _audioPlayer.stop();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _currentTrackUrl = url;
    await _audioPlayer.play(UrlSource(url));

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

      _currentIndex = currentIndex;
      _playPreview(_cards[currentIndex].track.preview, _cards[currentIndex].track.md5Image);

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
        body: Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder<String?>(
            valueListenable: _backgroundImageNotifier,
            builder: (context, imageUrl, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    Positioned.fill(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedBuilder(
                            animation: _backgroundOffset,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  _backgroundOffset.value.dx * MediaQuery.of(context).size.width,
                                  _backgroundOffset.value.dy * MediaQuery.of(context).size.height,
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
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SafeArea(
                    child: _cards.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 70),
                            child: CardSwiper(
                              initialIndex: _currentIndex,
                              cardsCount: _cards.length,
                              onSwipe: _onSwipe,
                              cardBuilder: (context, index, percentThresholdX,
                                  percentThresholdY) {
                                if (index == _cards.length - 3 && !_isLoading) {
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
                  )
                ],
              );
            })
      ],
    ));
  }
}
