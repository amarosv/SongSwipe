import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class _PrivacyViewState extends State<PrivacyView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el usersettings
  UserSettings _userSettings = UserSettings.empty();

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserSettings();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    setState(() {
      _userSettings = settings;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    Future<bool> _accountIsCurrentlyPrivate() async {
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

                  if (_userSettings.privateAccount) {
                    doAction = await _accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisSavedSongs = newSelected;
                    });

                    updateUserSettings(_userSettings, _uid);
                  }
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

                  if (_userSettings.privateAccount) {
                    doAction = await _accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisStats = newSelected;
                    });

                    updateUserSettings(_userSettings, _uid);
                  }
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

                  if (_userSettings.privateAccount) {
                    doAction = await _accountIsCurrentlyPrivate();
                  }

                  if (doAction) {
                    setState(() {
                      _userSettings.privacyVisFol = newSelected;
                    });

                    updateUserSettings(_userSettings, _uid);
                  }
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
                  CustomContainer(
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          capitalizeFirstLetter(
                              text: localization.make_account_private),
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Switch.adaptive(
                            value: _userSettings.privateAccount,
                            onChanged: (bool newValue) {
                              setState(() {
                                _userSettings.privateAccount = newValue;
                                _userSettings.privacyVisSavedSongs = 2;
                                _userSettings.privacyVisStats = 2;
                                _userSettings.privacyVisFol = 2;
                              });

                              updateUserSettings(_userSettings, _uid);
                            })
                      ],
                    ),
                  )
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
                text: localization.delete_account,
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
