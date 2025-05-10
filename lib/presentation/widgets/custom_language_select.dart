import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget que personaliza el select del lenguaje <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomLanguageSelect extends StatelessWidget {
  /// Función
  final Function()? function;

  /// Bandera
  final String flag;

  /// Idioma
  final String language;

  /// Boolean que indica si es el seleccionado
  final bool selected;

  const CustomLanguageSelect({super.key, this.function, required this.flag, required this.language, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: function,
        child: CustomContainer(
          child: Row(
            children: [
              const SizedBox(width: 20),
              Image.asset(
                'assets/images/flags/$flag',
                width: 64,
                height: 64,
              ),
              const SizedBox(width: 20),
              Text(
                language,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              selected
                ? Icon(
                    Icons.check_circle,
                    color: Colors.lightGreen,
                    size: 32
                  )
                : Container(),
              const SizedBox(width: 20,)
            ],
          ),
        ),
      ),
    );
  }
}