import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Widget que personaliza la vista del perfil de un usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomUserProfile extends StatefulWidget {
  /// Datos del usuario
  final UserProfile userProfile;
  const CustomUserProfile({super.key, required this.userProfile});

  @override
  State<CustomUserProfile> createState() => _CustomUserProfileState();
}

class _CustomUserProfileState extends State<CustomUserProfile> {
  // Obtenemos el usuario actual
  final User user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String uid;

  // Boolean que almacena si lo sigue o se ha eliminado
  bool followed = true;

  // Boolean que indica si es su amigo
  bool isFriend = false;

  bool _loadingFriendStatus = true;

  @override
  void initState() {
    super.initState();
    print('hi');
    // Almacenamos el uid del usuario actual
    uid = user.uid;
    // Comprobamos si son amigos
    isMyFriend();
  }

  // Función que comprueba si son amigos
  void isMyFriend() async {
    final friend = await checkIfIsMyFriend(uid, widget.userProfile.uid);

    setState(() {
      isFriend = friend;
      _loadingFriendStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    if (_loadingFriendStatus) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@${widget.userProfile.username}',
          style: TextStyle(
              fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                followed = !await deleteFriend(
                    uid: uid, uidFriend: widget.userProfile.uid);

                setState(() {});
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
                      backgroundImage: widget.userProfile.photoUrl.isNotEmpty
                        ? NetworkImage(widget.userProfile.photoUrl)
                        : const AssetImage('assets/images/useful/profile.webp') as ImageProvider,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.userProfile.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, overflow: TextOverflow.ellipsis),
                        ),
                        isFriend
                            ? Text(
                                capitalizeFirstLetter(text: localization.your_friend),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    overflow: TextOverflow.ellipsis),
                              )
                            : Container()
                      ],
                    ),
                  ),
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
                          value: humanReadbleNumber(widget.userProfile.swipes),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.followers),
                          value:
                              humanReadbleNumber(widget.userProfile.followers),
                          titleStyle: TextStyle(fontWeight: FontWeight.bold),
                          textStyle: TextStyle(fontSize: 28),
                        ),
                      ),
                      Flexible(
                        child: CustomColumn(
                          title:
                              upperCaseAfterSpace(text: localization.following),
                          value:
                              humanReadbleNumber(widget.userProfile.following),
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
