import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_app.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart'
    show deleteRequest, getSentRequests;

/// Vista para la pantalla de solicitudes de amistad enviadas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class RequestsSentView extends StatefulWidget {
  const RequestsSentView({super.key});

  @override
  State<RequestsSentView> createState() => _RequestsSentViewState();
}

class _RequestsSentViewState extends State<RequestsSentView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena la lista de usuarios a los que le han enviado una solicitud de amistad
  late Future<List<UserApp>> _users;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario actual
    _uid = _user.uid;

    // Obtenemos la lista de solicitudes enviadas
    _users = getSentRequests(uid: _uid);
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: FutureBuilder(
          future: _users,
          builder: (context, snapshot) {
            Widget result;
            if (snapshot.connectionState == ConnectionState.waiting) {
              result = const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              result = Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                (snapshot.hasData && snapshot.data!.isEmpty)) {
              result = Center(
                  child: Text(capitalizeFirstLetter(
                      text: localization.request_sent_not_found)));
            } else {
              List<UserApp> users = snapshot.data!;

              result = ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserApp userApp = users[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () async {
                          await context.push('/user?uid=${userApp.uid}');
                          setState(() {
                            _users = getSentRequests(uid: _uid);
                          });
                        },
                        child: Dismissible(
                          key: Key(userApp.uid),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            setState(() {
                              users.removeAt(index);
                            });

                            // Cancelamos la solicitud
                            deleteRequest(uid: _uid, uidFriend: userApp.uid);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: FadeInLeft(
                            child: CustomRequest(
                              userApp: userApp,
                              icon: Icon(
                                Icons.send,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }

            return result;
          }),
    );
  }
}
