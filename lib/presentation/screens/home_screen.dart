import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/presentation/views/export_views.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Pantalla principal que muestra todas las vistas <br>
/// @author Amaro Suárez <br>
/// @version 1.1 (con recarga manual de DiscoverView)
class HomeScreen extends StatefulWidget {
  /// Nombre de la ruta
  static const name = 'home-screen';
  
  /// Índice de la vista a mostrar inicialmente
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // GlobalKey para acceder al estado de DiscoverView
  final GlobalKey<State<StatefulWidget>> _discoverViewKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex;
  }

  // Lista de vistas
  late final List<Widget> _viewRoutes = [
    const SettingsView(),
    const Scaffold(),
    DiscoverView(key: _discoverViewKey),
    const Scaffold(),
    const ProfileView(),
  ];

  // Función que se ejecuta cuandos seleccionamos una vista
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      // Forzamos recarga de DiscoverView si es seleccionada
      if (index == 2) {
        (_discoverViewKey.currentState as dynamic)?.refresh();
      }

      context.go('/home/$index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _viewRoutes,
      ),
      bottomNavigationBar: CustomBottomHomeNavigation(
        currentIndex: _currentIndex,
        function: _onTabTapped,
      ),
    );
  }
}