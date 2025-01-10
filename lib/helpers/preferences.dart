import 'package:shared_preferences/shared_preferences.dart';

// Función que almacena un valor en SharedPreferences
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

// Cargar un String desde SharedPreferences
Future<String> loadDataString({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(tag) ?? '';
}

// Cargar un int desde SharedPreferences
Future<int> loadDataInt({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(tag) ?? 0;
}
// Cargar un bool desde SharedPreferences
Future<bool> loadDataBool({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(tag) ?? false;
}

// Cargar un double desde SharedPreferences
Future<double> loadDataDouble({required String tag}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(tag) ?? 0;
}