import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista de información del album <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoAlbumView extends StatefulWidget {
  /// ID del album
  final int idAlbum;

  const InfoAlbumView({super.key, required this.idAlbum});

  @override
  State<InfoAlbumView> createState() => _InfoAlbumViewState();
}

class _InfoAlbumViewState extends State<InfoAlbumView> {
  // ScrollController
  final ScrollController _scrollController = ScrollController();

  // Variable que almacena los datos del album
  late Album _album;

  // Variable que almacena las stats
  late Stats _stats;

  // Variable que almacena a los artistas y contribuidores
  late List<Artist> _artists = List.empty();

  // Variable que almacena el número de canciones
  late int _totalTracks;

  // Variable que almacena las stats de cada canción
  late Map<int, Stats> _tracksStats = <int, Stats>{};

  // Variable que almacena el género del album
  late Genre _genre = Genre.empty();

  // Variable que almacena si se esta cargando el album
  bool _isLoading = true;

  // Variable que almacena la opacidad del texto del titulo del appbar
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    print(widget.idAlbum);
    _loadData();
    _scrollController.addListener(_updateTextOpacity);
  }

  // Función para obtener todos los datos
  void _loadData() async {
    if (!mounted) return;
    try {
      final results = await Future.wait([
        getAlbumById(albumID: widget.idAlbum),
        getAlbumStats(idAlbum: widget.idAlbum)
      ]);

      _album = results[0] as Album;

      final resultsTracks = await Future.wait([
        getTracksStats(
            idTracks: _album.tracks.map((track) => track.id).toList()),
        getGenreById(genreID: _album.genreId)
      ]);

      setState(() {
        _totalTracks = _album.tracks.length;
        _artists = {_album.artist, ..._album.contributors}
            .toList()
            .fold<List<Artist>>([], (unique, artist) {
          if (unique.any((a) => a.id == artist.id)) return unique;
          return [...unique, artist];
        });
        _stats = results[1] as Stats;
        _tracksStats = resultsTracks[0] as Map<int, Stats>;
        _genre = resultsTracks[1] as Genre;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading album data: $e');
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
    _scrollController.removeListener(_updateTextOpacity);
    _scrollController.dispose();
    super.dispose();
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

                        final text = _album.title;
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
                      _album.md5Image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () =>
                          context.push('/swipes'), // TODO: Añadir las canciones
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
                        const SizedBox(height: 10),

                        // Título del album
                        LayoutBuilder(builder: (context, constraints) {
                          Widget resultText;
                                            
                          final text = _album.title;
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
                                            backgroundImage:
                                                NetworkImage(artist.pictureBig),
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
                                  value: _album.releaseDate,
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: capitalizeFirstLetter(
                                      text: localization.duration),
                                  value: formatDuration(_album.duration),
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: capitalizeFirstLetter(
                                      text: localization.number_songs),
                                  value: _album.nbTracks.toString(),
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: capitalizeFirstLetter(
                                      text: localization.type),
                                  value: capitalizeFirstLetter(
                                      text: _album.recordType),
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: capitalizeFirstLetter(
                                      text: localization.genre),
                                  value:
                                      capitalizeFirstLetter(text: _genre.name),
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: 'Fans',
                                  value: humanReadbleNumber(_album.fans),
                                ),
                                const SizedBox(height: 20),
                                CustomRow(
                                  title: capitalizeFirstLetter(
                                      text: localization.explicit_content),
                                  value: capitalizeFirstLetter(
                                      text: _album.explicitLyrics ||
                                              _album.explicitContentCover ==
                                                  1 ||
                                              _album.explicitContentLyrics == 1
                                          ? localization.yes
                                          : localization.no),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                    
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
                    
                        const SizedBox(
                          height: 20,
                        ),
                    
                        // Tracklist
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(text: localization.tracks),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                    
                        // Container con las canciones
                        CustomContainer(
                          child: Column(
                            children:
                                _album.tracks.asMap().entries.map((entry) {
                              int index = entry.key;
                              Track track = entry.value;
                                            
                              return InkWell(
                                onTap: () =>
                                    context.push('/track?id=${track.id}'),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Portada
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image(
                                              image:
                                                  NetworkImage(track.md5Image),
                                              width: 80,
                                            ),
                                          ),
                                            
                                          const SizedBox(width: 20),
                                            
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Título
                                                    LayoutBuilder(builder:
                                                        (context, constraints) {
                                                      Widget resultText;
                                            
                                                      final text = track.title;
                                                      final textPainter =
                                                          TextPainter(
                                                              text: TextSpan(
                                                                text: text,
                                                                style: TextStyle(
                                                                    // color: Theme.of(
                                                                    //         context)
                                                                    //     .colorScheme
                                                                    //     .primary,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    overflow: TextOverflow.ellipsis),
                                                              ),
                                                              maxLines: 1,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr)
                                                            ..layout(
                                                                maxWidth: double
                                                                    .infinity);
                                            
                                                      final textWidth =
                                                          textPainter
                                                              .size.width;
                                            
                                                      if (textWidth >
                                                          constraints
                                                              .maxWidth) {
                                                        resultText = SizedBox(
                                                          height: 25,
                                                          child: Marquee(
                                                            text: text,
                                                            style: TextStyle(
                                                                // color: Theme.of(
                                                                //         context)
                                                                //     .colorScheme
                                                                //     .primary,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            scrollAxis:
                                                                Axis.horizontal,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            blankSpace: 20.0,
                                                            velocity: 40.0,
                                                            pauseAfterRound:
                                                                Duration(
                                                                    seconds: 4),
                                                            startPadding: 0.0,
                                                            accelerationDuration:
                                                                Duration(
                                                                    seconds: 2),
                                                            accelerationCurve:
                                                                Curves.linear,
                                                            decelerationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            decelerationCurve:
                                                                Curves.easeOut,
                                                          ),
                                                        );
                                                      } else {
                                                        resultText = Text(
                                                          text,
                                                          style: TextStyle(
                                                              // color: Theme.of(
                                                              //         context)
                                                              //     .colorScheme
                                                              //     .primary,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        );
                                                      }
                                            
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                                32), // espacio para el icono de explícito
                                                        child: resultText,
                                                      );
                                                    }),
                                            
                                                    const SizedBox(height: 5),
                                            
                                                    // Artistas
                                                    LayoutBuilder(builder:
                                                        (context, constraints) {
                                                      Widget resultText;
                                            
                                                      final text = track
                                                          .buildArtistsText();
                                                      final textPainter =
                                                          TextPainter(
                                                              text: TextSpan(
                                                                text: text,
                                                                style: TextStyle(
                                                                    // color: Theme.of(
                                                                    //         context)
                                                                    //     .colorScheme
                                                                    //     .primary,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    overflow: TextOverflow.ellipsis),
                                                              ),
                                                              maxLines: 1,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr)
                                                            ..layout(
                                                                maxWidth: double
                                                                    .infinity);
                                            
                                                      final textWidth =
                                                          textPainter
                                                              .size.width;
                                            
                                                      if (textWidth >
                                                          constraints
                                                              .maxWidth) {
                                                        resultText = SizedBox(
                                                          height: 20,
                                                          child: Marquee(
                                                            text: text,
                                                            style: TextStyle(
                                                                // color: Theme.of(
                                                                //         context)
                                                                //     .colorScheme
                                                                //     .primary,
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            scrollAxis:
                                                                Axis.horizontal,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            blankSpace: 20.0,
                                                            velocity: 40.0,
                                                            pauseAfterRound:
                                                                Duration(
                                                                    seconds: 4),
                                                            startPadding: 0.0,
                                                            accelerationDuration:
                                                                Duration(
                                                                    seconds: 2),
                                                            accelerationCurve:
                                                                Curves.linear,
                                                            decelerationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            decelerationCurve:
                                                                Curves.easeOut,
                                                          ),
                                                        );
                                                      } else {
                                                        resultText = Text(
                                                          text,
                                                          style: TextStyle(
                                                              // color: Theme.of(
                                                              //         context)
                                                              //     .colorScheme
                                                              //     .primary,
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        );
                                                      }
                                            
                                                      return resultText;
                                                    }),
                                            
                                                    const SizedBox(height: 5),
                                            
                                                    // Stats de la canción
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        '${_tracksStats[track.id]!.likes} Likes · ${_tracksStats[track.id]!.dislikes} Dislikes · ${_tracksStats[track.id]!.swipes} Swipes',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          // color: Theme.of(context).colorScheme.primary
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                if (track.explicitLyrics ||
                                                    track.explicitContentCover ==
                                                        1 ||
                                                    track.explicitContentLyrics ==
                                                        1)
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Icon(
                                                      Icons.explicit,
                                                      // color: Theme.of(context)
                                                      //     .colorScheme
                                                      //     .primary,
                                                      size: 28,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      index < _totalTracks - 1
                                          ? Divider(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    
                        const SizedBox(height: 20),
                    
                        CustomAdvertisimentWidget(),
                    
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
