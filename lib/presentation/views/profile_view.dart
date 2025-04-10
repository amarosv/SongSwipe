import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  User user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String uid;
  // Variable que almacena al userprofile con sus datos
  UserProfile userProfile = UserProfile.empty();

  // Variable que almacena el código del idioma
  String languageCode = '';

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    uid = user.uid;
    // Obtenemos los datos del usuario
    _getUserProfile();
    // Obtenemos el código del idioma
    _getLanguageCode();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    UserProfile user = await getUserProfile(uid: uid);
    setState(() {
      userProfile = user;
    });
  }

  // Función que obtiene el código del idioma
  void _getLanguageCode() async {
    String code = await loadDataString(tag: 'language');
    setState(() {
      languageCode = code;
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      backgroundImage: NetworkImage(userProfile.photoUrl),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Username
                  Expanded(
                    child: Text('@${userProfile.username}',
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
                          title: capitalizeFirstLetter(text: localization.swipes),
                          value: humanReadbleNumber(userProfile.savedSongs),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title: upperCaseAfterSpace(text: localization.followers),
                          value: humanReadbleNumber(userProfile.followers),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title: upperCaseAfterSpace(text: localization.following),
                          value: humanReadbleNumber(userProfile.following),
                          hasDivider: false,
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              // Information
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.info),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
              ),
              
              // Container con la información
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CustomRow(title: 'Full name', value: '${userProfile.name} ${userProfile.lastName}',),
                      const SizedBox(height: 20),
                      CustomRow(title: 'Email', value: userProfile.email,),
                      const SizedBox(height: 20),
                      CustomRow(title: 'Fecha de unión',
                        value: languageCode != 'en'
                          ? convertDate(userProfile.dateJoining)
                          : userProfile.dateJoining
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              // Ver artistas favoritos
              GestureDetector(
                onTap: () {
                  // TODO: Que lleve a la página de ver los artistas favoritos
                },
                child: CustomContainer(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capitalizeFirstLetter(text: localization.see_fav_artists),
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              // Ver géneros favoritas
              GestureDetector(
                onTap: () {
                  // TODO: Que lleve a la página de ver los géneros favoritos
                },
                child: CustomContainer(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capitalizeFirstLetter(text: localization.see_fav_genres),
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              // Ver estadísticas
              GestureDetector(
                onTap: () {
                  // TODO: Que lleve a la págian de ver las estadísticas
                },
                child: CustomContainer(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capitalizeFirstLetter(text: localization.see_stats),
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              // Editar perfil
              GestureDetector(
                onTap: () {
                  // TODO: Que lleve a la página de editar perfil
                },
                child: CustomContainer(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capitalizeFirstLetter(text: localization.edit_profile),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
