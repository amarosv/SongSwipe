import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/presentation/providers/export_providers.dart';
import 'package:songswipe/presentation/screens/export_screens.dart';

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
    // Obtenemos si se está usando el tema del dispositivo
    final system = ref.watch(themeNotifierProvider).isUsingSystem;

    // Comprobamos si se está usando el tema del dispositivo
    if (system) {
      // Obtenemos el tema actual del dispositivo
      final currentBrightness = MediaQuery.of(context).platformBrightness;

      // Comprobamos si ha habido un cambio en el valor del modo oscuro
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
      title: 'SongSwipe',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('it'), // Italian
      ],
      home: const SignUpScreen(),
    );
  }
}
