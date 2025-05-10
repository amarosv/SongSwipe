import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/user_settings.dart';
import 'package:songswipe/presentation/providers/export_providers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para los ajustes de apariencia <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AppearanceView extends ConsumerStatefulWidget {
  const AppearanceView({super.key});

  @override
  ConsumerState<AppearanceView> createState() => _AppearanceViewState();
}

class _AppearanceViewState extends ConsumerState<AppearanceView> {
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
    if (mounted) {
      setState(() {
        _userSettings = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    final Map<String, Color> colors = ref.watch(colorListProvider);
    final int selectedColor = ref.watch(themeNotifierProvider).selectedColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.appearance.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Modo
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.mode),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Dark
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userSettings.mode = 1;
                        });

                        // Colocamos que no estamos usando el modo del sistema
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: false);

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setDarkMode(isDarkMode: true);

                        updateUserSettings(_userSettings, _uid);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalizeFirstLetter(text: localization.dark),
                              ),
                              _userSettings.mode == 1
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.lightGreen,
                                    )
                                  : Container()
                            ],
                          ),
                          const Divider(color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Light
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userSettings.mode = 2;
                        });

                        // Colocamos que no estamos usando el modo del sistema
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: false);

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setDarkMode(isDarkMode: false);

                        updateUserSettings(_userSettings, _uid);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalizeFirstLetter(text: localization.light),
                              ),
                              _userSettings.mode == 2
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.lightGreen,
                                    )
                                  : Container()
                            ],
                          ),
                          const Divider(color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // System
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userSettings.mode = 3;
                        });

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: true);
                        updateUserSettings(_userSettings, _uid);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalizeFirstLetter(
                                    text: localization.system),
                              ),
                              _userSettings.mode == 3
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.lightGreen,
                                    )
                                  : Container()
                            ],
                          ),
                          const Divider(color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              )),

              const SizedBox(
                height: 30,
              ),

              // Tema
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.theme),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              CustomThemeSelect(
                color: colors.values.toList()[0],
                titleColor: 'SongSwipe',
                colorTitle: Colors.white,
                selected: _userSettings.theme == 0,
                function: () {
                  setState(() {
                    _userSettings.theme = 0;
                  });

                  ref.read(themeNotifierProvider.notifier).changeColorIndex(0);

                  updateUserSettings(_userSettings, _uid);
                },
              ),

              const SizedBox(
                height: 20,
              ),

              CustomThemeSelect(
                color: colors.values.toList()[1],
                titleColor: capitalizeFirstLetter(text: localization.red),
                colorTitle: Colors.white,
                selected: _userSettings.theme == 1,
                function: () {
                  setState(() {
                    _userSettings.theme = 1;
                  });

                  ref.read(themeNotifierProvider.notifier).changeColorIndex(1);
                  updateUserSettings(_userSettings, _uid);
                },
              ),

              const SizedBox(
                height: 20,
              ),

              CustomThemeSelect(
                color: colors.values.toList()[2],
                titleColor: capitalizeFirstLetter(text: localization.yellow),
                colorTitle: Colors.black,
                selected: _userSettings.theme == 2,
                function: () {
                  setState(() {
                    _userSettings.theme = 2;
                  });

                  ref.read(themeNotifierProvider.notifier).changeColorIndex(2);
                  updateUserSettings(_userSettings, _uid);
                },
              ),

              const SizedBox(
                height: 20,
              ),

              CustomThemeSelect(
                color: colors.values.toList()[3],
                titleColor: capitalizeFirstLetter(text: localization.pink),
                colorTitle: Colors.white,
                selected: _userSettings.theme == 3,
                function: () {
                  setState(() {
                    _userSettings.theme = 3;
                  });

                  ref.read(themeNotifierProvider.notifier).changeColorIndex(3);
                  updateUserSettings(_userSettings, _uid);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
