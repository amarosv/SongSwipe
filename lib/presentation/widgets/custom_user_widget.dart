import 'package:flutter/material.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado para mostrar los resultados de la búsqueda de usuarios <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomUserWidget extends StatelessWidget {
  /// Usuario
  final UserApp user;
  const CustomUserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Imagen
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.photoUrl),
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
                '@${user.username}',
                style: TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
              ),

              // Nombre completo
              Text(
                '${user.name} ${user.lastName}',
                style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),

          const Spacer()
        ],
      ),
    ));
  }
}
