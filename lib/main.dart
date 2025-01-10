import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/theme/app_theme.dart';
import 'package:songswipe/presentation/providers/theme_provider.dart';
import 'package:songswipe/presentation/screens/change_theme_screen.dart';

void main() {
  runApp(
    // Coloco el ProviderScope para que no de error con FlutterProvider
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Constante que almacena el tema
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme.getTheme(),
      home: const ChangeThemeScreen(),
    );
  }
}
