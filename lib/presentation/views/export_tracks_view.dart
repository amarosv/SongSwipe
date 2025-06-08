import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/export_models.dart';

/// Vista para la pantalla de exportar canciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ExportTracksView extends StatefulWidget {
  /// Lista de canciones
  final Set<Track> tracks;

  const ExportTracksView({super.key, required this.tracks});

  @override
  State<ExportTracksView> createState() => _ExportTracksViewState();
}

class _ExportTracksViewState extends State<ExportTracksView> {
  late Future<List<String>> _spotifyTrackIdsFuture;

  // Spotify PKCE Auth params
  final clientId = Environment.spotifyClientID;
  final redirectUri = 'songswipe://callback'; // Registra este URI en Spotify

  @override
  void initState() {
    super.initState();
    _spotifyTrackIdsFuture = autenticarYBuscarCanciones();
  }

  Future<String?> buscarCancionEnSpotify(
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
        print(items[0]['id']);
        return items[0]['id']; // Spotify Track ID
      }
    }
    return null;
  }

  String generarCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (_) => random.nextInt(256));
    return base64UrlEncode(Uint8List.fromList(values)).replaceAll('=', '');
  }

  String generarCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<String> autenticarConSpotify() async {
    final codeVerifier = generarCodeVerifier();
    final codeChallenge = generarCodeChallenge(codeVerifier);

    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': 'user-library-modify playlist-modify-public ugc-image-upload',
      'code_challenge_method': 'S256',
      'code_challenge': codeChallenge,
    });

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: 'songswipe',
    );

    final code = Uri.parse(result).queryParameters['code'];

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'code_verifier': codeVerifier,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Error al obtener el token');
    }
  }

  Future<void> crearPlaylistSiNoExisteYAgregarCanciones(
      String accessToken, List<String> trackIds) async {
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
          'description': 'Canciones exportadas de SongSwipe',
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
      }
    }
  }

  Future<List<String>> autenticarYBuscarCanciones() async {
    final accessToken = await autenticarConSpotify();
    final ids = <String>[];

    for (final track in widget.tracks) {
      final id = await buscarCancionEnSpotify(
          track.title, track.artist.name, accessToken);
      if (id != null) {
        ids.add(id);
      }
    }

    await crearPlaylistSiNoExisteYAgregarCanciones(accessToken, ids);

    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exportar a Spotify')),
      body: FutureBuilder<List<String>>(
        future: _spotifyTrackIdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ids = snapshot.data!;
            return Center(
              child: Text(
                '${ids.length} canciones exportadas de ${widget.tracks.length}',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}

/// Sube una imagen JPEG a la playlist de Spotify desde assets/playlist.jpg
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
