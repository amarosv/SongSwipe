import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para crear la cuenta <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SignUpScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const String name = 'sign-up-screen';
  /// Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const SignUpScreen({super.key, required this.onChangeLanguage});

  @override
  Widget build(BuildContext context) {
    return SignUpView(onChangeLanguage: onChangeLanguage);
  }
}