import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/screens/export_screens.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Clase que almacena las rutas de navegación de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AppRouter {
  /// Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  AppRouter({required this.onChangeLanguage});

  /// Función que devuelve la ruta inicial de la aplicación
  String initialLocation() => '/startup';

  late final GoRouter router = GoRouter(
    initialLocation: initialLocation(),
    routes: [
      GoRoute(
        path: '/startup',
        name: 'StartupScreen',
        builder: (context, state) =>
            StartupScreen(onChangeLanguage: onChangeLanguage),
      ),
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
        path: '/fav-artists',
        name: FavArtistsScreen.name,
        builder: (context, state) => FavArtistsScreen(),
      ),
      GoRoute(
        path: '/fav-genres',
        name: FavGenresScreen.name,
        builder: (context, state) => FavGenresScreen(),
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
      GoRoute(
        path: '/stats',
        name: StatsScreen.name,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid']!;
          return StatsScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/followers',
        name: FollowersScreen.name,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid']!;
          return FollowersScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/following',
        name: FollowingScreen.name,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid']!;
          return FollowingScreen(
            uid: uid,
          );
        },
      ),
      GoRoute(
        path: '/fav-tracks',
        name: FavTracksScreen.name,
        builder: (context, state) {
          final uid = state.uri.queryParameters['uid']!;
          final tracks = state.extra as List<int>;
          return FavTracksScreen(uid: uid, tracks: tracks);
        },
      ),
      GoRoute(
        path: '/top-tracks',
        name: TopTracksArtistScreen.name,
        builder: (context, state) {
          final tracks = state.extra as List<Track>;
          return TopTracksArtistScreen(tracks: tracks);
        },
      ),
      GoRoute(
        path: '/albums-artist',
        name: AlbumsArtistScreen.name,
        builder: (context, state) {
          final idArtist = int.parse(state.uri.queryParameters['id']!);
          final nameArtist = state.uri.queryParameters['name']!;
          return AlbumsArtistScreen(
            idArtist: idArtist,
            nameArtist: nameArtist,
          );
        },
      ),
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
        pageBuilder: (context, state) {
          final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

          return NoTransitionPage(
            child: HomeScreen(
              pageIndex: pageIndex,
              onChangeLanguage: onChangeLanguage,
            ),
          );
        },
      ),
    ],
  );
}

class StartupScreen extends StatefulWidget {
  final Function(String) onChangeLanguage;

  const StartupScreen({super.key, required this.onChangeLanguage});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectUser());
  }

  Future<void> _redirectUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      context.go('/login');
      return;
    }

    if (!user.emailVerified) {
      context.go('/verify-email');
      return;
    }

    final userDB = await getUserByUID(uid: user.uid);

    final providers = user.providerData.map((info) => info.providerId).toList();

    if (userDB.username.isEmpty && providers.contains('password')) {
      context.go('/complete-profile');
      return;
    }

    if (userDB.username.isEmpty && providers.contains('google.com')) {
      context.go('/complete-profile-simple');
      return;
    }

    final artists = await getFavoriteArtists(uid: user.uid);

    if (artists.isEmpty) {
      context.go('/select-artists');
      return;
    }

    final genres = await getFavoriteGenres(uid: user.uid);

    if (genres.isEmpty) {
      context.go('/select-genres');
      return;
    }

    context.go('/home/4');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
