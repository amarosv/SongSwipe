import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para buscar los géneros <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SearchGenresScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'search-genres-screen';
  const SearchGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchGenresView();
  }
}