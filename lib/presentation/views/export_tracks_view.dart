import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';


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
  late Future<List<Map<String, String>>> _spotifyTrackDataFuture;
  late List<Track> _cancionesFallidas;

  // Spotify PKCE Auth params
  final clientId = Environment.spotifyClientID;
  final redirectUri = 'songswipe://callback'; // Registra este URI en Spotify

  @override
  void initState() {
    super.initState();
    _spotifyTrackDataFuture = autenticarYBuscarCanciones();
  }

  Future<Map<String, String>?> buscarCancionEnSpotify(
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
    final prefs = await SharedPreferences.getInstance();
    final savedRefreshToken = prefs.getString('spotify_refresh_token');

    if (savedRefreshToken != null) {
      // Intentar renovar el token
      final refreshResponse = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': savedRefreshToken,
          'client_id': clientId,
        },
      );

      if (refreshResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(refreshResponse.body);
        final newAccessToken = jsonResponse['access_token'];
        return newAccessToken;
      } else {
        print('No se pudo renovar el token, iniciando sesión manualmente...');
      }
    }

    // Si no hay refresh_token o no se pudo renovar, hacer autenticación manual
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

    final tokenResponse = await http.post(
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

  Future<List<Map<String, String>>> autenticarYBuscarCanciones() async {
    final accessToken = await autenticarConSpotify();
    final ids = <Map<String, String>>[];
    _cancionesFallidas = [];
    for (final track in widget.tracks) {
      final data = await buscarCancionEnSpotify(
          track.title, track.artist.name, accessToken);
      if (data != null) {
        ids.add(data);
      } else {
        _cancionesFallidas.add(track);
      }
    }
    await crearPlaylistSiNoExisteYAgregarCanciones(
        accessToken, ids.map((e) => e['id']!).toList());
    // Simular una canción fallida de ejemplo
    _cancionesFallidas.add(
      Track(
          id: 9,
          title: 'Ejemplo Fallida',
          artist: Artist.empty(),
          album: Album.empty(),
          readable: false,
          availableCountries: [],
          titleShort: '',
          bpm: 0,
          contributors: [],
          diskNumber: 0,
          duration: 0,
          explicitContentCover: 0,
          explicitContentLyrics: 0,
          explicitLyrics: false,
          gain: 0,
          isrc: '',
          link: '',
          md5Image:
              'https://e-cdn-images.dzcdn.net/images/cover/0c8f7aa3b06057cb94e9b6c692f27e7d/500x500.jpg',
          preview: '',
          rank: 0,
          releaseDate: '',
          share: '',
          titleVersion: '',
          trackPosition: 0,
          trackToken: '',
          type: '',
          like: false,
          likes: 0,
          lyrics: ''),
    );
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(capitalizeFirstLetter(text: '${localization.export_to} Spotify'))),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _spotifyTrackDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final spotifyData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        '${spotifyData.length} ${localization.of_txt} ${widget.tracks.length} ${localization.tracks_exported}',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_cancionesFallidas.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalizeFirstLetter(text: '${localization.cant_export} ${_cancionesFallidas.length} ${localization.tracks}:'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ..._cancionesFallidas.map((track) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: CustomContainer(
                                    color: Colors.transparent,
                                    borderColor: Colors.red,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          track.md5Image,
                                          height: 64,
                                          width: 64,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                track.title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                track.buildArtistsText(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        capitalizeFirstLetter(text: '${localization.tracks_succes_export}:'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.tracks.length,
                      itemBuilder: (context, index) {
                        final track = widget.tracks.elementAt(index);
                        Map<String, String>? spotifyTrack;
                        if (index < spotifyData.length) {
                          spotifyTrack = spotifyData[index];
                        }
                
                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Deezer')),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomContainer(
                                color: Colors.transparent,
                                borderColor: Colors.black,
                                child: Row(
                                  children: [
                                    Image.network(
                                      track.album.cover,
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            track.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            track.buildArtistsText(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(localization.as.toUpperCase(),),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Spotify')),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomContainer(
                                color: Colors.transparent,
                                borderColor: Colors.black,
                                child: Row(
                                  children: [
                                    Image.network(
                                      spotifyTrack != null
                                          ? (spotifyTrack['image'] ?? '')
                                          : '',
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            spotifyTrack != null
                                                ? (spotifyTrack['title'] ??
                                                    'Sin título')
                                                : 'Sin título',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            spotifyTrack != null
                                                ? (spotifyTrack['artists'] ??
                                                    'Sin título')
                                                : 'Sin título',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
