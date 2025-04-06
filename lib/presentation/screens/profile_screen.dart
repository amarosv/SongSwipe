import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla de perfil del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ProfileScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'profile-screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}