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

/// Función que recibe un texto y pone en mayúscula la primera letra <br>
/// @param text Texto a capitalizar <br>
/// @returns Texto con la primera letra en mayúscula
String capitalizeFirstLetter({required String text}) {
  // Variable que almacena el texto final
  String finalText;

  if (text[0] == '¿') {
    finalText = text[0] + text[1].toUpperCase() + text.substring(2);
  } else {
    finalText = text[0].toUpperCase() + text.substring(1);
  }

  return finalText;
}