import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para los ajustes de audio <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AudioScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'audio-screen';
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioView();
  }
}