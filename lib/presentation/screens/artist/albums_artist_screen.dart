import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Vista que muestra los albumes del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AlbumsArtistScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'albums-artist-screen';

  /// ID del artista
  final int idArtist;

  /// Nombre del artista
  final String nameArtist;

  const AlbumsArtistScreen({super.key, required this.idArtist, required this.nameArtist});

  @override
  Widget build(BuildContext context) {
    return AlbumArtistView(idArtist: idArtist, nameArtist: nameArtist,);
  }
}
