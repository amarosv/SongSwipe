import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/export_providers.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_settings.dart';
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

class _AppearanceViewState extends ConsumerState<AppearanceView>
    with WidgetsBindingObserver {
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

      // Colocamos que no estamos usando el modo del sistema
      ref
          .read(themeNotifierProvider.notifier)
          .setUseSystem(isUsingSystem: false);

      // Colocamos el modo por si difiere con el local
      switch (_userSettings.mode) {
        case 1:
          // Llamamos al notifier para cambiar de modo
          ref
              .read(themeNotifierProvider.notifier)
              .setDarkMode(isDarkMode: true);
          break;
        case 2:
          // Llamamos al notifier para cambiar de modo
          ref
              .read(themeNotifierProvider.notifier)
              .setDarkMode(isDarkMode: false);
          break;
        case 3:
          // Colocamos que no estamos usando el modo del sistema
          ref
              .read(themeNotifierProvider.notifier)
              .setUseSystem(isUsingSystem: true);
          break;
      }

      // Colocamos el tema si difiere con el local
      switch (_userSettings.theme) {
        case 0:
          {
            ref.read(themeNotifierProvider.notifier).changeColorIndex(0);
          }
        case 1:
          {
            ref.read(themeNotifierProvider.notifier).changeColorIndex(1);
          }
        case 2:
          {
            ref.read(themeNotifierProvider.notifier).changeColorIndex(2);
          }
        case 3:
          {
            ref.read(themeNotifierProvider.notifier).changeColorIndex(3);
          }
      }
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
                      onTap: () async {
                        setState(() {
                          _userSettings.mode = 1;
                        });

                        await updateUserSettings(
                            uid: _uid, settings: _userSettings);

                        // Colocamos que no estamos usando el modo del sistema
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: false);

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setDarkMode(isDarkMode: true);
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
                      onTap: () async {
                        setState(() {
                          _userSettings.mode = 2;
                        });

                        await updateUserSettings(
                            uid: _uid, settings: _userSettings);

                        // Colocamos que no estamos usando el modo del sistema
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: false);

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setDarkMode(isDarkMode: false);
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
                      onTap: () async {
                        setState(() {
                          _userSettings.mode = 3;
                        });

                        await updateUserSettings(
                            uid: _uid, settings: _userSettings);

                        // Llamamos al notifier para cambiar de modo
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setUseSystem(isUsingSystem: true);
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
                },
              ),

              const SizedBox(
                height: 30,
              ),

              // Cartas
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.cards),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              CustomSwitchContainer(
                  title:
                      capitalizeFirstLetter(text: localization.animated_cover),
                  switchValue: _userSettings.cardAnimatedCover,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.cardAnimatedCover = newValue;
                    });
                  }),

              const SizedBox(
                height: 20,
              ),

              // Saltar canciones
              CustomSwitchContainer(
                  title: capitalizeFirstLetter(text: localization.skip_songs),
                  switchValue: _userSettings.cardSkipSongs,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.cardSkipSongs = newValue;
                    });
                  }),

              const SizedBox(
                height: 20,
              ),

              // Mostrar tutorial
              CustomSwitchContainer(
                  title:
                      capitalizeFirstLetter(text: localization.show_tutorial),
                  switchValue: _userSettings.showTutorial,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.showTutorial = newValue;
                    });
                  }),

              const SizedBox(height: 20),

              // Fondo con portada difuminada
              CustomSwitchContainer(
                  title: capitalizeFirstLetter(
                      text: localization.blurred_as_background),
                  switchValue: _userSettings.cardBlurredCoverAsBackground,
                  function: (bool newValue) {
                    setState(() {
                      _userSettings.cardBlurredCoverAsBackground = newValue;
                    });
                  }),

              const SizedBox(height: 10),

              // Texto informativo para la opción blurred background
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(
                      text: localization.label_blurred_background),
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
