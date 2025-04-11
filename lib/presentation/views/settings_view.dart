import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/config/icons/song_swipe_icons.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Vista para la pantalla de ajustes <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          localization.settings.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              CustomNavigator(
                title: Text(
                  'Appearance',
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.design_services,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
