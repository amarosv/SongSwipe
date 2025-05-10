import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget que personaliza el select de los modos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomThemeSelect extends StatelessWidget {
  /// Color de fondo
  final Color color;

  /// Nombre del color
  final String titleColor;

  /// Color del título
  final Color colorTitle;

  /// Es seleccionado o no
  final bool selected;

  /// Función
  final Function function;

  const CustomThemeSelect({
    super.key,
    required this.color,
    required this.titleColor,
    required this.colorTitle,
    required this.selected,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: CustomContainer(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleColor,
                  style:
                      TextStyle(color: colorTitle, fontWeight: FontWeight.bold),
                ),
                selected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.lightGreenAccent,
                      )
                    : Container()
              ],
            ),
          )),
    );
  }
}
