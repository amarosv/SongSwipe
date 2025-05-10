import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/user_settings.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para los ajustes de notificaciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.notifications.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              // Permitir notificaciones
              CustomSwitchContainer(
                  title: capitalizeFirstLetter(
                      text: localization.allow_notifications),
                  switchValue: _userSettings.notifications,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.notifications = newValue;
                      _userSettings.notiFriendsRequest = newValue;
                      _userSettings.notiFriendsApproved = newValue;
                      _userSettings.notiAppUpdate = newValue;
                      _userSettings.notiAppRecap = newValue;
                      _userSettings.notiAccountBlocked = newValue;
                    });

                    updateUserSettings(_userSettings, _uid);
                  }),

              const SizedBox(
                height: 30,
              ),

              // Amigos
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      capitalizeFirstLetter(text: localization.friends),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  CustomSwitchContainer(
                      title: capitalizeFirstLetter(
                          text: localization.new_friend_request),
                      switchValue: _userSettings.notiFriendsRequest,
                      function: (bool newValue) {
                        setState(() {
                          _userSettings.notiFriendsRequest = newValue;

                          if (newValue) {
                            _userSettings.notifications = newValue;
                          }
                        });

                        updateUserSettings(_userSettings, _uid);
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomSwitchContainer(
                      title: capitalizeFirstLetter(
                          text: localization.friend_request_approved),
                      switchValue: _userSettings.notiFriendsApproved,
                      function: (bool newValue) {
                        setState(() {
                          _userSettings.notiFriendsApproved = newValue;

                          if (newValue) {
                            _userSettings.notifications = newValue;
                          }
                        });

                        updateUserSettings(_userSettings, _uid);
                      }),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              // App
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      capitalizeFirstLetter(text: localization.app),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  CustomSwitchContainer(
                      title: capitalizeFirstLetter(
                          text: localization.new_app_update),
                      switchValue: _userSettings.notiAppUpdate,
                      function: (bool newValue) {
                        setState(() {
                          _userSettings.notiAppUpdate = newValue;

                          if (newValue) {
                            _userSettings.notifications = newValue;
                          }
                        });

                        updateUserSettings(_userSettings, _uid);
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomSwitchContainer(
                      title: capitalizeFirstLetter(
                          text: localization.weekly_recap),
                      switchValue: _userSettings.notiAppRecap,
                      function: (bool newValue) {
                        setState(() {
                          _userSettings.notiAppRecap = newValue;

                          if (newValue) {
                            _userSettings.notifications = newValue;
                          }
                        });

                        updateUserSettings(_userSettings, _uid);
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      capitalizeFirstLetter(
                          text: localization.label_weekly_recap),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              CustomSwitchContainer(
                  title:
                      capitalizeFirstLetter(text: localization.account_blocked),
                  switchValue: _userSettings.notiAccountBlocked,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.notiAccountBlocked = newValue;

                      if (newValue) {
                        _userSettings.notifications = newValue;
                      }
                    });

                    updateUserSettings(_userSettings, _uid);
                  }),

              const SizedBox(height: 10),

              // Texto informativo para la opción account blocked
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(
                      text: localization.label_account_blocked),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
