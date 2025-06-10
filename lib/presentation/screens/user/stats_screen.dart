import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para ver las Stats del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class StatsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'stats-screen';
  
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatsView();
  }
}