import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de solicitudes de amistad recibidas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class RequestsReceiveView extends StatefulWidget {
  const RequestsReceiveView({super.key});

  @override
  State<RequestsReceiveView> createState() => _RequestsReceiveViewState();
}

class _RequestsReceiveViewState extends State<RequestsReceiveView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena la lista de usuarios que le han enviado una solicitud de amistad
  late Future<List<UserApp>> _users;

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario actual
    _uid = _user.uid;

    // Obtenemos la lista de solicitudes recibidas
    _users = getReceiveRequests(uid: _uid);
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
            } else if (!snapshot.hasData || (snapshot.hasData && snapshot.data!.isEmpty)) {
              result = Center(
                  child: Text(capitalizeFirstLetter(text: localization.request_receive_not_found)));
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
                            _users = getReceiveRequests(uid: _uid);
                          });
                        },
                        child: Dismissible(
                          key: Key(userApp.uid),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) async {
                            setState(() {
                              users.removeAt(index);
                            });

                            if (direction == DismissDirection.endToStart) {
                              // Rechazamos la solicitud
                              await declineRequest(uid: _uid, uidFriend: userApp.uid);
                            } else if (direction == DismissDirection.startToEnd) {
                              // Aceptamos la solicitud
                              await acceptRequest(uid: _uid, uidFriend: userApp.uid);
                            }
                          },
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: FadeInLeft(
                            child: CustomRequest(
                              userApp: userApp,
                              icon: Icon(
                                Icons.email,
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
