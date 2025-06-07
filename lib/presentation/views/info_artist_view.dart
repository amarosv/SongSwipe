import 'package:flutter/material.dart';

/// Vista de la información del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class InfoArtistView extends StatefulWidget {
  /// ID del artista
  final int idArtist;

  const InfoArtistView({super.key, required this.idArtist});

  @override
  State<InfoArtistView> createState() => _InfoArtistViewState();
}

class _InfoArtistViewState extends State<InfoArtistView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}