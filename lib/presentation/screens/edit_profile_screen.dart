import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para editar el perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class EditProfileScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'edit-profile-screen';
  
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EditProfileView();
  }
}