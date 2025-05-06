import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/custom_language_select.dart';

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
  bool englishSelected = false;
  bool spanishSelected = true;
  bool italianSelected = false;

  @override
  void initState() {
    super.initState();
    
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
            selected: englishSelected
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'spain.png',
            language: capitalizeFirstLetter(text: localization.spanish),
            selected: spanishSelected
          ),
          const SizedBox(height: 20),
          CustomLanguageSelect(
            flag: 'italy.png',
            language: capitalizeFirstLetter(text: localization.italian),
            selected: italianSelected
          ),
        ],
      ),
    );
  }
}