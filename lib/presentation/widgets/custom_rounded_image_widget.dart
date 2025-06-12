import 'package:flutter/material.dart';

/// Widget personalizado para mostrar imagenes circulares <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomRoundedImageWidget extends StatelessWidget {
  /// URL de la imagen
  final String path;

  /// Altura
  final double height;

  const CustomRoundedImageWidget({
    super.key,
    required this.path, required this.height,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2),
      ),
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.network(
          path,
        ),
      ),
    );
  }
}