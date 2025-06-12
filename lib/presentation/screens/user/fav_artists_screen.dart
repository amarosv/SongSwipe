import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para mostrar los artistas favoritos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavArtistsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'fav-artists-screen';

  const FavArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FavArtistsView();
  }
}