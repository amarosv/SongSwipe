import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla de información del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoArtistScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'info-artista-screen';
  
  /// ID del artista
  final int idArtist;

  const InfoArtistScreen({super.key, required this.idArtist});

  @override
  Widget build(BuildContext context) {
    return InfoArtistView(idArtist: idArtist);
  }
}