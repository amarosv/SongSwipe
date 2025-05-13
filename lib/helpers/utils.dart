import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

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