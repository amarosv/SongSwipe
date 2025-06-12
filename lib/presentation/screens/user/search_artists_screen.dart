import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para buscar los artistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SearchArtistsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'search-artists-screen';
  const SearchArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchArtistsView();
  }
}