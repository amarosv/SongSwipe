import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/views/artist/top_tracks_artist_view.dart';

/// Pantalla que muestra las canciones top del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class TopTracksArtistScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'top-tracks-screen';

  /// Lista de canciones
  final List<Track> tracks;

  /// Nombre del artista
  final String artistName;

  const TopTracksArtistScreen({super.key, required this.tracks, required this.artistName});

  @override
  Widget build(BuildContext context) {
    return TopTracksArtistView(tracks: tracks, artistName: artistName,);
  }
}