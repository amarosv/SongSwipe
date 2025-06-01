import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Widget que personaliza la vista del perfil de un usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomUserProfile extends StatefulWidget {
  /// UID del usuario
  final String uidUser;
  const CustomUserProfile({super.key, required this.uidUser});

  @override
  State<CustomUserProfile> createState() => _CustomUserProfileState();
}

class _CustomUserProfileState extends State<CustomUserProfile> {
  // Obtenemos el usuario actual
  final User user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String uid;

  // Variable que almacena al userprofile con sus datos
  UserProfile userProfile = UserProfile.empty();

  // Variable que almacena los ajustes del usuario
  UserSettings userSettings = UserSettings.empty();

  // Boolean que almacena si lo sigue o se ha eliminado
  bool followed = true;

  // Boolean que indica si es su amigo
  bool isFriend = false;

  bool _loadingFriendStatus = true;

  @override
  void initState() {
    super.initState();
    uid = user.uid;
    loadData();
  }

  void loadData() async {
    try {
      final results = await Future.wait([
        getUserProfile(uid: widget.uidUser),
        checkIfIsMyFriend(uid: uid, uidFriend: widget.uidUser),
        checkIfIsFollowed(uid: uid, uidFriend: widget.uidUser),
        getUserSettings(uid: widget.uidUser)
      ]);

      if (!mounted) return;

      setState(() {
        userProfile = results[0] as UserProfile;
        isFriend = results[1] as bool;
        followed = results[2] as bool;
        userSettings = results[3] as UserSettings;
        _loadingFriendStatus = false;
      });

      // Redirigir si no es amigo ni lo sigue
      if (!isFriend && !followed && userSettings.privateAccount) {
        if (!mounted) return;
        context.pushReplacement('/user?uid=${widget.uidUser}');
        return;
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Función que comprueba si son amigos
  void isMyFriend() async {
    final friend = await checkIfIsMyFriend(uid: uid, uidFriend: widget.uidUser);

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

                  if (isFriend) {
                    context.pushReplacement('/user?uid=${widget.uidUser}');
                  }
                } else {
                  int numFilasAfectadas =
                      await sendRequest(uid: uid, uidFriend: userProfile.uid);

                  followed = numFilasAfectadas > 0;
                }

                loadData();
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
                      backgroundImage: userProfile.photoUrl.isNotEmpty
                          ? NetworkImage(userProfile.photoUrl)
                          : const AssetImage(
                                  'assets/images/useful/profile.webp')
                              as ImageProvider,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          userProfile.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, overflow: TextOverflow.ellipsis),
                        ),
                        isFriend
                            ? Text(
                                capitalizeFirstLetter(
                                    text: localization.your_friend),
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
                          value: GestureDetector(
                            onTap: () => context
                                .push('/swipes?uid=${widget.uidUser}&liked=2'),
                            child: Text(
                              humanReadbleNumber(userProfile.swipes),
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
                          value: GestureDetector(
                            onTap: () => context
                                .push('/followers?uid=${widget.uidUser}'),
                            child: Text(
                              humanReadbleNumber(userProfile.followers),
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
                          value: GestureDetector(
                            onTap: () => context
                                .push('/following?uid=${widget.uidUser}'),
                            child: Text(
                              humanReadbleNumber(userProfile.following),
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

              isFriend || userSettings.privacyVisSavedSongs == 0
                  ? Column(
                      children: [
                        const SizedBox(height: 30),

                        // Ver canciones favoritas
                        CustomNavigator(
                          title: Text(
                            capitalizeFirstLetter(
                                text: localization.see_fav_tracks),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  : Container(),

              isFriend || userSettings.privacyVisStats == 0
                  ? Column(
                      children: [
                        const SizedBox(height: 30),

                        // Ver sus estadisticas
                        CustomNavigator(
                          title: Text(
                            capitalizeFirstLetter(
                                text: localization.see_their_stats),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  : Container(),

              isFriend || userSettings.privacyVisSavedSongs == 0
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CustomContainer(
                          child: FutureBuilder(
                              future: getLast5Swipes(uid: widget.uidUser),
                              builder: (context, snapshot) {
                                Widget result;

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  result = Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  result = Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  result = Center(
                                      child: Text(capitalizeFirstLetter(
                                          text: localization.no_last_swipes)));
                                } else {
                                  List<Track> tracks =
                                      snapshot.data as List<Track>;

                                  result = ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: tracks.length,
                                    itemBuilder: (context, index) {
                                      Track track = tracks[index];

                                      // Construye la cadena de artistas y contributors
                                      String artists = track.buildArtistsText();

                                      return GestureDetector(
                                        onTap: () => context
                                            .push('/track?id=${track.id}'),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // Información de la canción
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          track.md5Image),
                                                      width: 64,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          track.title,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        Text(
                                                          artists,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  track.like
                                                      ? Icon(
                                                          Icons.thumb_up,
                                                          color: Colors.green,
                                                          size: 28,
                                                        )
                                                      : Icon(
                                                          Icons.thumb_down,
                                                          color: Colors.red,
                                                          size: 28,
                                                        )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              index < tracks.length - 1
                                                  ? Divider(color: Colors.white)
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                                return result;
                              }),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
