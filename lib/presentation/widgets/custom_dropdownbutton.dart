import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/helpers/strings_methods.dart';

// Widget personalizado del dropdown
class CustomDropdownLanguage extends StatefulWidget {
  // Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const CustomDropdownLanguage({super.key, required this.onChangeLanguage});

  @override
  State<CustomDropdownLanguage> createState() => _CustomDropdownLanguageState();
}

class _CustomDropdownLanguageState extends State<CustomDropdownLanguage> {
  // Constante que almacena la ruta a las banderas
  final String assetsPath = 'assets/images/flags';

  // Variable que almacena el idioma seleccionado
  Language language = Language.english;

  // Función que obtiene el lenguaje por defecto
  void _getDefaultLanguage() async {
    // Cargamos el lenguaje guardado en SharedPreferences
    String languageCode = await loadDataString(tag: 'language');

    // Comprobamos si está vacío
    if (languageCode.isEmpty) {
      // En el caso en el cual no hay guardado ningún lenguaje
      // Obtenemos el lenguaje del dispositivo
      Locale locale = PlatformDispatcher.instance.locale;

      languageCode = locale.languageCode;
    }

    // Cambiamos el lenguaje seleccionado
      switch (languageCode) {
        case 'es':
          language = Language.spanish;
          break;
        case 'en':
          language = Language.english;
          break;
        case 'it':
          language = Language.italian;
          break;
      }
  }

  @override
  void initState() {
    super.initState();
    _getDefaultLanguage();
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
                onTap: () {
                  // Cambiamos el lenguaje a español
                  widget.onChangeLanguage('es');
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/spain.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(capitalizeFirstLetter(text: localization.spanish),
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: Language.english,
                onTap: () {
                  // Cambiamos el lenguaje a inglés
                  widget.onChangeLanguage('en');
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/uk.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(capitalizeFirstLetter(text: localization.english),
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: Language.italian,
                onTap: () {
                  // Cambiamos el lenguaje a italiano
                  widget.onChangeLanguage('it');
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Image(
                      image: AssetImage('$assetsPath/italy.png'),
                      width: 38,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(capitalizeFirstLetter(text: localization.italian),
                        style: TextStyle(fontSize: 12)),
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
