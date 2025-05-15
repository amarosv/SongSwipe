import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para la información de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AboutScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'about-screen';
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AboutView();
  }
}