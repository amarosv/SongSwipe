import 'package:flutter/material.dart';
import 'package:songswipe/models/user_app.dart';

/// Widget personalizado para mostrar los resultados de las solicitudes enviadas y recibidas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomRequest extends StatelessWidget {
  /// Usuario
  final UserApp userApp;
  
  /// Icono
  final Icon icon;

  const CustomRequest({
    super.key,
    required this.userApp, required this.icon,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
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
                  radius: 24,
                  backgroundImage: NetworkImage(userApp.photoUrl),
                ),
              ),
          
              const SizedBox(
                width: 20,
              ),
          
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de usuario
                  Text(
                    '@${userApp.username}',
                    style: TextStyle(
                        fontSize: 20, overflow: TextOverflow.ellipsis),
                  ),
          
                  // Nombre completo
                  Text(
                    '${userApp.name} ${userApp.lastName}',
                    style: TextStyle(
                        fontSize: 12, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
    
              const Spacer(),
    
              icon
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Divider(
          thickness: 2,
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}