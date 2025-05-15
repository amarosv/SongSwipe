import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/presentation/views/export_views.dart';

/// Vista para la pantalla de amigos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              localization.friends.toUpperCase(),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Colors.white,
              tabs: [
                Tab(text: localization.search.toUpperCase()),
                Tab(text: localization.requests.toUpperCase()),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              SearchView(),
              RequestsView(),
            ],
          ),
        ));
  }
}
