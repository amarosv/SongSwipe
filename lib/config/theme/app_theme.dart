import 'package:flutter/material.dart';

// Mapa de colores para el tema de la aplicación
const colorList = {
  'Blue': Colors.blue,
  'Red': Colors.red,
  'Yellow': Colors.yellow,
  'Pink': Colors.pink
};

class AppTheme {
  // Atributo que almacena el índice del color seleccionado
  final int selectedColor;

  // Atributo que almacena si el modo oscuro está activado
  final bool isDarkMode;

  // Atributo que almacena si se está usando el tema del dispositivo
  final bool isUsingSystem;

  // Constructor con aserciones
  AppTheme({this.selectedColor = 0, this.isDarkMode = false, this.isUsingSystem = false})
      : assert(selectedColor >= 0, 'Selected color must be greater than 0'),
        assert(selectedColor < colorList.length,
            'Selected colormut be less or equal than ${colorList.length - 1}');

  // Devuelve el tema con las configuraciones cargadas
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList.values.toList()[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: true));

  // Método que permite crear una copia de la instancia actual de AppTheme,
  // pero con la posibilidad de sobrescribir algunos de sus valores.
  AppTheme copyWith({int? selectedColor, bool? isDarkMode, bool? isUsingSystem}) => AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isUsingSystem: isUsingSystem ?? this.isUsingSystem);
}
