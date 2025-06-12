import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado que define como se muestra una canción en un grid <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomGridTracks extends StatelessWidget {
  /// Altura
  final double height;

  /// Canción a mostrar
  final Track track;

  /// Nombre de los artistas
  final String artists;

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

  const CustomGridTracks({
    super.key,
    required this.height,
    required this.track,
    required this.artists,
    required this.index,
    this.isSelecting = false,
    this.isSelected = false,
    this.onSelect,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: index % 2 == 0 ? 10 : 5,
              right: index % 2 == 0 ? 5 : 10),
          child: GestureDetector(
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
            child: Flexible(
              child: CustomContainer(
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Portada
                      SizedBox(
                        height: height * 0.2,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: Image.network(
                            track.md5Image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Título
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: LayoutBuilder(builder: (context, constraints) {
                          Widget resultText;

                          final text = track.title;
                          final textPainter = TextPainter(
                              text: TextSpan(
                                text: text,
                                style: TextStyle(
                                    color: Colors.white,
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
                                    color: Colors.white,
                                    fontSize: 18,
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
                            resultText = SizedBox(
                              height: 25,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            );
                          }

                          return resultText;
                        }),
                      ),

                      const SizedBox(height: 10),

                      // Artistas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: LayoutBuilder(builder: (context, constraints) {
                          Widget resultText;

                          final text = artists;
                          final textPainter = TextPainter(
                              text: TextSpan(
                                text: text,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                    color: Colors.white,
                                    fontSize: 14,
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
                            resultText = SizedBox(
                              height: 25,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            );
                          }

                          return resultText;
                        }),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Fecha e icono si es explícita
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Fecha
                            Text(
                              formatDate(
                                  date: track.releaseDate, context: context),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                            ),

                            // Icono
                            // Truquito para que tengan la misma altura
                            Icon(
                              Icons.explicit,
                              color: track.explicitLyrics ||
                                      track.explicitContentCover == 1 ||
                                      track.explicitContentLyrics == 1
                                  ? Colors.white
                                  : Colors.transparent,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      )
                    ],
                  )),
            ),
          ),
        ),
        if (isSelecting)
          Positioned(
            top: 10,
            right: index % 2 == 0 ? 5 : 10,
            child: GestureDetector(
              onTap: onSelect,
              child: Checkbox(
                shape: CircleBorder(),
                value: isSelected,
                onChanged: (_) => onSelect?.call(),
                checkColor: Colors.white,
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
