import 'package:flutter/material.dart';

/// Widget que personaliza la barra de búsqueda
class CustomSearch extends StatelessWidget {
  /// Texto de ejemplo
  final String placeholder;
  /// Icono
  final Icon suffixIcon;
  
  const CustomSearch(
      {super.key, required this.placeholder, required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          hintText: placeholder,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
