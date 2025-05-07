import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para los ajustes de privacidad <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PrivacyScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'privacy-screen';

  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrivacyView();
  }
}