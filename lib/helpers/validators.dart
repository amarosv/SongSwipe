import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Función que comprueba si una contraseña cumple los requisitos <br>
/// @param password Cadena a comprobar <br>
/// @param context Contexto para obtener la localización <br>
/// @return Devuelve un mapa con un booleano y un string indicando el error correspondiente
Map<bool, String> passwordValidator({
  required String password,
  required BuildContext context,
}) {
  final localization = AppLocalizations.of(context)!;

  // Variable que almacena si la contraseña es válida
  bool isValid = false;

  // Variable que almacena el mensaje de error
  String error = '';

  // Expresión regular que valida:
  // - Al menos 8 caracteres
  // - Al menos una mayúscula
  // - Al menos una minúscula
  // - Al menos un número
  // - Al menos un carácter especial
  final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');

  // Comprobamos si contiene algún error
  if (regex.hasMatch(password)) {
    isValid = true;
  } else if (password.isEmpty || password.length < 8) {
    // Longitud incorrecta
    error = localization.error_password_length;
  } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
    // No contiene mayúscula
    error = localization.error_password_capital;
  } else if (!RegExp(r'[a-z]').hasMatch(password)) {
    // No contiene minúscula
    error = localization.error_password_lowercase;
  } else if (!RegExp(r'\d').hasMatch(password)) {
    // No contiene número
    error = localization.error_password_number;
  } else if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
    // No contiene carácter especial
    error = localization.error_password_special;
  }

  // Devolvemos el resultado
  return {isValid: error};
}