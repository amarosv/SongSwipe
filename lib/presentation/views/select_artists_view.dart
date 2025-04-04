import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class SelectArtistsView extends StatelessWidget {
  const SelectArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(capitalizeFirstLetter(text: localization.select_artists)),
      ),
      body: Column(
        children: [
          CustomSearch(
            placeholder: 'Search an artist...',
            suffixIcon: Icon(Icons.search),
          )
        ],
      ),
    );
  }
}