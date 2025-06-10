import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para ver las Stats del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class StatsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'stats-screen';

  /// UID del usuario
  final String uid;
  
  const StatsScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StatsView(uid: uid);
  }
}