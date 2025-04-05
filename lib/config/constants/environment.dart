import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase que almacena las constantes privadas de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Environment {
  static String apiUrl = dotenv.env['API_URL'] ?? 'No hay API url';
  static String apiKey = dotenv.env['API_KEY_IMGBB'] ?? 'No hay API key';
  static String apiUrlDeezer = dotenv.env['API_URL_DEEZER'] ?? 'No hay API url';
}