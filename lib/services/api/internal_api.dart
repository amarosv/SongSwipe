import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';

/// Función que recibe un nombre, apellidos, nombre de usuario y una imagen (opcional) y registra
/// al usuario en la base de datos <br>
/// @param name Nombre del usuario <br>
/// @param lastName Apellidos del usuario <br>
/// @param username Nombre de usuario <br>
/// @param base64Image Imagen del usuario <br>
/// @returns boolean que indica si el usuario se pudo crear en la base de datos
Future<bool> registerUserInDatabase(
    {required String name,
    required String lastName,
    required String username,
    String? base64Image}) async {
  // Variable donde se almacena si el usuario se ha podido registrar
  // en la base de datos
  bool registered = false;

  // Variables que contienen datos del usuario
  User user = FirebaseAuth.instance.currentUser!;
  String uid = user.uid;
  String email = user.email!;

  // 1. Guardamos la imagen del usuario en Imgbb
  String urlImage = 'https://i.ibb.co/tTR5wWd9/default-profile.jpg';

  Uri url =
      Uri.parse('https://api.imgbb.com/1/upload?name=$uid-${DateTime.now()}');

  if (base64Image != null) {
    // Subimos la imagen
    final response = await http.post(
      url,
      body: {
        'key': Environment.apiKey,
        'image': base64Image,
      },
    );

    // Obtenemos la url de la imagen
    urlImage = jsonDecode(response.body)['data']['url'];
  }

  // 2. Creamos al usuario
  url = Uri.parse(Environment.apiUrl);

  // Llamada a la API para guardar el usuario
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'email': email,
      'photoURL': urlImage,
      'dateJoining': 'null', // Null porque la bbdd coge la fecha actual
      'username': username,
      'userDeleted': false,
      'userBlocked': false
    }),
  );

  // Si devuelve un 200, entonces se ha guardado al usuario
  registered = response.statusCode == 200;

  return registered;
}

/// Función que recibe una lista de ids de artistas y los guarda en la base de datos
/// como favoritos <br>
/// @param artists Lista de ids de artistas
/// @returns Número de artistas que se han guardado como favoritos
Future<int> addArtistToFavorites({required List<int> artists}) async {
  // Variable que almacena el número de artistas guardados como favoritos
  int numArtistas = 0;

  // Obtenemos el UID del usuario
  User user = FirebaseAuth.instance.currentUser!;
  String uid = user.uid;

  // Formamos la url del endpoint
  Uri url = Uri.parse('${Environment.apiUrl}/$uid/artists');

  // Llamada a la API para guardar los artistas como favoritos
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(artists),
  );

  if (response.statusCode == 200) {
    numArtistas = jsonDecode(response.body);
  }

  return numArtistas;
}

/// Función que recibe una lista de ids de géneros y los guarda en la base de datos
/// como favoritos <br>
/// @param artists Lista de ids de géneros
/// @returns Número de géneros que se han guardado como favoritos
Future<int> addGenreToFavorites({required List<int> genres}) async {
  // Variable que almacena el número de géneros guardados como favoritos
  int numGeneros = 0;

  // Obtenemos el UID del usuario
  User user = FirebaseAuth.instance.currentUser!;
  String uid = user.uid;

  // Formamos la url del endpoint
  Uri url = Uri.parse('${Environment.apiUrl}/$uid/genres');

  // Llamada a la API para guardar los géneros como favoritos
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(genres),
  );

  if (response.statusCode == 200) {
    numGeneros = jsonDecode(response.body);
  }

  return numGeneros;
}