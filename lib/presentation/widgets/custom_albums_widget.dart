import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado que muestra los albumes <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomAlbumsWidget extends StatelessWidget {
  /// Lista de albumes
  final List<Album> albums;

  /// Texto identificativo (Likes, Dislikes, Swipes)
  final String text;

  const CustomAlbumsWidget({
    super.key,
    required this.albums,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          Album album = albums[index];

          return InkWell(
            onTap: () => context.push('/album?id=${album.id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Información del artista
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Imagen del artista
                      const SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image(
                          image: NetworkImage(album.md5Image),
                          width: 64,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              album.artist.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              '${album.likes} $text',
                              style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  index < albums.length - 1
                      ? Divider(color: Colors.white)
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
