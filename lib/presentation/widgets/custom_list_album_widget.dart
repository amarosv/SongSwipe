import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/export_models.dart';

/// Widget personalizado que muestra como se lista un album <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomListAlbumWidget extends StatelessWidget {
  /// Album
  final Album album;

  /// Índice
  final int index;

  /// Total de albums
  final int albumsLength;

  const CustomListAlbumWidget(
      {super.key,
      required this.album,
      required this.index,
      required this.albumsLength});

  @override
  Widget build(BuildContext context) {
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
                        formatDate(date: album.releaseDate, context: context),
                        style: TextStyle(
                            fontSize: 16, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            index < albumsLength - 1
                ? Divider(color: Theme.of(context).colorScheme.primary)
                : Container()
          ],
        ),
      ),
    );
  }
}
