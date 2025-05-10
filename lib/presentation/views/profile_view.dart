import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_profile.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla del perfil del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;
  // Variable que almacena al userprofile con sus datos
  UserProfile _userProfile = UserProfile.empty();

  // Variable que almacena el código del idioma
  String _languageCode = '';

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserProfile();
    // Obtenemos el código del idioma
    _getLanguageCode();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    UserProfile user = await getUserProfile(uid: _uid);
    setState(() {
      _userProfile = user;
    });
  }

  // Función que obtiene el código del idioma
  void _getLanguageCode() async {
    String code = await loadDataString(tag: 'language');
    setState(() {
      _languageCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

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
                    padding: const EdgeInsets.all(2), // grosor del borde
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(_userProfile.photoUrl),
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
                          value: humanReadbleNumber(_userProfile.savedSongs),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.followers),
                          value: humanReadbleNumber(_userProfile.followers),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.following),
                          value: humanReadbleNumber(_userProfile.following),
                          hasDivider: false,
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
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
                        title: capitalizeFirstLetter(text: localization.full_name),
                        value: '${_userProfile.name} ${_userProfile.lastName}',
                      ),
                      const SizedBox(height: 20),
                      CustomRow(
                        title: capitalizeFirstLetter(text: localization.email),
                        value: _userProfile.email,
                      ),
                      const SizedBox(height: 20),
                      CustomRow(
                          title: capitalizeFirstLetter(text: localization.date_joining),
                          value: _languageCode != 'en'
                              ? convertDate(_userProfile.dateJoining)
                              : _userProfile.dateJoining),
                      const SizedBox(height: 10),
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
              ),

              const SizedBox(
                height: 30,
              ),

              // Ver géneros favoritas
              CustomNavigator(
                title: Text(
                          capitalizeFirstLetter(
                              text: localization.see_fav_genres),
                          style: TextStyle(fontSize: 18),
                        ),
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
              ),

              const SizedBox(
                height: 30,
              ),

              // Editar perfil
              CustomNavigator(
                color: Theme.of(context).colorScheme.primary,
                title: Text(
                          capitalizeFirstLetter(
                              text: localization.edit_profile),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      foregroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
