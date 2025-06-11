import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Uri redirect
final redirectUri = 'songswipe://callback';

/// Esta función autentica al usuario, crea la playlist y añade las canciones en Spotify <br>
/// @param tracks Lista de canciones de Deezer a exportar <br>
/// @param context BuildContext de la app <br>
/// @returns Tupla con lista de canciones de Spotify exportadas y lista de canciones fallidas
Future<(List<Map<String, String>>, List<Track>)?>
    authenticateAndSearchTracks({
  required List<Track> tracks,
  required BuildContext context,
}) async {
  final appLocalizations = AppLocalizations.of(context)!;
  final accessToken = await authenticateWithSpotify();
  
  if (accessToken == null) return null;

  List<Track> cancionesFallidas = [];
  final ids = <Map<String, String>>[];
  for (final track in tracks) {
    final data = await searchTrackInSpotify(
        track.title, track.artist.name, accessToken);
    if (data != null) {
      ids.add(data);
    } else {
      cancionesFallidas.add(track);
    }
  }
  await createPlaylist(
      accessToken, ids.map((e) => e['id']!).toList(), appLocalizations);
  // Simular una canción fallida de ejemplo
  // cancionesFallidas.add(
  //   Track(
  //       id: 9,
  //       title: 'Ejemplo Fallida',
  //       artist: Artist.empty(),
  //       album: Album.empty(),
  //       readable: false,
  //       availableCountries: [],
  //       titleShort: '',
  //       bpm: 0,
  //       contributors: [],
  //       diskNumber: 0,
  //       duration: 0,
  //       explicitContentCover: 0,
  //       explicitContentLyrics: 0,
  //       explicitLyrics: false,
  //       gain: 0,
  //       isrc: '',
  //       link: '',
  //       md5Image:
  //           'https://e-cdn-images.dzcdn.net/images/cover/0c8f7aa3b06057cb94e9b6c692f27e7d/500x500.jpg',
  //       preview: '',
  //       rank: 0,
  //       releaseDate: '',
  //       share: '',
  //       titleVersion: '',
  //       trackPosition: 0,
  //       trackToken: '',
  //       type: '',
  //       like: false,
  //       likes: 0,
  //       lyrics: ''),
  // );
  return (ids, cancionesFallidas);
}

/// Esta función autentica al usuario con Spotify <br>
/// @returns Access Token de Spotify
Future<String?> authenticateWithSpotify() async {
  final prefs = await SharedPreferences.getInstance();
  final savedRefreshToken = prefs.getString('spotify_refresh_token');
  final clientID = await getSpotifyClientID();

  if (savedRefreshToken != null) {
    final newToken = await renewToken();
    if (newToken != null) return newToken;
    print('No se pudo renovar el token desde el backend, iniciando sesión manualmente...');
  }

  // Si no hay refresh_token o no se pudo renovar, hacer autenticación manual
  final codeVerifier = generarCodeVerifier();
  final codeChallenge = generarCodeChallenge(codeVerifier);

  final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
    'response_type': 'code',
    'client_id': clientID,
    'redirect_uri': redirectUri,
    'scope': 'user-library-modify playlist-modify-public ugc-image-upload',
    'code_challenge_method': 'S256',
    'code_challenge': codeChallenge,
  });

  String? result;
  try {
    result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: 'songswipe',
    );
  } on PlatformException catch (e) {
    if (e.code == 'CANCELED') {
      return null; // usuario canceló login
    }
    rethrow;
  }

  final code = Uri.parse(result).queryParameters['code'];

  final tokenResponse = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'authorization_code',
      'code': code!,
      'redirect_uri': redirectUri,
      'client_id': clientID,
      'code_verifier': codeVerifier,
    },
  );

  if (tokenResponse.statusCode == 200) {
    final jsonResponse = jsonDecode(tokenResponse.body);
    final accessToken = jsonResponse['access_token'];
    final refreshToken = jsonResponse['refresh_token'];

    // Guardar refresh token
    await prefs.setString('spotify_refresh_token', refreshToken);

    return accessToken;
  } else {
    throw Exception('Error al obtener el token');
  }
}

/// Esta función busca la canción equivalente en Spotify <br>
/// @param title Título de la canción de Deezer <br>
/// @param artist Artista de la canción de Deezer <br>
/// @param accessToken Access Token de Spotify <br>
/// @returns Mapa con la canción de Spotify
Future<Map<String, String>?> searchTrackInSpotify(
    String title, String artist, String accessToken) async {
  final query = 'track:$title artist:$artist';
  final url = Uri.https('api.spotify.com', '/v1/search', {
    'q': query,
    'type': 'track',
    'limit': '1',
  });

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final items = data['tracks']['items'];
    if (items.isNotEmpty) {
      final track = items[0];
      final artistNames = (track['artists'] as List)
          .map((a) => a['name'])
          .whereType<String>()
          .join(', ');

      return {
        'id': track['id'],
        'title': track['name'],
        'image': track['album']['images'][0]['url'],
        'artists': artistNames,
      };
    }
  }
  return null;
}

/// Esta función crea (si no existe) la playlist en la cuenta de Spotify
/// y añade las canciones seleccionadas <br>
/// @param accessToken Access Token de Spotify <br>
/// @param trackIds IDs de las canciones de Spotify <br>
/// @param appLocalizations AppLocalizations
Future<void> createPlaylist(String accessToken,
    List<String> trackIds, AppLocalizations appLocalizations) async {
  // Paso 1: Obtener ID del usuario
  final userResponse = await http.get(
    Uri.parse('https://api.spotify.com/v1/me'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (userResponse.statusCode != 200) {
    throw Exception('Error al obtener el perfil del usuario');
  }

  final userId = json.decode(userResponse.body)['id'];

  // Paso 2: Comprobar si ya existe la playlist "SongSwipe"
  final playlistsResponse = await http.get(
    Uri.parse('https://api.spotify.com/v1/me/playlists?limit=50'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (playlistsResponse.statusCode != 200) {
    throw Exception('Error al obtener las playlists del usuario');
  }

  final playlists = json.decode(playlistsResponse.body)['items'] as List;
  final existing = playlists.firstWhere(
    (playlist) => playlist['name'] == 'SongSwipe',
    orElse: () => null,
  );

  String playlistId;
  if (existing != null) {
    playlistId = existing['id'];
  } else {
    // Paso 3: Crear playlist si no existe
    final createResponse = await http.post(
      Uri.parse('https://api.spotify.com/v1/users/$userId/playlists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': 'SongSwipe',
        'public': true,
        'description':
            capitalizeFirstLetter(text: appLocalizations.playlist_description),
      }),
    );

    if (createResponse.statusCode != 201) {
      throw Exception('Error al crear la playlist');
    }

    playlistId = json.decode(createResponse.body)['id'];
    // Subir imagen personalizada después de crear la playlist
    await subirImagenPlaylist(accessToken, playlistId);
  }

  // Paso 4: Añadir canciones a la playlist si no están ya
  final existingTracksResponse = await http.get(
    Uri.parse(
        'https://api.spotify.com/v1/playlists/$playlistId/tracks?fields=items(track(id))&limit=100'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (existingTracksResponse.statusCode != 200) {
    throw Exception('Error al obtener canciones actuales de la playlist');
  }

  final existingItems =
      json.decode(existingTracksResponse.body)['items'] as List;
  final existingIds = existingItems
      .map((item) => item['track'] != null ? item['track']['id'] : null)
      .whereType<String>()
      .toSet();

  final newUris = trackIds
      .where((id) => !existingIds.contains(id))
      .map((id) => 'spotify:track:$id')
      .toList();

  if (newUris.isNotEmpty) {
    final addResponse = await http.post(
      Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/tracks'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'uris': newUris}),
    );

    if (addResponse.statusCode != 201) {
      throw Exception('Error al añadir canciones nuevas a la playlist');
    } else {
      print('successfull');
    }
  }
}

/// Sube una imagen JPEG a la playlist de Spotify desde assets/playlist.jpg <br>
/// @param accessToken Access Token de Spotify <br>
/// @param playlistId ID de la playlist
Future<void> subirImagenPlaylist(String accessToken, String playlistId) async {
  final imageBytes =
      await rootBundle.load('assets/images/logos/logo-con-fondo.jpeg');
  final base64Image = base64Encode(imageBytes.buffer.asUint8List());

  final response = await http.put(
    Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/images'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'image/jpeg',
    },
    body: base64Image,
  );

  if (response.statusCode != 202) {
    print('Código: ${response.statusCode}');
    print('Body: ${response.body}');
    throw Exception('Error al subir la imagen de la playlist');
  }
}
