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

Future<List<Track>> getDiscoverTracks() async {
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
      artistFutures.add(getTracksByArtist(artists[index], randomIndex));
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

    // Mezclar la lista de pistas
    tracks.shuffle();
    print('Número total de pistas obtenidas: ${tracks.length}');
  } catch (e) {
    print('Error obteniendo pistas: $e');
  }

  return tracks;
}

Future<List<Track>> getTracksByArtist(int artistId, int index) async {
  // Primero obtenemos los detalles del artista
  Artist artistDetails =
      await getArtistDetails(artistID: artistId, savedTracks: 0);

  final url =
      'https://api.deezer.com/artist/$artistId/top?limit=10&index=$index';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final trackList = data['data'] as List<dynamic>;

    // Crear una lista de pistas que no están guardadas en la base de datos
    List<Track> filteredTracks = [];
    for (var item in trackList) {
      Track track = Track.fromJson(item);

      // Verificar si la canción está en la base de datos
      // TODO: Debe comprobarlas todas a la vez, no de 1 en 1 ya que tira azure
      // bool isInDatabase = await isTrackInDatabase(trackId: track.id);
      bool isInDatabase = false;

      if (!isInDatabase) {
        // Asignar los detalles del artista
        // track.artist = artistDetails;
        filteredTracks.add(track);
      }
    }

    return filteredTracks;
  } else {
    print('Error: ${response.statusCode}');
    return [];
  }
}

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

Future<List<Track>> getTracks(
    {required int method, required int limit, required int index}) async {
  List<Track> tracks = [];
  final url =
      'https://api.deezer.com/chart/$method/tracks?limit=$limit&index=$index';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trackList = data['data'] as List<dynamic>;

      // Crear una lista de pistas que no están guardadas en la base de datos
      List<Track> filteredTracks = [];
      for (var item in trackList) {
        Track track = Track.fromJson(item);

        // Verificar si la canción está en la base de datos

        // TODO: Debe comprobarlas todas a la vez, no de 1 en 1 ya que tira azure
        // bool isInDatabase = await isTrackInDatabase(trackId: track.id);
        bool isInDatabase = false;

        if (!isInDatabase) {
          filteredTracks.add(track);
        }
      }

      return filteredTracks;
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return tracks;
}
