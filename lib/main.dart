import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/presentation/providers/theme_provider.dart';
import 'package:songswipe/presentation/screens/change_theme_screen.dart';

void main() {
  runApp(
      // Coloco el ProviderScope para que no de error con FlutterProvider
      const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Brightness _previousBrightness = Brightness.dark;

  @override
  Widget build(BuildContext context) {
    // Obtenemos si se está usando el tema del sistema
    final system = ref.watch(themeNotifierProvider).isUsingSystem;

    // Verificar si el brillo ha cambiado y hacer un print
    if (system) {
      // Obtenemos el tema actual del dispositivo
      final currentBrightness = MediaQuery.of(context).platformBrightness;
      
      if (currentBrightness != _previousBrightness) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          bool darkMode = currentBrightness == Brightness.dark;
          ref
              .read(themeNotifierProvider.notifier)
              .putSystemTheme(darkMode: darkMode);
        });
        
        // Actualizamos el previo
        _previousBrightness = currentBrightness;
      }
    }

    // Obtenemos el tema desde Riverpod
    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      home: const ChangeThemeScreen(),
    );
  }
}
