import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/user_app.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para mostrar a los seguidores <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FollowersView extends StatefulWidget {
  /// UID del usuario
  final String uid;

  const FollowersView({super.key, required this.uid});

  @override
  State<FollowersView> createState() => _FollowersViewState();
}

class _FollowersViewState extends State<FollowersView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena la lista de seguidores
  late List<UserApp> _followers = List.empty();

  // Variable que almacena si se está cargando los datos
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _loadData();
  }

  // Función que obtiene el listado de seguidores
  void _loadData() async {
    _followers = await getFollowersByUser(uid: widget.uid);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _uid == widget.uid
              ? localization.my_followers.toUpperCase()
              : localization.their_followers.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _followers.isEmpty
            ? Center(
              child: Text(
                capitalizeFirstLetter(text: localization.nothing_to_show),
                style: TextStyle(fontSize: 18),
              ),
            )
            : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _followers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final user = entry.value;
                    return InkWell(
                      onTap: () => user.uid == _uid
                          ? context.go('/home/4')
                          : context.push('/user?uid=${user.uid}'),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.lastName),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  user.photoUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          if (index != _followers.length - 1)
                            Divider(
                              color: Theme.of(context).dividerColor,
                              height: 1,
                              thickness: 1,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ),
            ),
          ),
    );
  }
}
