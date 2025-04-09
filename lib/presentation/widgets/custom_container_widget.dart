import 'package:flutter/material.dart';

/// Widget que personaliza el Container <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomContainer extends StatelessWidget {
  /// Widget hijo
  final Widget child;
  /// Color opcional del fondo del container
  final Color? color;

  const CustomContainer({
    super.key,
    required this.child,
    this.color = const Color.fromARGB(65, 136, 142, 147),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: child,
    );
  }
}