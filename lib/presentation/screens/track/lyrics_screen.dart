import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla de letras de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LyricsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'lyrics-screen';

  /// Letras de la canción
  final String lyrics;

  /// Título de la canción
  final String trackTitle;

  /// Artistas de la canción
  final String trackArtists;

  /// Url de la imagen de la canción
  final String trackCover;
  
  const LyricsScreen(
      {super.key,
      required this.lyrics,
      required this.trackTitle,
      required this.trackArtists, required this.trackCover});

  @override
  Widget build(BuildContext context) {
    return LyricsView(
        lyrics: lyrics, trackTitle: trackTitle, trackArtists: trackArtists, trackCover: trackCover,);
  }
}
