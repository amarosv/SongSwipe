import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/create/select_genres_view.dart';

/// Pantalla para seleccionar los géneros <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SelectGenresScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'select-genres-screen';
  const SelectGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectGenresView();
  }
}