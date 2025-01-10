import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/presentation/providers/theme_provider.dart';

class ChangeThemeScreen extends ConsumerWidget {
  const ChangeThemeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Constante que almacena si el modo oscuro está activado
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

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
          )
        ],
      ),
      body: Placeholder(),
    );
  }
}