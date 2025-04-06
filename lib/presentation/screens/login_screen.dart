import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para iniciar sesión <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LoginScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'login-screen';
  /// Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const LoginScreen({super.key, required this.onChangeLanguage});

  @override
  Widget build(BuildContext context) {
    return LoginView(
      onChangeLanguage: onChangeLanguage,
    );
  }
}