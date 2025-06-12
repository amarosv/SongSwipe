import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/export_config.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/export_providers.dart';
import 'package:songswipe/config/router/app_router.dart';
import 'package:songswipe/firebase_options.dart';
import 'package:songswipe/helpers/preferences.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/internal_api.dart';

Future<void> main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Bloqueamos la orientación a portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializamos Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cargamos el .env
  await dotenv.load(fileName: '.env');

  // Corremos la aplicación
  runApp(const ProviderScope(child: MyApp()));
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
  Locale? _locale;

  // Inicializa el router
  AppRouter? _router;

  @override
  void initState() {
    super.initState();

    // Cargamos los datos
    _loadData();

    // Cargamos el lenguaje por defecto
    // _getDefaultLanguage();

    // _getUserProfile();
  }

  void _loadData() async {
    String languageCode = 'en';

    // Obtenemos el usuario actual
    final User? user = FirebaseAuth.instance.currentUser;

    // Variable que almacena el uid del usuario
    late String uid;

    Locale locale;

    if (user != null) {
      uid = user.uid;

      try {
        final results = await Future.wait(
            [getUserSettings(uid: uid)]);
        UserSettings settings = results[0];

        languageCode = settings.language;
        setState(() {
          
        });
      } catch (e) {
        print(e);
      }
    } else {
      // Cargamos el lenguaje guardado en SharedPreferences
      languageCode = await loadDataString(tag: 'language');

      // Comprobamos si está vacío
      if (languageCode.isEmpty) {
        // En el caso en el cual no hay guardado ningún lenguaje
        // Obtenemos el lenguaje del dispositivo
        locale = WidgetsBinding.instance.platformDispatcher.locale;

        languageCode = locale.languageCode;
        setState(() {
          
        });
      }
    }

    if (languageCode.isNotEmpty) {
      _locale = Locale(languageCode);
    }

    // Cargamos el AppRouter
    _router =
        AppRouter(onChangeLanguage: changeLanguage);

    setState(() {
      FlutterNativeSplash.remove();
    });
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
    if (_router == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

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

        // Actualizamos el brillo previo
        _previousBrightness = currentBrightness;
      }
    }

    // Obtenemos el tema desde Riverpod
    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'SongSwipe',
      locale: _locale ?? const Locale('en'),
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
      routerConfig: _router!.router,
    );
  }
}
