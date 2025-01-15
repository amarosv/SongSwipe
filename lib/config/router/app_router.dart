import 'package:go_router/go_router.dart';
import 'package:songswipe/presentation/screens/export_screens.dart';

class AppRouter {
  final Function(String) onChangeLanguage;

  AppRouter({required this.onChangeLanguage});

  late final GoRouter router = GoRouter(
    initialLocation: '/signup',
    routes: [
      GoRoute(
        path: '/signup',
        name: SignUpScreen.name,
        builder: (context, state) => SignUpScreen(onChangeLanguage: onChangeLanguage),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => LoginScreen(onChangeLanguage: onChangeLanguage),
      ),
    ],
  );
}