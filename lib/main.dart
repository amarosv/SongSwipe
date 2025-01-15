import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/export_config.dart';
import 'package:songswipe/config/router/app_router.dart';
import 'package:songswipe/helpers/preferences.dart';
import 'package:songswipe/presentation/providers/export_providers.dart';

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
  // Variable que almacena el brillo previo
  Brightness _previousBrightness = Brightness.dark;

  // Variable que almacena el país
  Locale _locale = PlatformDispatcher.instance.locale;

  // Inicializa el router
  late final AppRouter _router;

  // Función que obtiene el lenguaje por defecto
  void _getDefaultLanguage() async {
    Locale locale;

    // Cargamos el lenguaje guardado en SharedPreferences
    String languageCode = await loadDataString(tag: 'language');

    // Comprobamos si está vacío
    if (languageCode.isEmpty) {
      // En el caso en el cual no hay guardado ningún lenguaje
      // Obtenemos el lenguaje del dispositivo
      Locale locale = PlatformDispatcher.instance.locale;

      languageCode = locale.languageCode;
    }

    // Inicalizamos el locale
    locale = Locale(languageCode);

    // Cambiamos el locale
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();

    // Cargamos el lenguaje por defecto
    _getDefaultLanguage();

    // Cargamos el AppRouter
    _router = AppRouter(onChangeLanguage: changeLanguage);
  }

  // Función que cambia el lenguage y es llamada por SignUpView, LoginView y el apartado en ajustes
  void changeLanguage(String languageCode) {
    // Guardamos el nuevo lenguaje
    saveData(tag: 'language', value: languageCode);

    // Cambiamos el lenguaje de la app
    setState(() {
      _locale = Locale(languageCode);
    });
  }

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

    return MaterialApp.router(
      title: 'SongSwipe',
      locale: _locale,
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
      routerConfig: _router.router,
    );
  }
}
