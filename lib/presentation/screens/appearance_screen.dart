import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/appearance_view.dart';

/// Pantalla para los ajustes de apariencia <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AppearanceScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = "appearance-screen";
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppearanceView();
  }
}