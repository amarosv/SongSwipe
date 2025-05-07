import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para elegir el idioma de la aplicación <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LanguageScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'language-screen';
  /// Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const LanguageScreen({super.key, required this.onChangeLanguage});

  @override
  Widget build(BuildContext context) {
    return LanguageView(onChangeLanguage: onChangeLanguage);
  }
}