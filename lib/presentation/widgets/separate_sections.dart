import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeparateSections extends StatelessWidget {
  const SeparateSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(AppLocalizations.of(context)!.or),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
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
