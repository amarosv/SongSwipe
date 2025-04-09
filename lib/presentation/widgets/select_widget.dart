import 'package:flutter/material.dart';

/// Widget que muestra la imagen del artista y su nombre <br>
/// @author Amaro Suárez <br>
/// @version 1.1
class SelectWidget extends StatelessWidget {
  /// Url de la imagen
  final String photoUrl;

  /// Nombre
  final String artistName;

  /// Booleano que indica si está seleccionado o no
  final bool isSelected;

  const SelectWidget(
      {super.key,
      required this.photoUrl,
      required this.artistName,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen
        CircleAvatar(
          radius: 36,
          backgroundImage: NetworkImage(photoUrl),
          child: isSelected
              ? Stack(
                  children: [
                    // Imagen del artista
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    // Capa de color primario
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                      width: 72,
                      height: 72,
                    ),
                    // Icono de selección
                    Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                        size: 30,
                      ),
                    ),
                  ],
                )
              : null,
        ),

        SizedBox(height: 5),

        // Nombre
        Text(
          artistName,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis, // Trunca si es largo
          maxLines: 1,
          softWrap: false,
        )
      ],
    );
  }
}
