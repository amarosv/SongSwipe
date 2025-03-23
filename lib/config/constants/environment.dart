import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiUrl = dotenv.env['API_URL'] ?? 'No hay API url';
  static String apiKey = dotenv.env['API_KEY_IMGBB'] ?? 'No hay API key';
}