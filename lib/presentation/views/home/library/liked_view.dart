import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/internal_api.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Vista para la pantalla de las canciones con like <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LikedView extends StatefulWidget {
  /// UID del usuario
  final String uid;

  /// Variable que almacena si debe mostrarse en cuadrícula
  final bool grid;

  /// Callback para notificar el total de canciones
  final Function(int) onTotalChanged;

  const LikedView({
    super.key,
    required this.uid,
    required this.grid,
    required this.onTotalChanged,
  });

  @override
  State<LikedView> createState() => _LikedViewState();
}

class _LikedViewState extends State<LikedView>
    with AutomaticKeepAliveClientMixin {
  // Variable que almacena el próximo enlace
  String nextUrl = '';

  // Variable que almacena el límite de canciones a traer
  int limit = 25;

  // Variable que almacena la lista con todas las canciones
  List<Track> allTracks = [];

  // Variable que indica si se están cargando más canciones
  bool isLoadingMore = false;

  // Variable que indica el número total de canciones
  int totalTracks = 0;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  // Función que obtiene las canciones
  void _fetchTracks() async {
    if (!isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        setState(() => isLoadingMore = true);

        final data = await getLibraryUser(
            uid: widget.uid, url: nextUrl, liked: true, limit: limit);
        setState(() {
          allTracks.addAll(data.tracks);
          nextUrl = data.linkNextPage;
          isLoadingMore = false;
          totalTracks = data.totalTracks;
        });
        widget.onTotalChanged(totalTracks);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localization = AppLocalizations.of(context)!;

    return allTracks.isEmpty && !isLoadingMore
        ? Center(
            child: Text(capitalizeFirstLetter(text: localization.no_tracks)),
          )
        : allTracks.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : VisibilityDetector(
                key: const Key('disliked-view'),
                onVisibilityChanged: (info) =>
                    widget.onTotalChanged(totalTracks),
                child: ListView.builder(
                    shrinkWrap: true,
                    // padding: EdgeInsets.zero,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: allTracks.length,
                    itemBuilder: (context, index) {
                      Widget result;

                      if (index == allTracks.length) {
                        result = const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      Track track = allTracks[index];

                      String artists = buildArtistsText(track: track);

                      if (index == allTracks.length - 1 && nextUrl.isNotEmpty) {
                        _fetchTracks();
                      }

                      result = Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.push('/track?id=${track.id}'),
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
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image(
                                        image: NetworkImage(track.md5Image),
                                        width: 70,
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
                                                final textPainter = TextPainter(
                                                    text: TextSpan(
                                                      text: text,
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    maxLines: 1,
                                                    textDirection:
                                                        TextDirection.ltr)
                                                  ..layout(
                                                      maxWidth: double.infinity);

                                                final textWidth =
                                                    textPainter.size.width;

                                                if (textWidth >
                                                    constraints.maxWidth) {
                                                  resultText = SizedBox(
                                                    height: 25,
                                                    child: Marquee(
                                                      text: text,
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      scrollAxis: Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      blankSpace: 20.0,
                                                      velocity: 40.0,
                                                      pauseAfterRound:
                                                          Duration(seconds: 4),
                                                      startPadding: 0.0,
                                                      accelerationDuration:
                                                          Duration(seconds: 2),
                                                      accelerationCurve:
                                                          Curves.linear,
                                                      decelerationDuration:
                                                          Duration(
                                                              milliseconds: 500),
                                                      decelerationCurve:
                                                          Curves.easeOut,
                                                    ),
                                                  );
                                                } else {
                                                  resultText = Text(
                                                    text,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  );
                                                }

                                                return resultText;
                                              }),

                                              // Artistas
                                              LayoutBuilder(builder:
                                                  (context, constraints) {
                                                Widget resultText;

                                                final text = artists;
                                                final textPainter = TextPainter(
                                                    text: TextSpan(
                                                      text: text,
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    maxLines: 1,
                                                    textDirection:
                                                        TextDirection.ltr)
                                                  ..layout(
                                                      maxWidth: double.infinity);

                                                final textWidth =
                                                    textPainter.size.width;

                                                if (textWidth >
                                                    constraints.maxWidth) {
                                                  resultText = SizedBox(
                                                    height: 20,
                                                    child: Marquee(
                                                      text: text,
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          fontSize: 14,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      scrollAxis: Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      blankSpace: 20.0,
                                                      velocity: 40.0,
                                                      pauseAfterRound:
                                                          Duration(seconds: 4),
                                                      startPadding: 0.0,
                                                      accelerationDuration:
                                                          Duration(seconds: 2),
                                                      accelerationCurve:
                                                          Curves.linear,
                                                      decelerationDuration:
                                                          Duration(
                                                              milliseconds: 500),
                                                      decelerationCurve:
                                                          Curves.easeOut,
                                                    ),
                                                  );
                                                } else {
                                                  resultText = Text(
                                                    text,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  );
                                                }

                                                return resultText;
                                              }),

                                              // Fecha de lanzamiento
                                              Text(
                                                formatDate(
                                                    date: track.releaseDate,
                                                    context: context),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              )
                                            ],
                                          ),
                                          if (track.explicitLyrics ||
                                              track.explicitContentCover == 1 ||
                                              track.explicitContentLyrics == 1)
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.explicit,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
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
                                index < allTracks.length - 1
                                    ? Divider(
                                        color:
                                            Theme.of(context).colorScheme.primary)
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      );

                      return result;
                    }),
              );
  }
}
