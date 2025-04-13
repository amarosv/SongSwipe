import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:songswipe/config/icons/song_swipe_icons.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';


/// Vista para la pantalla de ajustes <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Variable que almacena la versión de la app
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.appName} v${info.version}';
    });
  }

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
              const SizedBox(height: 20),

              // Apariencia
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.appearance),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.designServices,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 40,),

              // Perfil y privacidad
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.profile_privacy),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.person,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 40,),

              // Idioma
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.language),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.language,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 40,),

              // Audio
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.audio),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.headphones,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 40,),

              // Notificaciones
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.notifications),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.circleNotifications,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 40,),

              // Acerca de SongSwipe
              CustomNavigator(
                title: Text(
                  '${capitalizeFirstLetter(text: localization.about_songswipe)} SongSwipe',
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.info,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 40,),

              CustomButton(
                backgroundColor: Colors.red,
                onPressed: () {},
                text: localization.logout,
                textSize: 24,
                icon: Icons.logout,
                iconColor: Colors.white,
                iconSize: 32,
                applyPadding: false,
              ),

              const SizedBox(height: 40),

              Text(_version)
            ],
          ),
        ),
      ),
    );
  }
}
