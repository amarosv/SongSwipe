import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

/// Widget que personaliza el ElevatedButton
class CustomButton extends StatelessWidget {
  /// Color del fondo
  final Color backgroundColor;
  /// Función al ser pulsado
  final Function onPressed;
  /// Texto del botón
  final String text;
  /// Borde del botón
  final BorderSide? border;
  /// Color del texto
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    this.border,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: border ?? BorderSide.none
              ),
              elevation: 0,
            ),
            onPressed: () {
              onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                upperCaseAfterSpace(text: text),
                style: TextStyle(color: textColor ?? Colors.white, fontSize: 18),
              ),
            )),
      ),
    );
  }
}
