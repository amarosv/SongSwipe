import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/artist.dart';
import 'package:songswipe/models/genre.dart';

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

      genres = genreList.map((item) => Genre.fromJson(item as Map<String, dynamic>)).toList();
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

    listaGeneros = results.map((json) => Genre.fromJson(json)).toList();
  }

  return listaGeneros;
}