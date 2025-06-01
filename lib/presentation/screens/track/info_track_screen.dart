import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla de información de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoTrackScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'info-track-screen';
  
  /// ID de la canción a mostrar
  final int idTrack;
  
  const InfoTrackScreen({super.key, required this.idTrack});

  @override
  Widget build(BuildContext context) {
    return InfoTrackView(idTrack: idTrack);
  }
}