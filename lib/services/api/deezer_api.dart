import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Función que obtiene los artistas recomendados de deezer <br>
/// @returns Lista de artistas recomendados
Future<List<Artist>> getRecommendedArtists() async {
  // Variable donde se almacenan los artistas recomendados
  List<Artist> listaArtistas = [];

  final url = '${Environment.apiUrlDeezer}chart/0/artists?limit=300';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final list = data['data'] as List<dynamic>;

    // Convertimos la lista de data en lista de artistas
    listaArtistas = list.map((item) => Artist.fromJson(item, 0)).toList();
  }

  return listaArtistas;
}

/// Función que recibe una query y busca un artista en la api <br>
/// @param query Query del artista a buscar <br>
/// @returns Lista de artistas
Future<List<Artist>> searchArtist(String query) async {
  // Variable donde se almacenan los artistas encontrados
  List<Artist> listaArtistas = [];

  final url = '${Environment.apiUrlDeezer}search/artist?q="$query"';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> results = data['data'];

    listaArtistas = results.map((json) => Artist.fromJson(json, 0)).toList();
  }

  return listaArtistas;
}

/// Función que obtiene todos los géneros y los devuelve como una lista <br>
/// @returns Lista de géneros
Future<List<Genre>> getAllGenres() async {
  List<Genre> genres = [];
  final url = '${Environment.apiUrlDeezer}genre';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final genreList = data['data'] as List<dynamic>;

      // genres = genreList
      //     .map((item) => Genre.fromJson(item as Map<String, dynamic>))
      //     .where((genre) {
      //       // Filtramos los géneros que no deseamos mostrar
      //       return genre.name != 'Niños' && genre.name != 'Folk';
      //     }
      // ).toList();

      genres = genreList
          .map((item) => Genre.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // print('Error: $e');
  }

  return genres;
}

/// Función que recibe una query y busca un género en la api <br>
/// @param query Query del género a buscar <br>
/// @returns Lista de géneros
Future<List<Genre>> searchGenre(String query) async {
  // Variable donde se almacenan los géneros encontrados
  List<Genre> listaGeneros = [];

  final url = '${Environment.apiUrlDeezer}search/genre?q="$query"';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> results = data['data'];

    // Convertimos la lista de data en una lista de géneros
    listaGeneros = results.map((json) => Genre.fromJson(json)).toList();
  }

  return listaGeneros;
}

/// Función que obtiene las canciones a descubrir, sin añadir las que ya ha reaccionado <br>
/// @param uid UID del usuario <br>
/// @param swipesNotUpload Lista de ids que se han reaccionado pero aún no se han subido <br>
/// @returns Lista de canciones
Future<List<Track>> getDiscoverTracks({required String uid, required List<int> swipesNotUpload}) async {
  List<Track> tracks = [];
  Random random = Random();

  try {
    // Obtener listas de artistas y géneros favoritos en paralelo
    User user = FirebaseAuth.instance.currentUser!;
    List<int> artists = await getFavoriteArtists(uid: user.uid);
    List<int> genres = await getFavoriteGenres(uid: user.uid);

    if (artists.isEmpty || genres.isEmpty) {
      print('No hay artistas o géneros disponibles.');
      return tracks; // Retorna una lista vacía si no hay datos
    }

    // Crear listas de futuros para manejar la carga en paralelo
    List<Future<List<Track>>> artistFutures = [];
    List<Future<List<Track>>> genreFutures = [];

    // Seleccionar índices únicos para artistas
    Set<int> artistIndices = {};
    while (artistIndices.length < 3 && artistIndices.length < artists.length) {
      artistIndices.add(random.nextInt(artists.length));
    }

    print('Índices de artistas seleccionados: ${artistIndices.toList()}');

    for (int index in artistIndices) {
      int randomIndex =
          random.nextInt(290); // Índice aleatorio para cada solicitud
      artistFutures.add(getTracksByArtist(uid: uid, artistId: artists[index], index: randomIndex, swipesNotUpload: swipesNotUpload));
    }

    // Seleccionar un género aleatorio
    int genreId = genres[random.nextInt(genres.length)];
    print('Género seleccionado: $genreId');
    int genreIndex =
        random.nextInt(290); // Índice aleatorio para cada solicitud
    genreFutures.add(getTracks(index: genreIndex, limit: 10, method: genreId));

    // Esperar a que todas las solicitudes se completen
    List<List<Track>> artistTracks = await Future.wait(artistFutures);
    List<List<Track>> genreTracks = await Future.wait(genreFutures);

    // Combinar los resultados
    for (var trackList in artistTracks) {
      trackList.shuffle();
      tracks.addAll(trackList);
    }

    for (var trackList in genreTracks) {
      trackList.shuffle();
      tracks.addAll(trackList);
    }

    List<int> tracksIds = [];

    for (Track track in tracks) {
      tracksIds.add(track.id);
    }

    // Comprobamos cuales de esas canciones el usuario ya ha reaccionado
    List<dynamic> idsNotSaved = await areTrackInDatabase(uid: uid, tracksIds: tracksIds);

    // Eliminamos las canciones a las que el usuario ya ha reaccionado
    tracks.removeWhere((track) => !idsNotSaved.contains(track.id) || swipesNotUpload.contains(track.id));

    // Mezclar la lista de pistas
    tracks.shuffle();
    print('Número total de pistas obtenidas: ${tracks.length}');
  } catch (e) {
    print('Error obteniendo pistas: $e');
  }

  return tracks;
}

/// Función que obtiene canciones de un artista, evitando las que ya se han reaccionado <br>
/// @param uid UID del usuario <br>
/// @param artistId ID del artista <br>
/// @param index Indice de la canción a obtener <br>
/// @param swipesNotUpload Lista de ids que se han reaccionado pero aún no se han subido <br>
/// @returns Lista de canciones
Future<List<Track>> getTracksByArtist({required String uid, required int artistId, required int index, required List<int> swipesNotUpload}) async {
  List<Track> tracks = [];

  // Primero obtenemos los detalles del artista
  Artist artistDetails =
      await getArtistDetails(artistID: artistId, savedTracks: 0);

  final url =
      '${Environment.apiUrlDeezer}artist/$artistId/top?limit=10&index=$index';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final trackList = data['data'] as List<dynamic>;

    List<int> tracksIds = [];

    for (var item in trackList) {
      Track track = Track.fromJson(item);
      tracksIds.add(track.id);
    }

    // Comprobamos cuales de esas canciones el usuario ya ha reaccionado
    List<dynamic> idsNotSaved = await areTrackInDatabase(uid: uid, tracksIds: tracksIds);

    // Eliminamos las canciones a las que el usuario ya ha reaccionado
    tracks.removeWhere((track) => !idsNotSaved.contains(track.id) || swipesNotUpload.contains(track.id));

    // Mezclar la lista de pistas
    tracks.shuffle();

    return tracks;
  } else {
    print('Error: ${response.statusCode}');
    return [];
  }
}

/// Función que obtiene los detalles del artista <br>
/// @param savedTracks Número de canciones guardadas del artista <br>
/// @param artistID ID del artista <br>
/// @returns Artista
Future<Artist> getArtistDetails(
    {required savedTracks, required int artistID}) async {
  Artist artist = Artist.empty();
  final url = 'https://api.deezer.com/artist/$artistID';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      artist = Artist.fromJson(data, savedTracks);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return artist;
}

/// Función que obtiene canciones <br>
/// @param method Método del chart <br>
/// @param limit Límite <br>
/// @param index Índice <br>
/// @returns Lista de canciones
Future<List<Track>> getTracks(
    {required int method, required int limit, required int index}) async {
  List<Track> tracks = [];

  final url =
      '${Environment.apiUrlDeezer}chart/$method/tracks?limit=$limit&index=$index';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trackList = data['data'] as List<dynamic>;

      // Crear una lista de pistas que no están guardadas en la base de datos
      List<Track> filteredTracks = [];
      for (var item in trackList) {
        Track track = Track.fromJson(item);
        filteredTracks.add(track);
      }

      filteredTracks.shuffle();

      return filteredTracks;
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return tracks;
}

/// Función que obtiene las canciones recomendadas de un artista, evitando las que ya se han reaccionado <br>
/// @param uid UID del usuario <br>
/// @param artistID ID del artista <br>
/// @param limit Límite <br>
/// @param swipesNotUpload Lista de ids que se han reaccionado pero aún no se han subido <br>
/// @returns Lista de canciones
Future<List<Track>> getRecommendedTracks(
    {required String uid, required int artistID, required int limit, required List<int> swipesNotUpload}) async {
  List<Track> tracks = [];
  List<int> tracksIds = [];
  List<dynamic> tracksNotSaved = [];

  final url = 'https://api.deezer.com/artist/$artistID/radio&limit=$limit';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trackList = data['data'] as List<dynamic>;

      // Crear una lista de pistas que no están guardadas en la base de datos
      List<Track> filteredTracks = [];
      for (var item in trackList) {
        Track track = Track.fromJson(item);
        filteredTracks.add(track);
        tracksIds.add(track.id);
      }

      // Comprobamos cuales de esas canciones el usuario ya ha reaccionado
      tracksNotSaved = await areTrackInDatabase(uid: uid, tracksIds: tracksIds);

      // Eliminamos las canciones a las que el usuario ya ha reaccionado
      filteredTracks.removeWhere((track) => !tracksNotSaved.contains(track.id) || swipesNotUpload.contains(track.id));

      filteredTracks.shuffle();
      return filteredTracks;
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return tracks;
}

/// Esta función recibe un id de canción y devuelve un objeto con todos sus datos <br>
/// @param idTrack ID de la canción <br>
/// @returns Track
Future<Track> getTrackById({required int idTrack}) async {
  // Variable que almacena la canción
  Track track = Track.empty();

  final url = '${Environment.apiUrlDeezer}track/$idTrack';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Convertimos el json en Track
    track = Track.fromJson(data);
  }

  return track;
}

/// Función que obtiene las canciones recomendadas de un artista <br>
/// @param artistID ID del artista <br>
/// @returns Lista de canciones
Future<List<Track>> getRecommendedTracksByArtist({required int artistID}) async {
  List<Track> tracks = [];
  final url = 'https://api.deezer.com/artist/$artistID/radio?limit=10';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trackList = data['data'] as List<dynamic>;

      tracks = trackList.map((item) => Track.fromJson(item)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return tracks;
}

/// Función que obtiene los detalles de un album <br>
/// @param albumID ID del album <br>
/// @returns Album
Future<Album> getAlbumDetails({required int albumID}) async {
  Album album = Album.empty();

  final url = '${Environment.apiUrlDeezer}album/$albumID';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Convertimos el json en Album
    album = Album.fromJson(data);
  }

  return album;
}

/// Función que obtiene los detalles de un género <br>
/// @param genreID ID del género <br>
/// @returns Genero
Future<Genre> getGenreDetails({required int genreID}) async {
  Genre genre = Genre.empty();

  final url = '${Environment.apiUrlDeezer}genre/$genreID';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Convertimos el json en Genre
    genre = Genre.fromJson(data);
  }

  return genre;
}