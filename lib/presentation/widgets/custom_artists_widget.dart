import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado que muestra los artistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomArtistsWidget extends StatelessWidget {
  /// Lista de artistas
  final List<Artist> artists;

  /// Texto identificativo (Likes, Dislikes, Swipes)
  final String text;
  
  const CustomArtistsWidget({
    super.key,
    required this.artists,
    required this.text,
  });


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          Artist artist = artists[index];

          return InkWell(
            onTap: () => context.push('/artist?id=${artist.id}'),
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
                      CustomRoundedImageWidget(path: artist.pictureXL, height: 48),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artist.name,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              '${artist.likes} $text',
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
                  index < artists.length - 1
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
