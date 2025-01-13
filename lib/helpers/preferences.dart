import 'package:shared_preferences/shared_preferences.dart';

/// Función que almacena un valor en SharedPreferences <br>
/// @parama tag Titulo de la etiqueta donde se almacenará el valor <br>
/// @param value Valor a almacenar
void saveData({required String tag, required dynamic value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Comprobamos de que tipo es el valor
  if (value is String) {
    await prefs.setString(tag, value);
  } else if (value is int) {
    await prefs.setInt(tag, value);
  } else if (value is bool) {
    await prefs.setBool(tag, value);
  } else if (value is double) {
    await prefs.setDouble(tag, value);
  }
}

/// Función que carga un String desde SharedPreferences <br>
/// @param tag Título de la etiqueta donde está almacenado el String <br>
/// @return String almacenado en la etiqueta
Future<String> loadDataString({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(tag) ?? '';
}

/// Función que carga un int desde SharedPreferences <br>
/// @param tag Título de la etiqueta donde está almacenado el int <br>
/// @return int almacenado en la etiqueta
Future<int> loadDataInt({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(tag) ?? 0;
}

/// Función que carga un bool desde SharedPreferences <br>
/// @param tag Título de la etiqueta donde está almacenado el bool <br>
/// @return bool almacenado en la etiqueta
Future<bool> loadDataBool({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(tag) ?? false;
}

/// Función que carga un double desde SharedPreferences <br>
/// @param tag Título de la etiqueta donde está almacenado el double <br>
/// @return double almacenado en la etiqueta
Future<double> loadDataDouble({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(tag) ?? 0;
}
