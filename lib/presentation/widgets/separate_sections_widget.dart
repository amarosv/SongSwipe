import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget para separar secciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SeparateSections extends StatelessWidget {
  const SeparateSections({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(localization.or),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
