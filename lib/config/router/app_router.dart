import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/presentation/screens/export_screens.dart';

class AppRouter {
  final Function(String) onChangeLanguage;

  AppRouter({required this.onChangeLanguage});

  /// Función que comprueba si el usuario esta logeado
  /// y devuelve la ruta correspondiente
  /// @return Ruta inicial de la aplicación
  String initialLocation() {
    // Variable que almacena la ruta
    String location = '/signup';

    // Comprobamos si el usuario esta logeado
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // location = '/login';
      location = '/login';
    }

    // Devolvemos la ruta
    return location;
  }

  late final GoRouter router = GoRouter(
    initialLocation: initialLocation(),
    routes: [
      GoRoute(
        path: '/signup',
        name: SignUpScreen.name,
        builder: (context, state) =>
            SignUpScreen(onChangeLanguage: onChangeLanguage),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) =>
            LoginScreen(onChangeLanguage: onChangeLanguage),
      ),
      GoRoute(
        path: '/change-theme',
        name: ChangeThemeScreen.name,
        builder: (context, state) =>
            ChangeThemeScreen(),
      ),
      GoRoute(
        path: '/complete-profile',
        name: CompleteProfileScreen.name,
        builder: (context, state) =>
            CompleteProfileScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        name: VerifyEmailScreen.name,
        builder: (context, state) =>
            VerifyEmailScreen(),
      ),
    ],
  );
}
