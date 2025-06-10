import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para mostrar los seguidores <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FollowersScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'followers-screen';

  /// UID del usuario
  final String uid;

  const FollowersScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FollowersView(uid: uid,);
  }
}