import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:toastification/toastification.dart';

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

/// Función que recibe un titulo y una descripción y muestra
/// una notificación de error <br>
/// @param title Título de la notificación <br>
/// @param body Descripción de la notificación <br>
/// @param context Contexto
void showNotification(String title, String body, BuildContext context) {
  // Mostramos la notificación
  toastification.show(
    type: ToastificationType.error,
    context: context,
    style: ToastificationStyle.flatColored,
    title: Text(title),
    description: RichText(
        text: TextSpan(text: body, style: TextStyle(color: Colors.black))),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

/// Función que recibe un file y lo convierte a base 64 <br>
/// @param file Archivo a convertir <br>
/// @returns String con el archivo en base 64
Future<String> convertFileToBase64(File file) async {
  // 1. Leer los bytes de la imagen
  final bytes = await file.readAsBytes();

  // 2. Codificar la imagen a base64
  final base64Image = base64Encode(bytes);

  return base64Image;
}

/// Función que recibe una fecha en formato inglés y lo convierte a formato español <br>
/// @param date Fecha en formato inglés
/// @returns Fecha en formato español
String convertDate(String date) {
  // Definimos el formato de entrada y salida
  final formatoEntrada = DateFormat('MM/dd/yyyy hh:mm:ss a');
  final formatoSalida = DateFormat('dd/MM/yyyy HH:mm:ss');

  try {
    final fecha = formatoEntrada.parse(date);
    return formatoSalida.format(fecha);
  } catch (e) {
    return 'Formato inválido';
  }
}

/// Función que formatea los números para que 1000 pase 1k <br>
/// @param number Número a convertir
/// @returns Número convertido
String humanReadbleNumber(int number) {
  final formattedNumber =
      NumberFormat.compactCurrency(decimalDigits: 0, symbol: '').format(number);

  return formattedNumber;
}

/// Función que comprime una imagen <br>
/// @param file Imagen
/// @param uid UID del
/// @returns Imagen comprimida
Future<File> compressImage(File file, String uid) async {
  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${file.parent.path}/$uid-${DateTime.now().toIso8601String().replaceAll(':', '-')}.jpg',
    quality: 70, // 0 - 100
    minWidth: 800, // opcional
    minHeight: 800, // opcional
  );

  return File(compressedFile!.path);
}

/// Función que formatea un número con puntos como separadores de miles (ej: 1023456 -> 1.023.456) <br>
/// @param number Número a formatear
/// @returns String con el número formateado
String formatWithThousandsSeparator(int number) {
  final formatter = NumberFormat.decimalPattern('es_ES');
  return formatter.format(number);
}

/// Esta función recibe la duración de una canción en segundos y lo convierte a
/// minutos y segundos <br>
/// @param totalSeconds Segundos totales de la canción <br>
/// @returns Cadena con los minutos y segundos
String formatDuration(int totalSeconds) {
  int minutes = totalSeconds ~/ 60; // Calcula los minutos
  int seconds = totalSeconds % 60; // Calcula los segundos restantes
  String secondsStr = seconds.toString().padLeft(2, '0');
  return '$minutes min $secondsStr sg';
}

/// Esta función recibe una fecha completa y devuelve solo el año <br>
/// @param date Fecha completa <br>
/// @returns Año
String dateToYear({required String date}) {
  String year = '';

  List<String> parts = date.split('-');

  year = parts.first;

  return year;
}

/// Esta función genera un código verificador <br>
/// @returns Código
String generarCodeVerifier() {
  final random = Random.secure();
  final values = List<int>.generate(64, (_) => random.nextInt(256));
  return base64UrlEncode(Uint8List.fromList(values)).replaceAll('=', '');
}

/// Esta función genera el Code Challenge <br>
/// @returns Código
String generarCodeChallenge(String codeVerifier) {
  final bytes = utf8.encode(codeVerifier);
  final digest = sha256.convert(bytes);
  return base64UrlEncode(digest.bytes).replaceAll('=', '');
}
