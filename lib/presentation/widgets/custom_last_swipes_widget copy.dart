import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado que muestra los últimos 5 swipes del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomLastSwipesWidget extends StatelessWidget {
  /// Lista de canciones
  final List<Track> tracks;

  const CustomLastSwipesWidget({
    super.key,
    required this.tracks,
  });


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          Track track = tracks[index];
      
          return InkWell(
            onTap: () => context
                .push('/track?id=${track.id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Información de la canción
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                                6),
                        child: Image(
                          image: NetworkImage(
                              track.md5Image),
                          width: 64,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              track.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  overflow:
                                      TextOverflow
                                          .ellipsis),
                            ),
                            Text(
                              track.buildArtistsText(),
                              style: TextStyle(
                                  fontSize: 14,
                                  overflow:
                                      TextOverflow
                                          .ellipsis),
                            )
                          ],
                        ),
                      ),
                      track.like
                          ? Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                              size: 28,
                            )
                          : Icon(
                              Icons.thumb_down,
                              color: Colors.red,
                              size: 28,
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  index < tracks.length - 1
                      ? Divider(
                          color: Colors.white)
                      : Container()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}