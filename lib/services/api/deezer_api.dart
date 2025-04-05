import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/artist.dart';

/// Función que obtiene los artistas recomendados de deezer <br>
/// @return Lista de artistas recomendados
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
/// @return Lista de artistas
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