import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';

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
    textUpper += word[0].toUpperCase() +
        word.substring(1) +
        (i == words.length - 1 ? '' : ' ');
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
    while (j < part.length &&
        (part[j] == ' ' || part[j] == '¿' || part[j] == '¡')) {
      j++;
    }

    if (j < part.length) {
      String initial =
          part.substring(0, j); // caracteres iniciales como espacios o signos
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

/// Función que formatea una fecha <br>
/// @param date Fecha a formatear <br>
/// @param context Contexto <br>
/// @returns Fecha formateada
String formatDate({required String date, required BuildContext context}) {
  // Constante que almacena la localización de la app
  final localization = AppLocalizations.of(context)!;

  String day = '';
  String month = '';
  String monthName = '';
  String year = '';
  List<String> dateSplitted = date.split('-');

  day = dateSplitted.last;
  month = dateSplitted[1];
  year = dateSplitted.first;

  switch (month) {
    case '01':
      monthName = localization.january;
      break;
    case '02':
      monthName = localization.february;
      break;
    case '03':
      monthName = localization.march;
      break;
    case '04':
      monthName = localization.april;
      break;
    case '05':
      monthName = localization.may;
      break;
    case '06':
      monthName = localization.june;
      break;
    case '07':
      monthName = localization.july;
      break;
    case '08':
      monthName = localization.august;
      break;
    case '09':
      monthName = localization.september;
      break;
    case '10':
      monthName = localization.october;
      break;
    case '11':
      monthName = localization.november;
      break;
    case '12':
      monthName = localization.december;
      break;
  }

  return '${capitalizeFirstLetter(text: monthName.substring(0, 3))} ${day[0] == '0' ? day.substring(1) : day}, $year';
}
