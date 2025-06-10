import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/screens/export_screens.dart';

/// Clase que almacena las rutas de navegación de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AppRouter {
  /// Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  AppRouter({required this.onChangeLanguage});

  /// Función que comprueba si el usuario esta logeado
  /// y devuelve la ruta correspondiente
  /// @returns Ruta inicial de la aplicación
  String initialLocation() {
    // Variable que almacena la ruta
    String location = '/signup';

    // Comprobamos si el usuario esta logeado
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      location = '/verify-email';
    } else if (user != null && user.emailVerified) {
      location = '/select-artists';
    }

    location = '/home/4';

    if (user == null) {
      location = '/login';
    }
    // location = '/change-theme';

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
        builder: (context, state) => ChangeThemeScreen(),
      ),
      GoRoute(
        path: '/complete-profile',
        name: CompleteProfileScreen.name,
        builder: (context, state) => CompleteProfileScreen(),
      ),
      GoRoute(
        path: '/complete-profile-simple',
        name: CompleteProfileSimpleScreen.name,
        builder: (context, state) {
          final supplier = state.uri.queryParameters['supplier'];
          return CompleteProfileSimpleScreen(supplier: supplier!);
        },
      ),
      GoRoute(
        path: '/verify-email',
        name: VerifyEmailScreen.name,
        builder: (context, state) => VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/select-artists',
        name: SelectArtistsScreen.name,
        builder: (context, state) => SelectArtistsScreen(),
      ),
      GoRoute(
        path: '/select-genres',
        name: SelectGenresScreen.name,
        builder: (context, state) => SelectGenresScreen(),
      ),
      GoRoute(
        path: '/language-settings',
        name: LanguageScreen.name,
        builder: (context, state) => LanguageScreen(
          onChangeLanguage: onChangeLanguage,
        ),
      ),
      GoRoute(
        path: '/appearance-settings',
        name: AppearanceScreen.name,
        builder: (context, state) => AppearanceScreen(),
      ),
      GoRoute(
        path: '/privacy-settings',
        name: PrivacyScreen.name,
        builder: (context, state) => PrivacyScreen(),
      ),
      GoRoute(
        path: '/audio-settings',
        name: AudioScreen.name,
        builder: (context, state) => AudioScreen(),
      ),
      GoRoute(
        path: '/notifications-settings',
        name: NotificationsScreen.name,
        builder: (context, state) => NotificationsScreen(),
      ),
      GoRoute(
        path: '/about-settings',
        name: AboutScreen.name,
        builder: (context, state) => AboutScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: EditProfileScreen.name,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/user',
        name: UserScreen.name,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid'];
          return UserScreen(
            uidUser: uid!,
          );
        },
      ),
      GoRoute(
        path: '/track',
        name: InfoTrackScreen.name,
        builder: (context, state) {
          final idTrack = int.parse(state.uri.queryParameters['id']!);
          return InfoTrackScreen(
            idTrack: idTrack,
          );
        },
      ),
      GoRoute(
        path: '/lyrics',
        name: LyricsScreen.name,
        builder: (context, state) {
          final lyrics = state.uri.queryParameters['lyrics']!;
          final trackTitle = state.uri.queryParameters['title']!;
          final trackArtists = state.uri.queryParameters['artists']!;
          final trackCover = state.uri.queryParameters['cover']!;

          return LyricsScreen(
            lyrics: lyrics,
            trackTitle: trackTitle,
            trackArtists: trackArtists,
            trackCover: trackCover,
          );
        },
      ),
      GoRoute(
        path: '/album',
        name: InfoAlbumScreen.name,
        builder: (context, state) {
          final idAlbum = int.parse(state.uri.queryParameters['id']!);
          return InfoAlbumScreen(
            idAlbum: idAlbum,
          );
        },
      ),
      GoRoute(
        path: '/artist',
        name: InfoArtistScreen.name,
        builder: (context, state) {
          final idArtist = int.parse(state.uri.queryParameters['id']!);
          return InfoArtistScreen(
            idArtist: idArtist,
          );
        },
      ),
      GoRoute(
        path: '/swipes',
        name: SwipesScreen.name,
        builder: (context, state) {
          final tracks = state.extra as List<Track>;
          return SwipesScreen(tracks: tracks);
        },
      ),
      GoRoute(
        path: '/swipes-library',
        name: SwipesLibraryScreen.name,
        builder: (context, state) {
          final tracks = state.extra as List<int>;
          return SwipesLibraryScreen(tracks: tracks);
        },
      ),
      // TODO: /followers
      // TODO: /following
      GoRoute(
        path: '/export',
        name: ExportTracksScreen.name,
        builder: (context, state) {
          final tracks = state.extra as Set<Track>;
          return ExportTracksScreen(tracks: tracks);
        },
      ),
      GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

          return HomeScreen(pageIndex: pageIndex);
        },
      ),
    ],
  );
}
