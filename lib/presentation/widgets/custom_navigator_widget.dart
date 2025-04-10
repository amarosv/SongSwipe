import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget que personaliza un navigator para ir a otra pantalla <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomNavigator extends StatelessWidget {
  final IconData? icon;
  final Color? colorIcon;
  final Text title;
  final Color? color;
  final Color? foregroundColor;
  final Function()? function;

  const CustomNavigator(
      {super.key,
      this.icon,
      required this.title,
      this.color = const Color.fromARGB(65, 136, 142, 147),
      this.foregroundColor,
      this.colorIcon,
      this.function});

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
                ),
                const SizedBox(width: 8),
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
