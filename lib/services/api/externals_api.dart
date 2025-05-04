import 'dart:io';

import 'package:flutter_imagekit/flutter_imagekit.dart';
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
