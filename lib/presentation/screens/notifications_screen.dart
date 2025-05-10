import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para los ajustes de notificaciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class NotificationsScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = "notifications-screen";
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsView();
  }
}