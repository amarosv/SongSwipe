import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/externals_api.dart';

User? user = FirebaseAuth.instance.currentUser;
String apiUser = '${Environment.apiUrl}/user';

/// Función que recibe un nombre, apellidos, nombre de usuario y una imagen (opcional) y registra
/// al usuario en la base de datos <br>
/// @param name Nombre del usuario <br>
/// @param lastName Apellidos del usuario <br>
/// @param username Nombre de usuario <br>
/// @param image Imagen del usuario <br>
/// @param supplier Proovedor
/// @returns boolean que indica si el usuario se pudo crear en la base de datos
Future<bool> registerUserInDatabase(
    {required String name,
    required String lastName,
    required String username,
    File? image,
    String? supplier}) async {
  // Variable donde se almacena si el usuario se ha podido registrar
  // en la base de datos
  bool registered = false;

  // Variables que contienen datos del usuario
  String uid = user!.uid;
  String email = user!.email!;

  // 1. Guardamos la imagen del usuario en Imgbb
  String urlImage = user!.photoURL ?? 'https://i.ibb.co/tTR5wWd9/default-profile.jpg';

  if (image != null) {
    urlImage = await saveImageInImagekit(uid, image);
  }

  // 2. Creamos al usuario
  Uri url = Uri.parse(apiUser);

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
      'userBlocked': false,
      'Supplier': supplier ?? 'Email'
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
  Uri url = Uri.parse('$apiUser/$uid/artists');

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
  Uri url = Uri.parse('$apiUser/$uid/genres');

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

/// Función que recibe un UID de usuario y obtiene los datos a mostrar en la pantalla de perfil <br>
/// @param uid UID del usuario <br>
/// @returns UserProfile
Future<UserProfile> getUserProfile({required String uid}) async {
  // Variable donde se almacenará el resultado
  UserProfile userProfile = UserProfile.empty();

  // Formamos la url del endpoint
  Uri url = Uri.parse('$apiUser/$uid/profile');

  // Llamada a la API para obtener los datos del perfil del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    userProfile = UserProfile.fromJson(jsonDecode(response.body));
  }

  return userProfile;
}

// Comprueba si ya existe ese username
/// Función que comprueba si un username existe <br>
/// @param username Nombre de usuario
/// @returns Existe el username
Future<bool> checkIfUsernameExists(String username) async {
  // Variable que almacena si el nombre de usuario existe
  bool usernameExists = false;

  final url = Uri.parse('$apiUser/check-username/$username');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      usernameExists = data;
    }
  } catch (e) {
    print("Error de conexión: $e");
  }

  return usernameExists;
}

/// Función que comprueba si un email existe <br>
/// @param email Email
/// @returns Existe el email
Future<bool> checkIfEmailExists(String email) async {
  // Variable que almacena si el email existe
  bool emailExists = false;

  final url = Uri.parse('$apiUser/check-email/$email');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      emailExists = data;
    }
  } catch (e) {
    print("Error de conexión: $e");
  }

  return emailExists;
}

/// Función que recibe un UID de usuario y obtiene sus ajustes <br>
/// @param uid UID del usuario <br>
/// @returns UserSettings
Future<UserSettings> getUserSettings({required String uid}) async {
  // Variable donde se almacenará el resultado
  UserSettings userProfile = UserSettings.empty();

  // Formamos la url del endpoint
  Uri url = Uri.parse('$apiUser/$uid/settings');

  // Llamada a la API para obtener los datos del perfil del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    userProfile = UserSettings.fromJson(jsonDecode(response.body));
  }

  return userProfile;
}

/// Actualiza los ajustes del usuario <br>
/// @param settings Nuevos ajustes del usuario
/// @returns Se ha actualizado o no
Future<bool> updateUserSettings(UserSettings settings) async {
  String uid = user!.uid;

  Uri url = Uri.parse('$apiUser/$uid/settings');

  // Llamada a la API para guardar los ajustes
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(settings),
  );

  return response.statusCode == 200;
}

/// Obtiene los ids de los artistas que sigue el usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de ids de artistas
Future<List<int>> getFavoriteArtists({required String uid}) async {
  // Variable donde se almacenarán los ids de los artistas
  List<int> artistsIds = [];

  Uri url = Uri.parse('$apiUser/$uid/artists_ids');

  // Llamada a la API para obtener los ids de los artistas que sigue el usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    artistsIds = List<int>.from(jsonDecode(response.body));
  }

  return artistsIds;
}

/// Obtiene los ids de los géneros que sigue el usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de ids de géneros
Future<List<int>> getFavoriteGenres({required String uid}) async {
  // Variable donde se almacenarán los ids de los géneros
  List<int> genresIds = [];

  Uri url = Uri.parse('$apiUser/$uid/genres_ids');

  // Llamada a la API para obtener los ids de los artistas que sigue el usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    genresIds = List<int>.from(jsonDecode(response.body));
  }

  return genresIds;
}

/// Obtiene si el usuario ha guardado la canción <br>
/// @param tracksIds Lista de IDs de cnanciones <br>
/// @returns Lista con los ids de las canciones que no estan guardadas
Future<List<dynamic>> areTrackInDatabase({required List<int> tracksIds}) async {
  String uid = user!.uid;

  // Variable que almacenará los ids de las canciones
  List<dynamic> tracksNotSaved = [];

  Uri url = Uri.parse('$apiUser/$uid/tracks_not_saved');

  // Llamada a la API para obtener si la canción está guardada
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(tracksIds)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    tracksNotSaved = jsonDecode(response.body);
  }

  return tracksNotSaved;
}

/// Guarda los swipes en la base de datos <br>
/// @param swipes Lista de swipes <br>
/// @returns Número de filas afectadas
Future<int> saveSwipes({required List<Swipe> swipes}) async {
  String uid = user!.uid;

  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/save_swipes');

  // Llamada a la API para obtener si la canción está guardada
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(swipes)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas;
}