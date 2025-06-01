import 'package:flutter/material.dart';

/// Widget que personaliza un row para mostrar información <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomRow extends StatelessWidget {
  /// Titulo de la fila
  final String title;
  /// Valor de la fila
  final String value;
  const CustomRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white),
      ],
    );
  }
}