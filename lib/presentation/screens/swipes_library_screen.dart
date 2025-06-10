import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para hacer Swipe entre canciones específicas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SwipesLibraryScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'swipes-library-screen';

  /// Lista de ids canciones
  final List<int> tracks;

  const SwipesLibraryScreen({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return SwipesLibraryView(tracks: tracks,);
  }
}