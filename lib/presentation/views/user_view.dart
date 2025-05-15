import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/models/user_profile.dart';
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

  // Variable que almacena si es amigo
  bool _isFriend = false;

  bool _friendRequestSent = false;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario actual
    _uid = _user.uid;
    // Obtenemos los datos del usuario
    _getUserProfile();
    // Comprobamos si son amigos
    _isMyFriend();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    if (!mounted) return;
    UserProfile user = await getUserProfile(uid: widget.uidUser);
    setState(() {
      _userProfile = user;
    });
  }

  // Función que comprueba si son amigos
  void _isMyFriend() async {
    if (!mounted) return;
    _isFriend = await checkIfIsMyFriend(_uid, widget.uidUser);

    // Actualizamos la UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return _isFriend
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                '@${_userProfile.username}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Imagen
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
                          style: TextStyle(
                            fontSize: 24,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botón para enviar solicitud de amistad
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
                    icon: _friendRequestSent
                      ? Icons.hourglass_top
                      : Icons.person_add,
                    iconColor: Colors.white,
                  ),
                ],
              ),
            ),
          );
  }
}
