import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';

/// Widget que personaliza un bottom navigation con las vistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomBottomHomeNavigation extends StatelessWidget {
  /// Índice actual de la vista
  final int currentIndex;

  /// Función
  final Function(int) function;

  const CustomBottomHomeNavigation({
    super.key,
    required this.currentIndex,
    required this.function
  });

  // Función que cambia la vista
  void onItemTapped(BuildContext context, int index) {
    return context.go('/home/$index');
  }
  
  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: function,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.settings ),
          label: capitalizeFirstLetter(text: localization.settings)
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.people ),
          label: capitalizeFirstLetter(text: localization.friends)
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.search ),
          label: capitalizeFirstLetter(text: localization.discover)
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.save ),
          label: capitalizeFirstLetter(text: localization.library)
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.person ),
          label: capitalizeFirstLetter(text: localization.profile)
        ),
      ]
    );
  }
}