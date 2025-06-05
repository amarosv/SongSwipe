import 'dart:convert';
import 'dart:io';

import 'package:flutter_imagekit/flutter_imagekit.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/helpers/utils.dart';

/// Función que recibe un UID de un usuario y una imagen en base 64 y la sube a imagekit <br>
/// @param uid UID del usuario <br>
/// @param image Imagen <br>
/// @returns Url de la imagen
Future<String> saveImageInImagekit(String uid, File image) async {
  // // Variable donde se almacenará la url de la imagen
  // String urlImage = '';

  // Uri url = Uri.parse('https://upload.imagekit.io/api/v1/files/upload');

  // // Subimos la imagen
  // final response = await http.post(
  //   url,
  //   headers: {
  //     'Authorization':
  //         'Basic ${base64Encode(utf8.encode(Environment.apiKeyPublicImageKit))}', // sin private key aquí
  //   },
  //   body: {
  //     'file': base64Image,
  //     'fileName': '$uid-${DateTime.now()}',
  //   },
  // );

  // // Obtenemos la url de la imagen
  // if (response.statusCode == 200) {
  //   urlImage = jsonDecode(response.body)['url'];
  // } else {
  //   print('Error');
  // }

  // return urlImage;

  String urlImage = '';

  File compressedFile = await compressImage(image, uid);

  await ImageKit.io(
    compressedFile,
    folder: "users/$uid/", // (Optional)
    privateKey: Environment.apiKeyPrivateImageKit, // (Keep Confidential)
    onUploadProgress: (progressValue) {
      // print(progressValue);
    },

  ).then((String url) {
    // Get your uploaded Image file link from ImageKit.io
    //then save it anywhere you want. For Example- Firebase, MongoDB etc.
    urlImage = url;
  });

  return urlImage;
}

/// Elimina todas las imágenes del usuario desde su carpeta en ImageKit
Future<void> deleteAllUserImagesFromImagekit(String uid) async {
  final listUrl = Uri.parse('https://api.imagekit.io/v1/files?path=/users/$uid/&limit=1000');
  final deleteUrl = Uri.parse('https://api.imagekit.io/v1/files/');

  final authHeader = 'Basic ${base64Encode(utf8.encode('${Environment.apiKeyPrivateImageKit}:'))}';

  // Obtener lista de imágenes
  final listResponse = await http.get(
    listUrl,
    headers: {
      'Authorization': authHeader,
      'Accept': 'application/json',
    },
  );

  if (listResponse.statusCode == 200) {
    final List<dynamic> files = jsonDecode(listResponse.body);

    for (final file in files) {
      final String fileId = file['fileId'];

      await http.delete(
        Uri.parse('$deleteUrl$fileId'),
        headers: {
          'Authorization': authHeader,
          'Accept': 'application/json',
        },
      );
    }
  } else {
    print('Error al listar archivos de ImageKit: ${listResponse.body}');
  }
}

/// Esta función recibe el nombre del artista y el título de la canción y devuelve sus letras <br>
/// @param artistName Nombre del artistas <br>
/// @param trackTitle Título de la canción <br>
/// @returns Letras de la canción
Future<String> getLyrics({required String artistName, required String trackTitle}) async {
  String lyrics = '';

  Uri url = Uri.parse('https://api.lyrics.ovh/v1/$artistName/$trackTitle');

  // Llamada a la API para obtener las letras de la canción
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    lyrics = json.decode(response.body)['lyrics'];
  }

  return lyrics;
}