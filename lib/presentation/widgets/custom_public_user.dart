import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Widget que personaliza la vista del perfil de un usuario público <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomPublicUser extends StatefulWidget {
  /// UID del usuario
  final String uidUser;
  const CustomPublicUser({super.key, required this.uidUser});

  @override
  State<CustomPublicUser> createState() => _CustomPublicUserState();
}

class _CustomPublicUserState extends State<CustomPublicUser> {
  // Obtenemos el usuario actual
  final User user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String uid;

  // Variable que almacena al userprofile con sus datos
  UserProfile userProfile = UserProfile.empty();

  // Variable que almacena si lo isgue
  bool followed = false;

  // Variable que almacena si es amigo
  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    uid = user.uid;
    // Obtenemos el perfil del usuario
    _getUserProfile();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    if (!mounted) return;
    UserProfile user = await getUserProfile(uid: widget.uidUser);
    setState(() {
      userProfile = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@${userProfile.username}',
          style: TextStyle(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                if (isFriend || followed) {
                  followed =
                      !await deleteFriend(uid: uid, uidFriend: widget.uidUser);
                } else {
                  int numFilasAfectadas =
                      await sendRequest(uid: uid, uidFriend: userProfile.uid);

                  followed = numFilasAfectadas > 0;
                }

                _getUserProfile();
              },
              child: Icon(followed
                  ? Icons.person_remove_alt_1
                  : Icons.person_add_alt_1),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(userProfile.photoUrl),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      userProfile.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

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
                          value: humanReadbleNumber(userProfile.swipes),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.followers),
                          value: humanReadbleNumber(userProfile.followers),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.following),
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
            ],
          ),
        ),
      ),
    );
  }
}
