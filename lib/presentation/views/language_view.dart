import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
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

class _LanguageViewState extends State<LanguageView>
    with WidgetsBindingObserver {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el user settings para comporar si ha habido cambios
  UserSettings _userSettingsComparator = UserSettings.empty();

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
    WidgetsBinding.instance.addObserver(this);
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserSettings();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    if (mounted) {
      setState(() {
        _userSettingsComparator = settings.copy();
        _userSettings = settings;
      });

      // Obtenemos el código del idioma
      _getLanguageCode();
    }
  }

  // Función que obtiene el código del idioma
  void _getLanguageCode() async {
    String code = _userSettings.language;

    widget.onChangeLanguage(code);

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
  void dispose() {
    if (_userSettingsComparator != _userSettings) {
      updateUserSettings(_userSettings, _uid);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        _userSettingsComparator != _userSettings) {
      updateUserSettings(_userSettings, _uid);
      _userSettingsComparator = _userSettings.copy();
    }
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
              if (!englishSelected) {
                // Resetear selección
                englishSelected = false;
                spanishSelected = false;
                italianSelected = false;

                setState(() {
                  englishSelected = true;
                });

                _userSettings.language = 'en';
                widget.onChangeLanguage('en');
              }
            },
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'spain.png',
            language: capitalizeFirstLetter(text: localization.spanish),
            selected: spanishSelected,
            function: () {
              if (!spanishSelected) {
                // Resetear selección
                englishSelected = false;
                spanishSelected = false;
                italianSelected = false;

                setState(() {
                  spanishSelected = true;
                });

                _userSettings.language = "es";
                widget.onChangeLanguage('es');
              }
            },
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'italy.png',
            language: capitalizeFirstLetter(text: localization.italian),
            selected: italianSelected,
            function: () {
              if (!italianSelected) {
                // Resetear selección
                englishSelected = false;
                spanishSelected = false;
                italianSelected = false;

                setState(() {
                  italianSelected = true;
                });

                _userSettings.language = 'it';
                widget.onChangeLanguage('it');
              }
            },
          ),
        ],
      ),
    );
  }
}
