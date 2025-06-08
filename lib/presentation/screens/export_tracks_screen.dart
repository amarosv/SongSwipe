import 'package:flutter/material.dart';
import 'package:songswipe/models/track.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para exportar canciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ExportTracksScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'export-name';

  /// Lista de canciones
  final Set<Track> tracks;

  const ExportTracksScreen({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ExportTracksView(tracks: tracks);
  }
}