import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';

/// Vista para la información de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.about_songswipe.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'SongSwipe ${localization.about_songswipe_text}',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}