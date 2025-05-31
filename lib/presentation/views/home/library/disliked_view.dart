import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Vista para la pantalla de las canciones con dislike <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class DislikedView extends StatefulWidget {
  /// UID del usuario
  final String uid;

  /// Variable que almacena si debe mostrarse en cuadrícula
  final bool grid;

  /// Callback para notificar el total de canciones
  final Function(int) onTotalChanged;

  const DislikedView({
    super.key,
    required this.uid,
    required this.grid,
    required this.onTotalChanged,
  });

  @override
  State<DislikedView> createState() => _DislikedViewState();
}

class _DislikedViewState extends State<DislikedView>
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
            uid: widget.uid, url: nextUrl, liked: false, limit: limit);
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

    final size = MediaQuery.of(context).size;
    final height = size.height;

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
                child: !widget.grid
                    ? ListView.builder(
                        shrinkWrap: true,
                        // padding: EdgeInsets.zero,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: isLoadingMore
                            ? allTracks.length + 1
                            : allTracks.length,
                        itemBuilder: (context, index) {
                          Widget result;

                          if (index == allTracks.length) {
                            result = const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            Track track = allTracks[index];

                            String artists = buildArtistsText(track: track);

                            if (index == allTracks.length - 1 &&
                                nextUrl.isNotEmpty) {
                              _fetchTracks();
                            }

                            result = ListTracks(
                                track: track,
                                artists: artists,
                                allTracks: allTracks,
                                index: index);
                          }

                          return result;
                        })
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: isLoadingMore
                            ? allTracks.length + 1
                            : allTracks.length,
                        itemBuilder: (context, index) {
                          Widget result;

                          if (index == allTracks.length) {
                            result = const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            Track track = allTracks[index];

                            String artists = buildArtistsText(track: track);

                            if (index == allTracks.length - 1 &&
                                nextUrl.isNotEmpty) {
                              _fetchTracks();
                            }

                            result = CustomContainer(
                                child: Column(
                              children: [
                                // Portada
                                SizedBox(
                                  height: height * 4,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    child: Image.network(
                                      track.md5Image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              ],
                            ));
                          }
                        }),
              );
  }
}
