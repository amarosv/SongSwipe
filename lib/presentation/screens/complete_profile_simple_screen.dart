import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/complete_profile_simple_view.dart';

/// Pantalla para completar el perfil simple <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CompleteProfileSimpleScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'complete-profile-simple-screen';
  const CompleteProfileSimpleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CompleteProfileSimpleView();
  }
}