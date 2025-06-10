import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para mostrar los usuarios a los que sigue <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FollowingScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'following-screen';

  /// UID del usuario
  final String uid;

  const FollowingScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FollowingView(uid: uid);
  }
}