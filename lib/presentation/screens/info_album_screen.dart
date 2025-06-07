import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/info_album_view.dart';

/// Pantalla de información del album <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoAlbumScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'info-album-screen';

  /// ID del album
  final int idAlbum;

  const InfoAlbumScreen({super.key, required this.idAlbum});

  @override
  Widget build(BuildContext context) {
    return InfoAlbumView(idAlbum: idAlbum);
  }
}