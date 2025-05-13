import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';

/// Widget personalizado para mostrar la carta con la información de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CardTrackWidget extends StatefulWidget {
  /// Canción
  final Track track;
  final bool animatedCover;
  final Color cardBackground;
  const CardTrackWidget(
      {super.key, required this.track, required this.animatedCover, required this.cardBackground});

  @override
  State<CardTrackWidget> createState() => _CardTrackWidgetState();
}

class _CardTrackWidgetState extends State<CardTrackWidget>
    with SingleTickerProviderStateMixin {
  // Controlador de la animación
  late AnimationController _controller;

  // Escala de la animación
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 3500), // Duración del ciclo de zoom
    )..repeat(reverse: true); // Repetir animación hacia adelante y hacia atrás

    // Definir el tween para animar el zoom de la imagen
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // Construye la cadena de artistas y contributors
  String _buildArtistsText() {
    final names = <String>{};
    names.add(widget.track.artist.name);
    for (final contributor in widget.track.contributors) {
      names.add(contributor.name);
    }
    return names.join(', ');
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos del controlador de animación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BlurryContainer(
          height: height,
          padding: EdgeInsets.zero,
          blur: 10,
          elevation: 0,
          color: widget.cardBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Usamos AnimatedBuilder para aplicar el zoom in y out constante
                  SizedBox(
                    height: height * 0.45,
                    width: double.infinity,
                    child: ClipRRect(
                      child: widget.animatedCover
                          ? AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: Image.network(
                                    widget.track.md5Image,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              widget.track.md5Image,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
      
                  // Título de la canción
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final text = widget.track.title;
                          final textPainter = TextPainter(
                            text: TextSpan(
                              text: text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          )..layout(maxWidth: double.infinity);

                          final textWidth = textPainter.size.width;

                          if (textWidth > constraints.maxWidth) {
                            return SizedBox(
                              height: 30,
                              child: Marquee(
                                text: text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 40.0,
                                pauseAfterRound: Duration(seconds: 4),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 2),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            );
                          } else {
                            return Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
      
                  // Artistas de la canción
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final text = _buildArtistsText();
                          final textPainter = TextPainter(
                            text: TextSpan(
                                text: text, style: const TextStyle(fontSize: 16)),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          )..layout(maxWidth: double.infinity);
      
                          final textWidth = textPainter.size.width;
      
                          if (textWidth > constraints.maxWidth) {
                            return SizedBox(
                              height: 30,
                              child: Marquee(
                                text: text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 40.0,
                                pauseAfterRound: Duration(seconds: 4),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 2),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            );
                          } else {
                            return Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      
              // Ranking e icono si la canción es explícita
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#${formatWithThousandsSeparator(widget.track.rank)} ${localization.in_ranking}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.track.explicitLyrics)
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.explicit,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                  ],
                ),
              ),
              // const SizedBox(height: 1,)
            ],
          ),
        ),
      ),
    );
  }
}
