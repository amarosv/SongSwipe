import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

// Widget personalizado del dropdown
class CustomDropdownLanguage extends StatefulWidget {
  const CustomDropdownLanguage({super.key});

  @override
  State<CustomDropdownLanguage> createState() => _CustomDropdownLanguageState();
}

class _CustomDropdownLanguageState extends State<CustomDropdownLanguage> {
  // Constante que almacena la ruta a las banderas
  final String assetsPath = 'assets/images/flags';

  // Variable que almacena el idioma seleccionado
  Language language = Language.english;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 1.5),
              borderRadius: BorderRadius.circular(8)),
          child: DropdownButton(
            value: language,
            padding: EdgeInsets.all(4),
            icon: const SizedBox.shrink(),
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: Language.spanish,
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/spain.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    const Text('Spanish', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: Language.english,
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/uk.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    const Text('English', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: Language.italian,
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/italy.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    const Text('Italian', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              // Actualizamos el estado al seleccionar un idioma
              setState(() {
                language = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
