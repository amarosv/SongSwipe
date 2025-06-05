import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget que muestra de donde se obtienen los datos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomAdvertisimentWidget extends StatelessWidget {
  const CustomAdvertisimentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${capitalizeFirstLetter(text: localization.offered_by)} '),
        GestureDetector(
          onTap: () async {
            Uri uri = Uri.parse('https://www.deezer.com');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw 'No se puede abrir https://www.deezer.com';
            }
          },
          child: Text(
            'Deezer',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline
            ),
          ),
        )
      ],
    );
  }
}
