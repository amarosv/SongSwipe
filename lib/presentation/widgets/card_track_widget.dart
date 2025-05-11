import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';

/// Widget personalizado para mostrar la carta con la información de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CardTrackWidget extends StatefulWidget {
  /// Canción
  final Track track;
  final bool animatedCover;
  const CardTrackWidget({super.key, required this.track, required this.animatedCover});

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
          color: const Color.fromARGB(172, 74, 78, 148),
          child: Column(
            children: [
              // Usamos AnimatedBuilder para aplicar el zoom in y out constante
              SizedBox(
                height:
                    height * 0.4, // Altura fija para mantener la imagen contenida
                width: double.infinity, // Ajustar al ancho completo
                child: ClipRRect(
                  // Mantener los bordes redondeados
                  child: widget.animatedCover
                    ? AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation
                              .value, // Aplicar la animación de escala
                          child: Image.network(
                            widget.track.md5Image,
                            fit: BoxFit
                                .fill, // Ajustar la imagen al tamaño del contenedor
                          ),
                        );
                      },
                    )
                    : Image.network(
                      widget.track.md5Image,
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}