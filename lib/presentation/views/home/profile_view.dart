import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/providers.dart';
import 'package:songswipe/config/providers/theme_provider.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_profile.dart';
import 'package:songswipe/models/user_settings.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla del perfil del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ProfileView extends ConsumerStatefulWidget {
  // Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const ProfileView(
      {super.key, required this.onChangeLanguage});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena la lista con todos los ids de las canciones
  late List<int> _allTracksIds = [];

  // Variable que almacena al userprofile con sus datos
  UserProfile _userProfile = UserProfile.empty();

  // Variable que almacena el código del idioma
  String _languageCode = '';

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Cargamos los IDs de todas las canciones
    // _loadAllTracks();
    // // Obtenemos los datos del usuario
    // _getUserProfile();
    // // Obtenemos el código del idioma
    // _getLanguageCode();
    _getData();
  }

  // Carga todos los datos
  void _getData() async {
    try {
      final results = await Future.wait([
        getUserSettings(uid: _uid),
        getSwipedTracksIds(uid: _uid),
        getUserProfile(uid: _uid),
        loadDataString(tag: 'language')
      ]);

      UserSettings userSettings = results[0] as UserSettings;

      // Guardamos el código de idioma
      widget.onChangeLanguage(userSettings.language);

      setState(() {
        _setAppearance(userSettings);
        _allTracksIds = results[1] as List<int>;
          _userProfile = results[2] as UserProfile;
        _languageCode =
            results[3] as String;
      });
    } catch (e) {
      print(e);
    }
  }

  void _setAppearance(UserSettings _userSettings) {
    // Colocamos que no estamos usando el modo del sistema
    ref.read(themeNotifierProvider.notifier).setUseSystem(isUsingSystem: false);

    // Colocamos el modo por si difiere con el local
    switch (_userSettings.mode) {
      case 1:
        // Llamamos al notifier para cambiar de modo
        ref.read(themeNotifierProvider.notifier).setDarkMode(isDarkMode: true);
        break;
      case 2:
        // Llamamos al notifier para cambiar de modo
        ref.read(themeNotifierProvider.notifier).setDarkMode(isDarkMode: false);
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

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    UserProfile user = await getUserProfile(uid: _uid);
    if (!mounted) return;
    setState(() {
      _userProfile = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    ref.listen<int>(followingChangedProvider, (prev, next) {
      if (mounted && prev != next) {
        _getUserProfile();
      }
    });

    ref.listen<bool>(swipeChangedProvider, (prev, next) {
      if (next == true && mounted) {
        _getUserProfile();
        ref.read(swipeChangedProvider.notifier).state = false;
      }
    });

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Imagen y nombre de usuario
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // grosor del borde
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: _userProfile.photoUrl.isNotEmpty
                          ? NetworkImage(_userProfile.photoUrl)
                          : const AssetImage(
                                  'assets/images/useful/profile.webp')
                              as ImageProvider,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Username
                  Expanded(
                    child: Text('@${_userProfile.username}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // Información de canciones y seguidores
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Flexible(
                        child: CustomColumn(
                          title:
                              capitalizeFirstLetter(text: localization.swipes),
                          value: InkWell(
                            onTap: () => context.push('/swipes-library',
                                extra: _allTracksIds),
                            child: Text(
                              humanReadbleNumber(_userProfile.swipes),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.followers),
                          value: InkWell(
                            onTap: () => context.push('/followers?uid=$_uid'),
                            child: Text(
                              humanReadbleNumber(_userProfile.followers),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.following),
                          value: InkWell(
                            onTap: () => context.push('/following?uid=$_uid'),
                            child: Text(
                              humanReadbleNumber(_userProfile.following),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          hasDivider: false,
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // Information
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.info),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              // Container con la información
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CustomRow(
                        title:
                            capitalizeFirstLetter(text: localization.full_name),
                        value: '${_userProfile.name} ${_userProfile.lastName}',
                      ),
                      const SizedBox(height: 20),
                      CustomRow(
                        title: capitalizeFirstLetter(text: localization.email),
                        value: _userProfile.email,
                      ),
                      const SizedBox(height: 20),
                      CustomRow(
                          title: capitalizeFirstLetter(
                              text: localization.date_joining),
                          value: _languageCode != 'en'
                              ? convertDate(_userProfile.dateJoining)
                              : _userProfile.dateJoining),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // Ver artistas favoritos
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.see_fav_artists),
                  style: TextStyle(fontSize: 18),
                ),
                function: () => context.push('/fav-artists'),
              ),

              const SizedBox(
                height: 30,
              ),

              // Ver géneros favoritas
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.see_fav_genres),
                  style: TextStyle(fontSize: 18),
                ),
                function: () => context.push('/fav-genres'),
              ),

              const SizedBox(
                height: 30,
              ),

              // Ver estadísticas
              CustomNavigator(
                title: Text(
                  capitalizeFirstLetter(text: localization.see_stats),
                  style: TextStyle(fontSize: 18),
                ),
                function: () => context.push('/stats?uid=$_uid'),
              ),

              const SizedBox(
                height: 30,
              ),

              // Editar perfil
              CustomNavigator(
                color: Theme.of(context).colorScheme.primary,
                title: Text(
                  capitalizeFirstLetter(text: localization.edit_profile),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                foregroundColor: Colors.white,
                function: () async {
                  final result = await context.push('/edit-profile');
                  if (result == true) {
                    _getUserProfile();
                  }
                },
              ),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    ));
  }
}
