/// Función que recibe un texto y pone la primera letra y sus iniciales tras los espacios en mayúscula <br>
/// @param text Texto a convertir <br>
/// @returns Texto con las iniciales tras los espacios en mayúscula
String upperCaseAfterSpace({required String text}) {
  // Variable donde se almacenará el texto convertido
  String textUpper = '';

  // Separamos el texto por los espacios
  List<String> words = text.split(' ');

  // Recorremos la lista de palabras
  for (int i = 0; i < words.length; i++) {
    // Obtenemos la palabra
    String word = words[i];
    
    // Añadimos al nuevo texto la palabra con la inicial en mayúscula
    // y si no es la última palabra, añadimos el espacio
    textUpper += word[0].toUpperCase() + word.substring(1) + (i == words.length - 1 ? '' : ' ');
  }

  // Devolvemos el texto convertido
  return textUpper;
}

/// Función que recibe un texto y pone la primera letra y sus iniciales tras los puntos en mayúscula <br>
/// @param text Texto a convertir <br>
/// @returns Texto con las iniciales tras los puntos en mayúscula
String upperCaseAfterDot({required String text}) {
  // Variable donde se almacenará el texto convertido
  String textUpper = '';

  // Separamos el texto por los puntos
  List<String> parts = text.split('.');

  // Recorremos cada fragmento
  for (int i = 0; i < parts.length; i++) {
    String part = parts[i];

    // Si está vacío, simplemente lo añadimos con el punto
    if (part.trim().isEmpty) {
      textUpper += '.';
      continue;
    }

    int j = 0;
    // Saltamos los caracteres iniciales que no deben capitalizarse
    while (j < part.length && (part[j] == ' ' || part[j] == '¿' || part[j] == '¡')) {
      j++;
    }

    if (j < part.length) {
      String initial = part.substring(0, j); // caracteres iniciales como espacios o signos
      String capitalized = part[j].toUpperCase() + part.substring(j + 1);
      textUpper += initial + capitalized;
    } else {
      textUpper += part; // en caso de que todo sea espacios o símbolos
    }

    if (i < parts.length - 1) {
      textUpper += '.';
    }
  }

  return textUpper;
}

/// Función que recibe un texto y pone en mayúscula la primera letra <br>
/// @param text Texto a capitalizar <br>
/// @returns Texto con la primera letra en mayúscula
String capitalizeFirstLetter({required String text}) {
  // Variable que almacena el texto final
  String finalText;

  if (text[0] == '¿' || text[0] == '¡') {
    finalText = text[0] + text[1].toUpperCase() + text.substring(2);
  } else {
    finalText = text[0].toUpperCase() + text.substring(1);
  }

  return finalText;
}