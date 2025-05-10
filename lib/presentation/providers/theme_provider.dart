import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/export_config.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_settings.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Listado de colores inmutables
final colorListProvider = Provider((ref) => colorList);

/// Booleano que contiene si el modo oscuro está activado
final isDarModeProvider =
    StateProvider((ref) => loadDataBool(tag: 'isDarkMode'));

/// Entero que contiene el índice del color seleccionado
final selectedColorProvider =
    StateProvider((ref) => loadDataInt(tag: 'selectedColorTheme'));

/// Objeto de tipo AppTheme
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(ref: ref),
);

/// Clase que almacena los atributos del ThemeNotifier y que extiende de AppTheme <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ThemeNotifier extends StateNotifier<AppTheme> {
  /// Ref del provider
  final Ref ref;

  /// Constructor que llama al constructor padre
  /// @param ref Ref del provider
  ThemeNotifier({required this.ref}) : super(AppTheme()) {
    _loadInitialConfig();
  }

  /// Función que carga la configuración establecida del tema
  void _loadInitialConfig() async {
    // Obtenemos el usuario actual
    final User? user = FirebaseAuth.instance.currentUser;

    // Variable que almacena el uid del usuario
    late String uid;

    bool system = true;
    bool darkMode = false;
    int theme = 0;

    // Comprobamos si el usuario se ha identificado
    if (user != null) {
      uid = user.uid;

      UserSettings userSettings = await getUserSettings(uid: uid);

      // Colocamos el tema
      theme = userSettings.theme;

      // Lo inicializamos a false para no repetir en el caso 1 y 2
      system = false;
      // await saveData(tag: 'systemTheme', value: false);
      
      switch (userSettings.mode) {
        case 1:
          darkMode = true;
          // await saveData(tag: 'isDarkMode', value: true);
          break;
        case 2:
          darkMode = false;
          // await saveData(tag: 'isDarkMode', value: false);
          break;
        case 3:
          system = true;
          // await saveData(tag: 'systemTheme', value: true);
          break;
      }
    }

    // Cargamos si se usa el tema del dispositivo
    // bool system = await loadDataBool(tag: 'systemTheme');

    if (system) {
      // Cargamos el índice del color seleccionado y el valor del modo oscuro
      // y lo asignamos al tema
      // final colorIndex = await loadDataInt(tag: 'selectedColorTheme');

      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      darkMode = brightness == Brightness.dark;

      state = state.copyWith(
          selectedColor: theme,
          isDarkMode: darkMode,
          isUsingSystem: system);
    } else {
      // Agrupo los Future para reducir tiempo de carga
      List<Future> futureLists = [
        loadDataInt(tag: 'selectedColorTheme'),
        loadDataBool(tag: 'isDarkMode')
      ];

      // Espero a los Future
      // List<dynamic> results = await Future.wait(futureLists);

      // Recojo los resultados
      // final colorIndex = results[0];
      // darkMode = results[1];

      state = state.copyWith(
          selectedColor: theme,
          isDarkMode: darkMode,
          isUsingSystem: system);
    }
  }

  /// Función que alterna de modo oscuro a modo claro
  void toggleDarkMode() {
    bool darkMode = !state.isDarkMode;

    state = state.copyWith(isDarkMode: darkMode);

    saveData(tag: 'isDarkMode', value: darkMode);
  }

  /// Función que coloca el modo de la aplicación
  void setDarkMode({required isDarkMode}) {
    state = state.copyWith(isDarkMode: isDarkMode);

    saveData(tag: 'isDarkMode', value: isDarkMode);
  }

  /// Función que cambia el índice del color seleccionado
  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);

    saveData(tag: 'selectedColorTheme', value: colorIndex);
  }

  /// Función que coloca si se usa el tema del dispositivo
  void setUseSystem({required isUsingSystem}) async {
    saveData(tag: 'systemTheme', value: isUsingSystem);

    // // Obtenemos el valor del modo oscuro
    // // Esto se hace para que cuando se desactive el uso del tema del dispositivo
    // // la pantalla no se ponga en blanco si el dispositivo estaba en modo oscuro o viceversa
    // var brightness =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // bool darkMode = brightness == Brightness.dark;

    // // Guardamos el valor del modo oscuro
    // await saveData(tag: 'isDarkMode', value: darkMode);

    // Llamamos a cargar la configuración inicial
    _loadInitialConfig();
  }

  /// Función que recibe el estado del modo oscuro y lo coloca en el tema
  void putSystemTheme({required bool darkMode}) {
    state = state.copyWith(isDarkMode: darkMode);
  }
}
