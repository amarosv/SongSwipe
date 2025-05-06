import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/custom_language_select.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de elegir idioma <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LanguageView extends StatefulWidget {
  // Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const LanguageView({super.key, required this.onChangeLanguage});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();

  // Variable que almacena el código del idioma
  String _languageCode = '';

  bool englishSelected = true;
  bool spanishSelected = false;
  bool italianSelected = false;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserSettings();
    // Obtenemos el código del idioma
    _getLanguageCode();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    setState(() {
      _userSettings = settings;
    });
  }

  // Función que obtiene el código del idioma
  void _getLanguageCode() async {
    String code = await loadDataString(tag: 'language');

    // Comprobamos si está vacío
    if (code.isEmpty) {
      // En el caso en el cual no hay guardado ningún lenguaje
      // Obtenemos el lenguaje del dispositivo
      Locale locale = PlatformDispatcher.instance.locale;

      code = locale.languageCode;
    }

    setState(() {
      _languageCode = code;

      // Resetear selección
      englishSelected = false;
      spanishSelected = false;
      italianSelected = false;

      // Activar idioma actual
      switch (_languageCode) {
        case 'es':
          spanishSelected = true;
          break;
        case 'en':
          englishSelected = true;
          break;
        case 'it':
          italianSelected = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.language.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'uk.png',
            language: capitalizeFirstLetter(text: localization.english),
            selected: englishSelected,
            function: () {
              // Resetear selección
              englishSelected = false;
              spanishSelected = false;
              italianSelected = false;

              setState(() {
                englishSelected = true;
              });
              
              _userSettings.language = 'en';
              updateUserSettings(_userSettings, _uid);
              widget.onChangeLanguage('en');
            },
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'spain.png',
            language: capitalizeFirstLetter(text: localization.spanish),
            selected: spanishSelected,
            function: () {
              // Resetear selección
              englishSelected = false;
              spanishSelected = false;
              italianSelected = false;

              setState(() {
                spanishSelected = true;
              });

              _userSettings.language = "es";
              updateUserSettings(_userSettings, _uid);
              widget.onChangeLanguage('es');
            },
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'italy.png',
            language: capitalizeFirstLetter(text: localization.italian),
            selected: italianSelected,
            function: () {
              // Resetear selección
              englishSelected = false;
              spanishSelected = false;
              italianSelected = false;

              setState(() {
                italianSelected = true;
              });


              _userSettings.language = 'it';
              updateUserSettings(_userSettings, _uid);
              widget.onChangeLanguage('it');
            },
          ),
        ],
      ),
    );
  }
}
