import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:songswipe/models/export_models.dart';

/// Función que obtiene el color dominante de una imagen <br>
/// @param imagePath Ruta a la imagen <br>
/// @returns Color dominante
Future<Color> extractDominantColor(
    {required String imagePath}) async {
  List<Color> colors = [];
  Color dominantColor = Color.fromARGB(172, 74, 78, 148);

  Uint8List? imageBytes = await fetchImage(imagePath);

  try {
//DominantColors dominantColors = DominantColorsBuilder()
    // .setBytes(imageBytes!)
    // .setDominantColorsCount(3)
    // .build();

    DominantColors extractor =
        DominantColors(bytes: imageBytes, dominantColorsCount: 1);

    List<Color> dominantColors = extractor.extractDominantColors();

    colors = dominantColors;

    dominantColor = dominantColors.first.withValues(alpha: 0.8);
  } catch (e) {
    colors.clear();
  }

  return dominantColor;
}

/// Función que obtiene los bits de una imagen <br>
/// @param photoUrl Url de la imagen
/// @returns Bits de la imagen
Future<Uint8List> fetchImage(String photoUrl) async {
  var httpClient = HttpClient();
  var request = await httpClient.getUrl(Uri.parse(photoUrl));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  return bytes;
}
