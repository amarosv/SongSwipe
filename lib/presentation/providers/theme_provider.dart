import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/theme/app_theme.dart';

// Listado de colores inmutables
final colorListProvider = Provider((ref) => colorList);

// Booleano que contiene si el modo oscuro está activado
final isDarModeProvider = StateProvider((ref) => false);

// Entero que contiene el índice del color seleccionado
final selectedColorProvider = StateProvider((ref) => 0);

// Objeto de tipo AppTheme
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  // Constructor
  ThemeNotifier(): super(AppTheme());

  // Función que alterna de modo oscuro a modo claro
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  // Función que cambia el índice del color seleccionado
  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}