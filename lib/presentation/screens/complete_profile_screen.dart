import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/complete_profile_view.dart';

/// Pantalla para completar el perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CompleteProfileScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'complete-profile-screen';
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CompleteProfileView();
  }
}