import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/presentation/views/export_views.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

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
  final GlobalKey<State<StatefulWidget>> _discoverViewKey =
      GlobalKey<State<StatefulWidget>>();

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
  void _onTabTapped(int index) async {
    // Si vamos al perfil (índice 4), guardamos los swipes antes de cambiar de vista
    // Esto se debe a que aunque en DiscoverView se guardan los swipes al cambiar de vista o salir de la app,
    // si el cambio de vista es de Discover a Profile, puede darse el caso de que los swipes aún no se han guardado
    // acabando eso en que la vista Profile no mostraría la información correcta
    if (index == 4) {
      // Accedemos a los swipes
      final discoverState = _discoverViewKey.currentState as dynamic;

      if (discoverState != null && discoverState.swipes.isNotEmpty) {
        await saveSwipes(swipes: discoverState.swipes);
      }
    }

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
    Widget currentView;

    switch (_currentIndex) {
      case 0:
        currentView = const SettingsView();
        break;
      case 1:
        currentView = const Scaffold(); // o lo que corresponda
        break;
      case 2:
        currentView = DiscoverView(key: _discoverViewKey);
        break;
      case 3:
        currentView = const Scaffold(); // o lo que corresponda
        break;
      case 4:
        currentView = const ProfileView();
        break;
      default:
        currentView = const SettingsView();
    }

    return Scaffold(
      body: currentView,
      bottomNavigationBar: CustomBottomHomeNavigation(
        currentIndex: _currentIndex,
        function: _onTabTapped,
      ),
    );
  }
}
