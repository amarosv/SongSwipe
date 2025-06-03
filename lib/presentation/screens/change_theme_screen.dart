import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/providers/export_providers.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Pantalla para cambiar de tema <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ChangeThemeScreen extends ConsumerWidget {
  /// Nombre de la ruta
  static const name = 'change-theme-screen';
  const ChangeThemeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Constante que almacena si el modo oscuro está activado
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    // Constante que almacena si el modo sistema está activado
    final isUsingSystem = ref.watch(themeNotifierProvider).isUsingSystem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme changer'),
        actions: [
          IconButton(
            onPressed: () {
              // Llamamos al notifier para cambiar de modo
              ref.read(themeNotifierProvider.notifier).toggleDarkMode();
            },
            icon: Icon(isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded)
          ),
          IconButton(
            onPressed: () {
              // Llamamos al notifier para cambiar de modo
              ref.read(themeNotifierProvider.notifier).setUseSystem(isUsingSystem: true);
            },
            icon: Icon(isUsingSystem ? Icons.mobile_friendly_sharp : Icons.mobile_off)
          ),
        ],
      ),
      body: ChangeThemeView(),
    );
  }
}