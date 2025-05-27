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

/// Esta función recibe un nombre de usuario y devuelve una lista de usuarios con un username que concuerde <br>
/// @param username Nombre de usuario a buscar <br>
/// @returns Lista de usuarios
Future<List<UserApp>> getUsersByUsername({required String username}) async {
  List<UserApp> users = [];

  final url = Uri.parse('$apiUser/username/$username');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      users = (data as List).map((user) => UserApp.fromJson(user)).toList();
    }
  } catch (e) {
    print("Error de conexión: $e");
  }

  return users;
}

/// Función que recibe dos UIDs y devuelve si son amigos <br>
/// @param uid UID del usuario actual <br>
/// @param uidFriend UID del usuario amigo <br>
/// @returns Son o no amigos
Future<bool> checkIfIsMyFriend({required String uid, required String uidFriend}) async {
  // Variable que almacena si son amigos
  bool isFriend = false;

  print('$uid - $uidFriend');

  final url = Uri.parse('$apiUser/$uid/is_my_friend/$uidFriend');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      isFriend = data;
    }
  } catch (e) {
    print("Error de conexión: $e");
  }

  return isFriend;
}

/// Función que recibe dos UIDs y devuelve si lo sigue <br>
/// @param uid UID del usuario actual <br>
/// @param uidFriend UID del usuario seguido <br>
/// @returns Lo sigue o no
Future<bool> checkIfIsFollowed({required String uid, required String uidFriend}) async {
  // Variable que almacena si lo sigue
  bool followed = false;

  print('$uid - $uidFriend');

  final url = Uri.parse('$apiUser/$uid/following/$uidFriend');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      followed = data;
    }
  } catch (e) {
    print("Error de conexión: $e");
  }

  return followed;
}

/// Esta función recibe dos UIDs y envía una solicitud de amistad <br>
/// @param uid UID del usuario emisor <br>
/// @param uidFriend UID del usuario receptor <br>
/// @returns Número de filas afectadas
Future<int> sendRequest({required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/send_request');

  // Llamada a la API para enviar una solicitud
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(uidFriend)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas;
}

/// Esta función recibe dos UIDs y elimina una solicitud de amistad <br>
/// @param uid UID del usuario emisor <br>
/// @param uidFriend UID del usuario receptor <br>
/// @returns Número de filas afectadas
Future<int> deleteRequest({required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/delete_request');

  // Llamada a la API para eliminar una solicitud enviada
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(uidFriend)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas;
}

/// Esta función recibe dos UIDs y aceptamos la solicitud de amistad <br>
/// @param uid UID del usuario receptor <br>
/// @param uidFriend UID del usuario emisor <br>
/// @returns Número de filas afectadas
Future<int> acceptRequest({required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uidFriend/accept_request');

  // Llamada a la API para aceptar la solicitud
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(uid)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  print('$uid - $uidFriend');

  print(numFilasAfectadas);

  return numFilasAfectadas;
}

/// Esta función recibe dos UIDs y rechaza la solicitud de amistad <br>
/// @param uid UID del usuario receptor <br>
/// @param uidFriend UID del usuario emisor <br>
/// @returns Número de filas afectadas
Future<int> declineRequest({required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/decline_request');

  // Llamada a la API para rechazar la solicitud
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(uidFriend)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas;
}

/// Esta función recibe dos UIDs y comprueba si se ha enviado la solicitud de amistad <br>
/// @param uid UID del usuario emisor <br>
/// @param uidFriend UID del usuario receptor <br>
/// @returns Se ha enviado o no la solicitud de amistad
Future<bool> isFriendSentRequest({required String uid, required String uidFriend}) async {
  // Variable que almacenará si se ha enviado la solicitud de amistad
  bool sent = false;

  Uri url = Uri.parse('$apiUser/$uid/request_sent/$uidFriend');

  // Llamada a la API para obtener si se ha enviado una solicitud
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    sent = jsonDecode(response.body);
  }

  return sent;
}

/// Esta función recibe un UID de usuario y devuelve una lista de usuarios a los que le ha enviado una solicitud
/// de amistad <br>
/// @param uid UID del usuario
/// @returns Lista de usuarios a los que le ha enviado una solicitud de amistad
Future<List<UserApp>> getSentRequests({required String uid}) async {
  // Variable que almacenará la lista de usuarios a los que les ha enviado una solicitud de amistad
  List<UserApp> users = List.empty();

  Uri url = Uri.parse('$apiUser/$uid/list_sent_requests');

  // Llamada a la API para obtener las solicitudes enviadas
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
      final data = json.decode(response.body);
      users = (data as List).map((user) => UserApp.fromJson(user)).toList();
  }

  return users;
}

/// Esta función recibe un UID de usuario y devuelve una lista de usuarios que les han enviado una solicitud
/// de amistad <br>
/// @param uid UID del usuario
/// @returns Lista de usuarios que le han enviado una solicitud de amistad
Future<List<UserApp>> getReceiveRequests({required String uid}) async {
  // Variable que almacenará la lista de usuarios que les han enviado una solicitud de amistad
  List<UserApp> users = List.empty();

  Uri url = Uri.parse('$apiUser/$uid/list_receive_requests');

  // Llamada a la API para obtener las solicitudes recibidas
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
      final data = json.decode(response.body);
      users = (data as List).map((user) => UserApp.fromJson(user)).toList();
  }

  return users;
}

/// Esta función recibe dos UIDs y elimina al amigo <br>
/// @param uid UID del emisor <br>
/// @param uidFriend UID del amigo <br>
/// @returns Amigo eliminado o no
Future<bool> deleteFriend({required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/delete_friend');

  // Llamada a la API para eliminar a un amigo
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(uidFriend)
  );

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas > 0;
}