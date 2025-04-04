import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

/// Widget que personaliza los botones de social buttons
class CustomSocialButton extends StatelessWidget {
  /// Color del fondo
  final Color backgroundColor;
  /// Color del borde
  final Color borderColor;
  /// Estilo del texto
  final TextStyle? textStyle;
  /// Ruta a la imagen del logo
  final String imagePath;
  /// Función al ser pulsado
  final Function onPressed;
  /// Nombre del proovedor
  final String text;
  /// Ancho del botón
  final double? width;

  const CustomSocialButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    required this.borderColor,
    required this.imagePath,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16),
              child: Image(
                image: AssetImage(imagePath),
                width: 24,
              ),
            ),
            Text(
              upperCaseAfterSpace(text: text),
              style: textStyle ??
                  TextStyle(color: borderColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}