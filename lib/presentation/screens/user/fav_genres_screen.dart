import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para mostrar los géneros favoritos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavGenresScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'fav-genres-screen';

  const FavGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FavGenresView();
  }
}