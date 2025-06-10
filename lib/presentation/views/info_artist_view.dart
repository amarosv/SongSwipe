import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista de la información del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoArtistView extends StatefulWidget {
  /// ID del artista
  final int idArtist;

  const InfoArtistView({super.key, required this.idArtist});

  @override
  State<InfoArtistView> createState() => _InfoArtistViewState();
}

class _InfoArtistViewState extends State<InfoArtistView>
    with WidgetsBindingObserver {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // ScrollController
  final ScrollController _scrollController = ScrollController();

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena los datos del artista
  late Artist _artist = Artist.empty();

  // Variable que almacena el top 3 canciones
  late List<Track> _topTracks = List.empty();

  // Variable que almacena el top 3 albumes
  late List<Album> _topAlbums = List.empty();

  // Variable que almacena las stats del artista
  late Stats _stats = Stats.empty();

  // Variable que almacena los artistas similares
  late List<Artist> _relatedArtists = List.empty();

  // Variable que almacena si el usuario tiene el artista guardado como favorito
  bool _isFavorite = false;

  // Variable que almacena si el usuario tiene el artista guardado como favorito y sirve para comparar
  bool _isFavoriteComparator = false;

  // Variable que almacena si se están cargando los datos
  bool _isLoading = true;

  // Variable que almacena la opacidad del texto del titulo del appbar
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _loadData();
    _scrollController.addListener(_updateTextOpacity);

    WidgetsBinding.instance.addObserver(this);
  }

  // Función para obtener los datos
  void _loadData() async {
    if (!mounted) return;

    try {
      final results = await Future.wait([
        getArtistByID(artistID: widget.idArtist),
        getSavedSongsByArtist(idArtist: widget.idArtist),
        isArtistFavorite(uid: _uid, idArtist: widget.idArtist),
        getTopTracksByArtist(idArtist: widget.idArtist),
        getTopAlbumsByArtist(idArtist: widget.idArtist),
        getArtistStats(idArtist: widget.idArtist),
        getRelatedArtists(idArtist: widget.idArtist)
      ]);

      setState(() {
        _artist = results[0] as Artist;
        _artist.savedTracks = results[1] as int;
        _isFavorite = results[2] as bool;
        _isFavoriteComparator = results[2] as bool;
        _topTracks = results[3] as List<Track>;
        _topAlbums = results[4] as List<Album>;
        _stats = results[5] as Stats;
        _relatedArtists = results[6] as List<Artist>;
        _isLoading = false;
      });
    } catch (e) {
      print('Error $e');
    }
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
    _saveArtistChange();
    _scrollController.removeListener(_updateTextOpacity);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Función que actualiza el estado del artista en la base de datos
  void _saveArtistChange() {
    if (_isFavorite != _isFavoriteComparator) {
      if (_isFavorite) {
        addArtistToFavorites(uid: _uid, artists: [widget.idArtist]);
      } else {
        deleteArtistFromFavorites(uid: _uid, idArtist: widget.idArtist);
      }

      bool finalFavorite = _isFavorite;
      _isFavoriteComparator = finalFavorite;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Para evitar llamadas a la API cada vez que se pulsa el corazón,
    // comprobamos el último valor al salir de la pantalla y ese es el que se
    // envía, llamándo así a la API una sola vez
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive ||
            state == AppLifecycleState.detached ||
            state == AppLifecycleState.hidden) &&
        _isFavorite != _isFavoriteComparator) {
      _saveArtistChange();
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
                        hasChange: false, textOpacity: _textOpacity),
                    title: Opacity(
                        opacity: _textOpacity,
                        child: LayoutBuilder(builder: (context, constraints) {
                          Widget resultText;

                          final text = _artist.name;
                          final textPainter = TextPainter(
                              text: TextSpan(
                                text: text.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                        _artist.pictureXL,
                        fit: BoxFit.cover,
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () async {
                          if (_isFavorite) {
                            _isFavorite = false;
                          } else {
                            _isFavorite = true;
                          }

                          setState(() {});
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
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                                child: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
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
                        onTap: () => context
                            .push('/swipes'), // TODO: Añadir las canciones
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
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                                child: Icon(
                                  Icons.swipe,
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
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

                          // Nombre
                          LayoutBuilder(builder: (context, constraints) {
                            Widget resultText;

                            final text = _artist.name;
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
                                alignment: Alignment.topCenter,
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

                          // Info
                          CustomContainer(
                              child: Row(
                            children: [
                              Flexible(
                                child: CustomColumn(
                                    title: 'Fans',
                                    value: Text(
                                      humanReadbleNumber(_artist.nbFans),
                                      style: TextStyle(fontSize: 24),
                                    )),
                              ),
                              Flexible(
                                child: CustomColumn(
                                  title: 'Albums',
                                  value: Text(
                                      formatWithThousandsSeparator(
                                          _artist.nbAlbum),
                                      style: TextStyle(fontSize: 24)),
                                  hasDivider: false,
                                ),
                              ),
                            ],
                          )),

                          // Most liked tracks
                          if (_topTracks.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    capitalizeFirstLetter(
                                        text: localization.most_liked_tracks),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),

                                // Container con el top 3 canciones
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomContainer(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: _topTracks.map((track) {
                                          return InkWell(
                                            onTap: () {
                                              context.push(
                                                  '/track?id=${track.id}');
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    track.buildArtistsText(),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${humanReadbleNumber(track.likes)} likes',
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                          // Most liked albums
                          if (_topAlbums.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    capitalizeFirstLetter(
                                        text: localization.most_liked_albums),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),

                                // Container con el top 3 canciones
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomContainer(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: _topAlbums.map((album) {
                                          return InkWell(
                                            onTap: () {
                                              context.push(
                                                  '/album?id=${album.id}');
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      album.md5Image,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    album.title,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${humanReadbleNumber(album.likes)} likes',
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Ver top 100 canciones
                          CustomNavigator(
                            title: Text(
                              capitalizeFirstLetter(
                                  text: localization.see_top_tracks),
                              style: TextStyle(fontSize: 18),
                            ),
                            function: null, // TODO: Que lleve a ver el top 100
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Ver todos los albums
                          CustomNavigator(
                            title: Text(
                              capitalizeFirstLetter(
                                  text: localization.see_all_albums),
                              style: TextStyle(fontSize: 18),
                            ),
                            function:
                                null, // TODO: Que lleve a ver todos los albums
                          ),

                          const SizedBox(
                            height: 20,
                          ),

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

                          // Artistas similares
                          if (_relatedArtists.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    capitalizeFirstLetter(
                                        text: localization.related_artists),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),

                                // Container con los artistas similares
                                CustomContainer(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _relatedArtists.map((artist) {
                                        return InkWell(
                                          onTap: () => context
                                              .push('/artist?id=${artist.id}'),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Column(
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                            artist.pictureXL),
                                                    radius: 36,
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 5,
                                                ),

                                                // Nombre del artista
                                                Text(artist.name)
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              ],
                            ),

                          const SizedBox(
                            height: 20,
                          ),

                          CustomAdvertisimentWidget(),

                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
