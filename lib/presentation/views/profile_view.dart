import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Almacenamos el uid del usuario
    uid = user.uid;
    // Obtenemos los datos del usuario
    _getUserProfile();
  }

  // Función que obtiene los datos del usuario de la api
  void _getUserProfile() async {
    UserProfile user = await getUserProfile(uid: uid);
    setState(() {
      userProfile = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
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
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      CustomRow(title: 'Full name', value: '${userProfile.name} ${userProfile.lastName}',),
                      const SizedBox(height: 20),
                      CustomRow(title: 'Email', value: userProfile.email,),
                      const SizedBox(height: 20),
                      CustomRow(title: 'Fecha de unión', value: userProfile.dateJoining,),
                    ],
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
