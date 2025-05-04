import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase que almacena las constantes privadas de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Environment {
  /// Url de la api interna
  static String apiUrl = dotenv.env['API_URL'] ?? 'No hay API url';
  /// Url de la api de Deezer
  static String apiUrlDeezer = dotenv.env['API_URL_DEEZER'] ?? 'No hay API url';
  /// Api key de imgbb
  static String apiKeyImgbb = dotenv.env['API_KEY_IMGBB'] ?? 'No hay API key';
  /// Api key pública de imagekit
  static String apiKeyPublicImageKit = dotenv.env['API_KEY_IMAGEKIT_PUBLIC'] ?? 'No hay API key';
  /// Api key privada de imagekit
  static String apiKeyPrivateImageKit = dotenv.env['API_KEY_IMAGEKIT_PRIVATE'] ?? 'No hay API key';
}