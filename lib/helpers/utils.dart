import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
