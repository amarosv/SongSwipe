import 'package:flutter/material.dart';

/// Widget que personaliza un column para mostrar información <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomColumn extends StatelessWidget {
  /// Titulo de la columna
  final String title;

  /// Valor de la columna
  final String value;

  /// Valor que determina si tiene un divisor
  final bool hasDivider;

  /// Estilo del título
  final TextStyle? titleStyle;

  /// Estilo del valor
  final TextStyle? textStyle;

  const CustomColumn(
      {super.key,
      required this.title,
      required this.value,
      this.hasDivider = true,
      this.titleStyle,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: titleStyle,
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: textStyle,
              ),
            ],
          ),
        ),
        hasDivider
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                constraints: const BoxConstraints.tightFor(height: 60),
                child: const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),
              )
            : Container()
      ],
    );
  }
}
