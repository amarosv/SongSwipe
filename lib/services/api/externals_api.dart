import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';

/// Función que recibe un UID de un usuario y una imagen en base 64 y la sube a imgbb <br>
/// @param uid UID del usuario <br>
/// @param base64Image Imagen en base 64 <br>
/// @returns Url de la imagen
Future<String> saveImageInImgbb(String uid, String base64Image) async {
  // Variable donde se almacenará la url de la imagen
  String urlImage;

  Uri url =
      Uri.parse('https://api.imgbb.com/1/upload?name=$uid-${DateTime.now()}');

  // Subimos la imagen
  final response = await http.post(
    url,
    body: {
      'key': Environment.apiKey,
      'image': base64Image,
    },
  );

  // Obtenemos la url de la imagen
  urlImage = jsonDecode(response.body)['data']['url'];

  return urlImage;
}