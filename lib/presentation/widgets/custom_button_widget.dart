import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

/// Widget que personaliza el ElevatedButton <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomButton extends StatelessWidget {
  /// Color del fondo
  final Color backgroundColor;

  /// Función al ser pulsado
  final Function onPressed;

  /// Texto del botón
  final String text;

  /// Tamaño del texto
  final double? textSize;

  /// Borde del botón
  final BorderSide? border;

  /// Color del texto
  final Color? textColor;

  /// Booleano que indica si el botón esta desactivado
  final bool disabled;

  /// Icono del botón
  final IconData? icon;

  /// Color del icono
  final Color? iconColor;

  /// Tamaño del icono
  final double? iconSize;

  /// Booleano que indica si quiere que se aplique el padding
  final bool? applyPadding;

  const CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.onPressed,
      required this.text,
      this.border,
      this.textColor,
      this.disabled = false,
      this.icon,
      this.iconColor,
      this.iconSize,
      this.applyPadding, this.textSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: applyPadding != false
          ? EdgeInsets.symmetric(horizontal: 50)
          : EdgeInsets.all(0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled ? Colors.grey : backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: border ?? BorderSide.none),
              elevation: 0,
            ),
            onPressed: disabled
                ? null
                : () {
                    onPressed();
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor,
                      size: iconSize,
                    ),
                  ],
                  Expanded(
                    child: Text(
                      upperCaseAfterSpace(text: text),
                      style: TextStyle(
                          color: textColor ?? Colors.white, fontSize: textSize ?? 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
