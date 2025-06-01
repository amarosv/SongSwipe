import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';

/// Widget personalizado que define como se muestra una canción en una lista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomListTracks extends StatelessWidget {
  /// Canción a mostrar
  final Track track;

  /// Nombre de los artistas
  final String artists;

  /// Número de canciones en la lista
  final int allTracksLength;

  /// Indice en la lista
  final int index;

  /// Variable que indica si se está seleccionando canciones
  final bool isSelecting;

  /// Variable que indica si se ha seleccionado
  final bool isSelected;

  /// Función que se ejecuta al seleccionar o deseleccionar
  final VoidCallback? onSelect;

  /// Función que se ejecuta para refrescar la lista
  final VoidCallback? onRefresh;

  const CustomListTracks({
    super.key,
    required this.track,
    required this.artists,
    required this.allTracksLength,
    required this.index,
    this.isSelecting = false,
    this.isSelected = false,
    this.onSelect,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (isSelecting) {
            onSelect!();
          } else {
            final result = await context.push('/track?id=${track.id}');

            if (result == true) {
              onRefresh?.call();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isSelecting)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                        shape: CircleBorder(),
                        value: isSelected,
                        onChanged: (_) => onSelect?.call(),
                        checkColor: Colors.white,
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  // Portada
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: NetworkImage(track.md5Image),
                      width: 80,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            LayoutBuilder(builder: (context, constraints) {
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
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr)
                                ..layout(maxWidth: double.infinity);

                              final textWidth = textPainter.size.width;

                              if (textWidth > constraints.maxWidth) {
                                resultText = SizedBox(
                                  height: 25,
                                  child: Marquee(
                                    text: text,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  text,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.only(
                                    right:
                                        32), // espacio para el icono de explícito
                                child: resultText,
                              );
                            }),

                            // Artistas
                            LayoutBuilder(builder: (context, constraints) {
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
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr)
                                ..layout(maxWidth: double.infinity);

                              final textWidth = textPainter.size.width;

                              if (textWidth > constraints.maxWidth) {
                                resultText = SizedBox(
                                  height: 20,
                                  child: Marquee(
                                    text: text,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  text,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }

                              return resultText;
                            }),

                            // Fecha de lanzamiento
                            Text(
                              formatDate(
                                  date: track.releaseDate, context: context),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
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
                              color: Theme.of(context).colorScheme.primary,
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
              index < allTracksLength - 1
                  ? Divider(color: Theme.of(context).colorScheme.primary)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
