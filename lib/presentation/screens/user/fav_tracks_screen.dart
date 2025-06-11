import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para mostrar las canciones favoritas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavTracksScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'fav-track-screen';

  /// UID del usuario
  final String uid;

  /// Lista de IDs de las canciones
  final List<int> tracks;

  const FavTracksScreen({super.key, required this.uid, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return FavTracksView(uid: uid, tracks: tracks,);
  }
}