import 'package:flutter/material.dart';

/// Widget que personaliza la barra de búsqueda <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomSearch extends StatelessWidget {
  /// Texto de ejemplo
  final String placeholder;
  /// Icono
  final Icon suffixIcon;
  /// Controller del texto
  final TextEditingController textEditingController;
  
  const CustomSearch(
      {super.key, required this.placeholder, required this.suffixIcon, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: textEditingController,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: placeholder,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
