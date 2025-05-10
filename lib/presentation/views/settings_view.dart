import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                function: () => context.push('/appearance-settings'),
              ),
              
              const SizedBox(height: 30,),

              // Perfil y privacidad
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.profile_privacy),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.person,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () => context.push('/privacy-settings'),
              ),
              
              const SizedBox(height: 30,),

              // Idioma
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.language),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.language,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () => context.push('/language-settings'),
              ),
              
              const SizedBox(height: 30,),

              // Audio
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.audio),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.headphones,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () => context.push('/audio-settings'),
              ),
              
              const SizedBox(height: 30,),

              // Notificaciones
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.notifications),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.circleNotifications,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () => context.push('/notifications-settings'),
              ),
              
              const SizedBox(height: 30,),

              // Acerca de SongSwipe
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.about_songswipe),
                  style: TextStyle(fontSize: 20),
                ),
                icon: SongSwipe.info,
                iconSize: 32,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () => context.push('/about-settings'),
              ),

              const SizedBox(height: 30,),

              // Cerrar sesión
              CustomButton(
                backgroundColor: const Color.fromARGB(255, 177, 12, 1),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: Text(capitalizeFirstLetter(text: localization.logout)),
                      content: Text(capitalizeFirstLetter(text: localization.logout_dialog_content)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            capitalizeFirstLetter(text: localization.no),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(capitalizeFirstLetter(text: localization.yes)),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await FirebaseAuth.instance.signOut();
                    context.go('/login');
                  }
                },
                text: localization.logout,
                textSize: 24,
                icon: Icons.logout,
                iconColor: Colors.white,
                iconSize: 32,
                applyPadding: false,
              ),

              const SizedBox(height: 40),

              // Versión de la app
              Text(_version)
            ],
          ),
        ),
      ),
    );
  }
}
