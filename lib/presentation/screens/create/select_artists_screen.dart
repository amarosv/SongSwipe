import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para seleccionar los artistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SelectArtistsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'select-artists-screen';
  const SelectArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectArtistsView();
  }
}