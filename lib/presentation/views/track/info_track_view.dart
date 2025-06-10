import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/export_providers.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/externals_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista de información de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoTrackView extends ConsumerStatefulWidget {
  /// ID de la canción a mostrar
  final int idTrack;

  const InfoTrackView({super.key, required this.idTrack});

  @override
  ConsumerState<InfoTrackView> createState() => _InfoTrackViewState();
}

class _InfoTrackViewState extends ConsumerState<InfoTrackView>
    with WidgetsBindingObserver {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // AudioPlayer para reproducir los previews de las canciones
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ScrollController
  final ScrollController _scrollController = ScrollController();

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena los datos de la canción
  late Track _track;

  // Variable que almacena a los artistas y contribuidores
  late List<Artist> _artists = List.empty();

  // Variable que almacena la letra de la canción
  late String lyrics;

  // Variable que almacena los datos del album
  late Album _album;

  // Variable que almacena las stats de la canción
  late Stats _stats;

  // Variable que almacena las stats del album
  late Stats _albumStats;

  // Variable que almacena las canciones relacionadas
  late List<Track> _relatedTracks = List.empty();

  // Variable que almacena si la canción esta en la biblioteca del usuario
  bool _isInLibrary = false;

  // Variable que almacena si se esta cargando la canción
  bool _isLoading = true;

  // Variable que almacena si esta canción esta marcada como favorita
  bool _isFavorite = false;

  // Variable que almacena si se ha cambiado el valor de _isFavorite
  bool _hasChange = false;

  // Variable que almacena si se está reproduciendo la canción
  bool _isPlaying = false;

  // Variable que almacena la opacidad del texto del titulo del appbar
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    // Configura el listener para el estado del reproductor
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    _loadData();
    _scrollController.addListener(_updateTextOpacity);

    WidgetsBinding.instance.addObserver(this);
  }

  // Función para obtener todos los datos
  void _loadData() async {
    try {
      final results = await Future.wait([
        getTrackById(idTrack: widget.idTrack),
        isTrackLiked(uid: _uid, idTrack: widget.idTrack),
        getTrackStats(idTrack: widget.idTrack),
        areTrackInDatabase(uid: _uid, tracksIds: [widget.idTrack])
      ]);

      _track = results[0] as Track;

      final resultsByTrack = await Future.wait([
        getLyrics(artistName: _track.artist.name, trackTitle: _track.title),
        getAlbumById(albumID: _track.album.id),
        getAlbumStats(idAlbum: _track.album.id),
        getRecommendedTracksByArtist(artistID: _track.artist.id)
      ]);

      if (!mounted) return;
      setState(() {
        _artists = {_track.artist, ..._track.contributors}
            .toList()
            .fold<List<Artist>>([], (unique, artist) {
          if (unique.any((a) => a.id == artist.id)) return unique;
          return [...unique, artist];
        });
        _isFavorite = results[1] as bool;
        _track.lyrics = resultsByTrack[0] as String;
        _stats = results[2] as Stats;
        List ids = results[3] as List;
        _isInLibrary = !ids.contains(widget.idTrack);
        _album = resultsByTrack[1] as Album;
        _albumStats = resultsByTrack[2] as Stats;
        _relatedTracks = resultsByTrack[3] as List<Track>;
        // Eliminamos si aparece la misma canción
        _relatedTracks.removeWhere((t) => t.id == _track.id);
        _isLoading = false;
        print(_isLoading);
      });
    } catch (e) {
      print('Error loading track data: $e');
    }
  }

  // Función que reproduce o pausa la canción
  Future<void> _playPreview() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(_track.preview));
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Función que actualiza la opacidad del texto del appbar
  void _updateTextOpacity() {
    final double offset = _scrollController.offset;
    // La opacidad comienza a subir solo cuando la imagen de portada está completamente fuera de vista.
    final double imageHeight = MediaQuery.of(context).size.height * 0.3;
    const double fadeRange = 100.0;

    double newOpacity = ((offset - imageHeight) / fadeRange).clamp(0.0, 1.0);

    if (newOpacity != _textOpacity) {
      setState(() {
        _textOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _disposeAudioPlayer();
    _scrollController.removeListener(_updateTextOpacity);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Esta función detiene el player y libera sus recursos
  void _disposeAudioPlayer() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden)) {
      _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: height * 0.4,
                  floating: false,
                  pinned: true,
                  snap: false,
                  elevation: 4.0,
                  leading: CustomLeadingWidget(
                      hasChange: _hasChange, textOpacity: _textOpacity),
                  title: Opacity(
                      opacity: _textOpacity,
                      child: LayoutBuilder(builder: (context, constraints) {
                        Widget resultText;

                        final text = _track.title;
                        final textPainter = TextPainter(
                            text: TextSpan(
                              text: text.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.ltr)
                          ..layout(maxWidth: double.infinity);

                        final textWidth = textPainter.size.width;

                        if (textWidth > constraints.maxWidth) {
                          resultText = SizedBox(
                            height: 30,
                            child: Marquee(
                              text: text.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  overflow: TextOverflow.ellipsis),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 40.0,
                              pauseAfterRound: Duration(seconds: 4),
                              startPadding: 0.0,
                              accelerationDuration: Duration(seconds: 2),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          );
                        } else {
                          resultText = Text(
                            text.toUpperCase(),
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                overflow: TextOverflow.ellipsis),
                          );
                        }

                        return resultText;
                      })),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      _track.md5Image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [actionWidget()],
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // Título de la canción
                          LayoutBuilder(builder: (context, constraints) {
                            Widget resultText;

                            final text = _track.title;
                            final textPainter = TextPainter(
                                text: TextSpan(
                                  text: text.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                maxLines: 1,
                                textDirection: TextDirection.ltr)
                              ..layout(maxWidth: double.infinity);

                            final textWidth = textPainter.size.width;

                            if (textWidth > constraints.maxWidth) {
                              resultText = SizedBox(
                                height: 30,
                                child: Marquee(
                                  text: text.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 40.0,
                                  pauseAfterRound: Duration(seconds: 4),
                                  startPadding: 0.0,
                                  accelerationDuration: Duration(seconds: 2),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              );
                            } else {
                              resultText = Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  text.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              );
                            }

                            return resultText;
                          }),

                          const SizedBox(height: 20),

                          // Artistas
                          SizedBox(
                            height: 120,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _artists.map((artist) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPlaying = false;
                                      });
                                      _audioPlayer.pause();
                                      context.push('/artist?id=${artist.id}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Imagen del artista
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 2),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  artist.pictureBig),
                                              radius: 40,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          // Nombre del artista
                                          Text(
                                            artist.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Información
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              capitalizeFirstLetter(text: localization.info),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          // Container con la información
                          CustomContainer(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title: capitalizeFirstLetter(
                                        text: localization.release_date),
                                    value: _track.releaseDate,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title: capitalizeFirstLetter(
                                        text: localization.duration),
                                    value: formatDuration(_track.duration),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title: capitalizeFirstLetter(
                                        text: _album.recordType),
                                    value: _track.album.title,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title:
                                        '${capitalizeFirstLetter(text: localization.position_album)} ${_album.recordType}',
                                    value: _track.trackPosition.toString(),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title: capitalizeFirstLetter(
                                        text: localization.ranking),
                                    value: formatWithThousandsSeparator(
                                        _track.rank),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomRow(
                                    title: capitalizeFirstLetter(
                                        text: localization.explicit_content),
                                    value: capitalizeFirstLetter(
                                        text: _track.explicitLyrics ||
                                                _track.explicitContentCover ==
                                                    1 ||
                                                _track.explicitContentLyrics ==
                                                    1
                                            ? localization.yes
                                            : localization.no),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),

                          // Letras
                          if (_track.lyrics.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                // Letras
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    capitalizeFirstLetter(
                                        text: localization.lyrics),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),

                                // Container con las letras
                                GestureDetector(
                                  onTap: () => context.push(
                                      '/lyrics?lyrics=${_track.lyrics}&title=${_track.title}&artists=${_track.buildArtistsText()}&cover=${_track.md5Image}'),
                                  child: CustomContainer(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _track.getFirstFourLyricsLines(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  wordSpacing: 2,
                                                  height: 1.8),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              capitalizeFirstLetter(
                                                  text: localization.see_more),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 20),
                          // Album
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              capitalizeFirstLetter(text: _album.recordType),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          // Container con los datos del album
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPlaying = false;
                                });
                                _audioPlayer.pause();
                                context.push('/album?id=${_album.id}');
                              },
                              child: CustomAlbumWidget(
                                album: _album,
                                stats: _albumStats,
                              )),

                          const SizedBox(height: 20),

                          // Stats
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              capitalizeFirstLetter(text: localization.stats),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          // Container con las stats
                          CustomStatsWidget(stats: _stats),

                          const SizedBox(height: 20),

                          // Canciones relacionadas
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              capitalizeFirstLetter(
                                  text: localization.related_tracks),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          // Container con las canciones relacionadas
                          SizedBox(
                            width: double.infinity,
                            child: CustomContainer(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _relatedTracks.map((track) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isPlaying = false;
                                        });
                                        _audioPlayer.pause();
                                        context.push('/track?id=${track.id}');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                track.md5Image,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              track.title,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              track.buildArtistsText(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          CustomAdvertisimentWidget(),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget actionWidget() {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            // Actualizamos el Swipe para cambiar la canción de me gusta a no me gusta y viceversa.
            if (_isInLibrary) {
              // La canción esta en la biblioteca
              await updateSwipe(
                  uid: _uid, idTrack: _track.id, newLike: _isFavorite ? 0 : 1);
            } else {
              // Creamos el Swipe
              Swipe swipe = Swipe(
                  id: _track.id,
                  idAlbum: _track.album.id,
                  idArtist: _track.artist.id,
                  like: _isFavorite ? 0 : 1);

              // Guardamos el Swipe
              await saveSwipes(uid: _uid, swipes: [swipe]);
            }

            // Actualizamos las stats
            if (_isFavorite) {
              if (_stats.likes > 0) {
                _stats.likes--;
              }

              if (_albumStats.likes > 0) {
                _albumStats.likes--;
              }

              _stats.dislikes++;
              _albumStats.dislikes++;
            } else {
              if (_stats.dislikes > 0) {
                _stats.dislikes--;
              }

              if (_albumStats.dislikes > 0) {
                _albumStats.dislikes--;
              }

              _stats.likes++;
              _albumStats.likes++;
            }

            // Guardamos el cambio en el provider
            ref.read(swipeChangedProvider.notifier).state = true;

            setState(() {
              _isFavorite = !_isFavorite;
              _hasChange = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _textOpacity <= 0
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(_textOpacity > 0),
                    color: _textOpacity <= 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _playPreview(),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _textOpacity <= 0
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    key: ValueKey<bool>(_textOpacity > 0),
                    color: _textOpacity <= 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
