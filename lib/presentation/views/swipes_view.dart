import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';

/// Vista para la pantalla de deslizar canciones específicas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SwipesView extends StatefulWidget {
  /// Lista de canciones
  final List<Track> tracks;
  
  const SwipesView({super.key, required this.tracks});

  @override
  State<SwipesView> createState() => _SwipesViewState();
}

class _SwipesViewState extends State<SwipesView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}