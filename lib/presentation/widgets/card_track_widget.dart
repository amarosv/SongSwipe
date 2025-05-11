import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/helpers/get_dominant_colors.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/export_models.dart';

/// Widget personalizado para mostrar la carta con la información de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CardTrackWidget extends StatefulWidget {
  /// Canción
  final Track track;
  final bool animatedCover;
  const CardTrackWidget(
      {super.key, required this.track, required this.animatedCover});

  @override
  State<CardTrackWidget> createState() => _CardTrackWidgetState();
}

class _CardTrackWidgetState extends State<CardTrackWidget>
    with SingleTickerProviderStateMixin {
  // Controlador de la animación
  late AnimationController _controller;

  // Escala de la animación
  late Animation<double> _scaleAnimation;

  // Color de la carta
  Color _cardBackground = Color.fromARGB(172, 74, 78, 148);

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

    _getDominantColor();
  }

  // Obtenemos el color dominante de la imagen
  void _getDominantColor() async {
    _cardBackground =
        await extractDominantColor(imagePath: widget.track.md5Image);

    // Actualizamos la UI
    setState(() {});
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
          color: _cardBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Usamos AnimatedBuilder para aplicar el zoom in y out constante
                  SizedBox(
                    height: height * 0.5,
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.track.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(date: widget.track.releaseDate, context: context),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    widget.track.explicitLyrics
                        ? Icon(
                            Icons.explicit,
                            color: Colors.white,
                            size: 36,
                          )
                        : Container()
                  ],
                ),
              ),
              const SizedBox(height: 5,)
            ],
          ),
        ),
      ),
    );
  }
}
