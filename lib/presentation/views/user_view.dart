import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista de usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserView extends StatefulWidget {
  /// UID del usuario
  final String uidUser;

  const UserView({super.key, required this.uidUser});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena al userprofile con sus datos
  UserProfile _userProfile = UserProfile.empty();

  // Variable que almacena si lo isgue
  bool _followed = false;
  
  // Variable que almacena si es amigo
  bool _isFriend = false;

  // Variable que almacena si se le ha enviado una solicitud de amistad
  bool _friendRequestSent = false;

  // Variable que almacena si el perfil es público
  bool _isPublic = false;

  bool _loadingFriendStatus = true;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario actual
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserProfile();
    // Obtenemos los ajustes del usuario
    _getUserSettings();
    // Comprobamos si son amigos
    _isMyFriend();
    // Comprobamos si se le ha enviado una solicitud de amistad
    _sentFriendRequest();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    if (!mounted) return;
    UserProfile user = await getUserProfile(uid: widget.uidUser);
    setState(() {
      _userProfile = user;
    });
  }

  // Función que obtiene los ajustes del usuario
  void _getUserSettings() async {
    UserSettings settings = await getUserSettings(uid: _uid);
    if (mounted) {
      setState(() {
        _isPublic = settings.privateAccount;
      });
    }
  }

  // Función que comprueba si son amigos
  void _isMyFriend() async {
    if (!mounted) return;
    _isFriend = await checkIfIsMyFriend(_uid, widget.uidUser);
    setState(() {
      _loadingFriendStatus = false;
    });
  }

  // Función que comprueba si se le ha enviado una solicitud de amistad
  void _sentFriendRequest() async {
    if (!mounted) return;
    _friendRequestSent =
        await isFriendSentRequest(uid: _uid, uidFriend: widget.uidUser);

    // Actualizamos la UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    final localization = AppLocalizations.of(context)!;

    if (_loadingFriendStatus) {
      content = const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isFriend) {
      content = CustomUserProfile(userProfile: _userProfile);
    } else if (_isPublic) {
      content = Scaffold(
        appBar: AppBar(
          title: Text(
            '@${_userProfile.username}',
            style: TextStyle(
                fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  int numFilasAfectadas =
                      await sendRequest(uid: _uid, uidFriend: widget.uidUser);

                  _followed = numFilasAfectadas > 0;

                  _getUserProfile();
                },
                child: Icon(_followed
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
                        backgroundImage: NetworkImage(_userProfile.photoUrl),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _userProfile.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30,),

                // Información de canciones y seguidores
                CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomColumn(
                            title: capitalizeFirstLetter(
                                text: localization.swipes),
                            value: humanReadbleNumber(_userProfile.swipes),
                            titleStyle: TextStyle(fontWeight: FontWeight.bold),
                            textStyle: TextStyle(fontSize: 28),
                          ),
                        ),
                        Flexible(
                          child: CustomColumn(
                            title: upperCaseAfterSpace(
                                text: localization.followers),
                            value: humanReadbleNumber(_userProfile.followers),
                            titleStyle: TextStyle(fontWeight: FontWeight.bold),
                            textStyle: TextStyle(fontSize: 28),
                          ),
                        ),
                        Flexible(
                          child: CustomColumn(
                            title: upperCaseAfterSpace(
                                text: localization.following),
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
              ],
            ),
          ),
        ),
      );
    } else {
      content = Scaffold(
        appBar: AppBar(
          title: Text(
            '@${_userProfile.username}',
            style: TextStyle(
                fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
          ),
          centerTitle: true,
        ),
        body: Padding(
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
                      backgroundImage: NetworkImage(_userProfile.photoUrl),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _userProfile.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  if (_friendRequestSent) {
                    await deleteRequest(uid: _uid, uidFriend: widget.uidUser);
                  } else {
                    await sendRequest(uid: _uid, uidFriend: widget.uidUser);
                  }
                  setState(() {
                    _friendRequestSent = !_friendRequestSent;
                  });
                },
                text: _friendRequestSent
                    ? capitalizeFirstLetter(text: localization.request_sent)
                    : capitalizeFirstLetter(text: localization.send_request),
                icon:
                    _friendRequestSent ? Icons.hourglass_top : Icons.person_add,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    return content;
  }
}
