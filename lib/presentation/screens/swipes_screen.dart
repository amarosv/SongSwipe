import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para hacer Swipe entre canciones específicas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SwipesScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'swipes-screen';

  /// Lista de canciones
  final List<Track> tracks;

  const SwipesScreen({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return SwipesView(tracks: tracks,);
  }
}