import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget que personaliza un navigator para ir a otra pantalla <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomNavigator extends StatelessWidget {
  /// Icono
  final IconData? icon;

  /// Color del icono
  final Color? colorIcon;

  /// Tamaño del icono
  final double? iconSize;

  /// Título
  final Text title;

  /// Color de fondo
  final Color? color;

  /// Color de foreground
  final Color? foregroundColor;

  /// Función
  final Function()? function;

  const CustomNavigator(
      {super.key,
      this.icon,
      required this.title,
      this.color = const Color.fromARGB(65, 136, 142, 147),
      this.foregroundColor,
      this.colorIcon,
      this.function,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: CustomContainer(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: colorIcon,
                  size: iconSize,
                ),
                SizedBox(width: 20),
              ],
              Expanded(child: title),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: foregroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
