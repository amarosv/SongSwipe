import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para los ajustes de audio <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AudioView extends StatefulWidget {
  const AudioView({super.key});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> with WidgetsBindingObserver {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el user settings para comporar si ha habido cambios
  UserSettings _userSettingsComparator = UserSettings.empty();

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserSettings();
    WidgetsBinding.instance.addObserver(this);
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    if (mounted) {
      setState(() {
        _userSettingsComparator = settings.copy();
        _userSettings = settings;
      });
    }
  }

  @override
  void dispose() {
    if (_userSettingsComparator != _userSettings) {
      updateUserSettings(uid: _uid, settings: _userSettings);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Para evitar llamadas a la API cada vez que se cambia un ajuste,
    // comprobamos el último valor al salir de la pantalla y ese es el que se
    // envía, llamándo así a la API una sola vez
    if ((state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) &&
        _userSettingsComparator != _userSettings) {
      updateUserSettings(uid: _uid, settings: _userSettings);
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
          localization.audio.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Play loop
            CustomSwitchContainer(
                title: localization.play_loop,
                switchValue: _userSettings.audioLoop,
                function: (bool newValue) {
                  setState(() {
                    _userSettings.audioLoop = newValue;
                  });
                }),
            const SizedBox(height: 20),

            // Auto play
            CustomSwitchContainer(
                title: localization.autoplay,
                switchValue: _userSettings.audioAutoPlay,
                function: (bool newValue) {
                  setState(() {
                    _userSettings.audioAutoPlay = newValue;
                  });
                }),
            const SizedBox(height: 20),

            // Only audio
            CustomSwitchContainer(
                title: localization.only_audio,
                switchValue: _userSettings.audioOnlyAudio,
                function: (bool newValue) {
                  setState(() {
                    _userSettings.audioOnlyAudio = newValue;
                  });
                }),

            const SizedBox(
              height: 10,
            ),

            // Texto informativo para la opción only audio
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                capitalizeFirstLetter(text: localization.label_only_audio),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
