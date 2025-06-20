import 'package:flutter/material.dart';

/// Widget personalizado del TextField <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomTextfield extends StatefulWidget {
  /// Padding
  final EdgeInsets? padding;
  /// Icono
  final Icon? icon;
  /// Texto de ejemplo
  final String? placeholder;
  /// Título
  final String? title;
  /// Boolean que indica si es una contraseña
  final bool? isPassword;
  /// Controller del texto
  final TextEditingController textEditingController;

  const CustomTextfield({
    super.key,
    this.padding,
    this.icon,
    this.placeholder,
    this.title,
    this.isPassword, required this.textEditingController,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(0),
      child: widget.title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8), // Espaciado entre título y campo
                _buildTextField(context),
              ],
            )
          : _buildTextField(context),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.textEditingController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: InputBorder.none,
          suffixIcon: widget.isPassword == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : widget.icon,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.0
          ),
        ),
      ),
    );
  }
}