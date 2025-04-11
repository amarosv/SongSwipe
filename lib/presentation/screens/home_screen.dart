import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/export_views.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Pantalla principal que muestra todas las vistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class HomeScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'home-screen';
  /// Índice de la vista a mostrar
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  /// Array que almacena las vistas
  final viewRoutes = const <Widget> [
    SettingsView(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomHomeNavigation( currentIndex: pageIndex ),
    );
  }
}