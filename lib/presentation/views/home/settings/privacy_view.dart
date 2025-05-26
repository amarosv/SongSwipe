import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de ajustes de privacidad<br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PrivacyView extends StatefulWidget {
  const PrivacyView({super.key});

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> with WidgetsBindingObserver {
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
    }
  }

  // Función que comprueba que todo esté en privado y si es así pone la cuenta en privada
  void _checkIfAllArePrivated() {
    if (_userSettings.privacyVisSavedSongs == 2 && _userSettings.privacyVisFol == 2 && _userSettings.privacyVisStats == 2) {
      setState(() {
        _userSettings.privateAccount = true;
      });
    }
  }

  @override
  void dispose() {
    if (_userSettingsComparator != _userSettings) {
      updateUserSettings(_userSettings);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _userSettingsComparator != _userSettings) {
      updateUserSettings(_userSettings);
      _userSettingsComparator = _userSettings.copy();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    // Función que muestra un alert dialog si la cuenta es privada y se intenta cambiar un ajuste
    Future<bool> accountIsCurrentlyPrivate() async {
      final shouldChangeAccount = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(capitalizeFirstLetter(text: localization.attention)),
          content: Text(
              upperCaseAfterDot(text: localization.currently_private_account)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                capitalizeFirstLetter(text: localization.no),
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _userSettings.privateAccount = false;
                });
                Navigator.of(context).pop(true);
              },
              child: Text(capitalizeFirstLetter(text: localization.yes)),
            ),
          ],
        ),
      );

      return shouldChangeAccount ?? false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.profile_privacy.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            // Canciones guardadas
            CustomPrivacyWidget(
              label: capitalizeFirstLetter(text: localization.saved_songs),
              title: capitalizeFirstLetter(text: localization.who_can_see),
              selected: _userSettings.privacyVisSavedSongs,
              onChanged: (int newSelected) async {
                if (newSelected != _userSettings.privacyVisSavedSongs) {
                  bool doAction = true;

                  if (_userSettings.privateAccount && newSelected == 0) {
                    doAction = await accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisSavedSongs = newSelected;
                    });
                  }

                  _checkIfAllArePrivated();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),

            // Estadisticas
            CustomPrivacyWidget(
              label: capitalizeFirstLetter(text: localization.stats),
              title: capitalizeFirstLetter(text: localization.who_can_see),
              selected: _userSettings.privacyVisStats,
              onChanged: (int newSelected) async {
                if (newSelected != _userSettings.privacyVisStats) {
                  bool doAction = true;

                  if (_userSettings.privateAccount && newSelected == 0) {
                    doAction = await accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisStats = newSelected;
                    });
                  }

                  _checkIfAllArePrivated();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),

            // Seguidores y siguiendo
            CustomPrivacyWidget(
              label:
                  capitalizeFirstLetter(text: localization.followers_following),
              title: capitalizeFirstLetter(text: localization.who_can_see),
              selected: _userSettings.privacyVisFol,
              onChanged: (int newSelected) async {
                if (newSelected != _userSettings.privacyVisFol) {
                  bool doAction = true;

                  if (_userSettings.privateAccount && newSelected == 0) {
                    doAction = await accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisFol = newSelected;
                    });
                  }

                  _checkIfAllArePrivated();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),

            // Visibilidad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      capitalizeFirstLetter(text: localization.visibility),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  CustomSwitchContainer(
                      title: capitalizeFirstLetter(
                          text: localization.make_account_private),
                      switchValue: _userSettings.privateAccount,
                      function: (bool newValue) {
                        setState(() {
                          _userSettings.privateAccount = newValue;
                          _userSettings.privacyVisSavedSongs = 2;
                          _userSettings.privacyVisStats = 2;
                          _userSettings.privacyVisFol = 2;
                        });
                      }),
                ],
              ),
            ),

            // Texto informativo para la cuenta privada
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                capitalizeFirstLetter(text: localization.account_private_label),
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Dispositivos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.devices),
                  style: TextStyle(fontSize: 20),
                ),
                icon: Icons.devices,
                colorIcon: Theme.of(context).colorScheme.primary,
                function: () {
                  // TODO
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                backgroundColor: const Color.fromARGB(255, 177, 12, 1),
                onPressed: () async {
                  // TODO
                },
                text: upperCaseAfterSpace(text: localization.delete_account),
                textSize: 24,
                icon: Icons.delete_forever,
                iconColor: Colors.white,
                iconSize: 32,
                applyPadding: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
