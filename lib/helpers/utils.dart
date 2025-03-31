import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Función que recibe un titulo y una descripción y muestra
/// una notificación de error
/// @param title Título de la notificación
/// @param body Descripción de la notificación
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
