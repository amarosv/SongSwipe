import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado para la privacidad <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomPrivacyWidget extends StatelessWidget {
  /// Etiqueta de la canción
  final String label;

  /// Título de la opción
  final String title;

  /// Número seleccionado
  final int selected;

  /// Función para saber cual se ha seleccionado
  final Function(int) onChanged;

  const CustomPrivacyWidget({
    super.key,
    required this.label,
    required this.title,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              capitalizeFirstLetter(text: label),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          CustomContainer(
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: CustomContainer(
                    color: Colors.grey,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () => onChanged(0),
                              child: Icon(
                                Icons.public,
                                color: selected == 0
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color.fromARGB(255, 202, 202, 202),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () => onChanged(1),
                              child: Icon(
                                Icons.people,
                                color: selected == 1
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color.fromARGB(255, 202, 202, 202),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () => onChanged(2),
                              child: Icon(
                                Icons.lock,
                                color: selected == 2
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color.fromARGB(255, 202, 202, 202),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
