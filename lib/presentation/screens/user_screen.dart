import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla de usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'user-screen';

  /// UID del usuario
  final String uidUser;

  const UserScreen({super.key, required this.uidUser});

  @override
  Widget build(BuildContext context) {
    return UserView(uidUser: uidUser);
  }
}