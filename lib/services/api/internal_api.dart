import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/services/api/externals_api.dart';

String apiUser = '${Environment.apiUrl}/user';
String apiTrack = '${Environment.apiUrl}/track';
String apiAlbum = '${Environment.apiUrl}/album';
String apiArtist = '${Environment.apiUrl}/artist';
String apiSpotify = '${Environment.apiUrl}/spotify';

/// Función que recibe un objeto user, nombre, apellidos, nombre de usuario y una imagen (opcional) y registra
/// al usuario en la base de datos <br>
/// @param user Usuario <br>
/// @param name Nombre del usuario <br>
/// @param lastName Apellidos del usuario <br>
/// @param username Nombre de usuario <br>
/// @param image Imagen del usuario <br>
/// @param supplier Proovedor
/// @returns boolean que indica si el usuario se pudo crear en la base de datos
Future<bool> registerUserInDatabase(
    {required User user,
    required String name,
    required String lastName,
    required String username,
    File? image,
    String? supplier}) async {
  // Variable donde se almacena si el usuario se ha podido registrar
  // en la base de datos
  bool registered = false;

  // Variables que contienen datos del usuario
  String uid = user.uid;
  String email = user.email!;

  // 1. Guardamos la imagen del usuario en Imgbb
  String urlImage =
      user.photoURL ?? 'https://i.ibb.co/tTR5wWd9/default-profile.jpg';

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
/// @param artists Lista de ids de artistas <br>
/// @returns Número de artistas que se han guardado como favoritos
Future<int> addArtistToFavorites(
    {required String uid, required List<int> artists}) async {
  // Variable que almacena el número de artistas guardados como favoritos
  int numArtistas = 0;

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
Future<int> addGenreToFavorites(
    {required String uid, required List<int> genres}) async {
  // Variable que almacena el número de géneros guardados como favoritos
  int numGeneros = 0;

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
/// @param uid UID del usuario <br>
/// @param settings Nuevos ajustes del usuario
/// @returns Se ha actualizado o no
Future<bool> updateUserSettings(
    {required String uid, required UserSettings settings}) async {
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
/// @param uid UID del usuario <br>
/// @param tracksIds Lista de IDs de cnanciones <br>
/// @returns Lista con los ids de las canciones que no estan guardadas
Future<List<dynamic>> areTrackInDatabase(
    {required String uid, required List<int> tracksIds}) async {
  // Variable que almacenará los ids de las canciones
  List<dynamic> tracksNotSaved = [];

  Uri url = Uri.parse('$apiUser/$uid/tracks_not_saved');

  // Llamada a la API para obtener si la canción está guardada
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(tracksIds));

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    tracksNotSaved = jsonDecode(response.body);
  }

  return tracksNotSaved;
}

/// Guarda los swipes en la base de datos <br>
/// @param uid UID del usuario <br>
/// @param swipes Lista de swipes <br>
/// @returns Número de filas afectadas
Future<int> saveSwipes(
    {required String uid, required List<Swipe> swipes}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/save_swipes');

  // Llamada a la API para obtener si la canción está guardada
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(swipes));

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
Future<bool> checkIfIsMyFriend(
    {required String uid, required String uidFriend}) async {
  // Variable que almacena si son amigos
  bool isFriend = false;

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
Future<bool> checkIfIsFollowed(
    {required String uid, required String uidFriend}) async {
  // Variable que almacena si lo sigue
  bool followed = false;

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
Future<int> sendRequest(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/send_request');

  // Llamada a la API para enviar una solicitud
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(uidFriend));

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
Future<int> deleteRequest(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/delete_request');

  // Llamada a la API para eliminar una solicitud enviada
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(uidFriend));

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
Future<int> acceptRequest(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uidFriend/accept_request');

  // Llamada a la API para aceptar la solicitud
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(uid));

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
Future<int> declineRequest(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/decline_request');

  // Llamada a la API para rechazar la solicitud
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(uidFriend));

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
Future<bool> isFriendSentRequest(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará si se ha enviado la solicitud de amistad
  bool sent = false;

  Uri url = Uri.parse('$apiUser/$uid/request_sent/$uidFriend');

  // Llamada a la API para obtener si se ha enviado una solicitud
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

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
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

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
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

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
Future<bool> deleteFriend(
    {required String uid, required String uidFriend}) async {
  // Variable que almacenará el número de filas afectadas
  int numFilasAfectadas = 0;

  Uri url = Uri.parse('$apiUser/$uid/delete_friend');

  // Llamada a la API para eliminar a un amigo
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(uidFriend));

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    numFilasAfectadas = jsonDecode(response.body);
  }

  return numFilasAfectadas > 0;
}

/// Esta función recibe un UID de usuario y devuelve sus últimos 5 swipes <br>
/// @param uid UID del usuario <br>
/// @returns Últimos 5 swipes
Future<List<Track>> getLast5Swipes({required String uid}) async {
  List<Track> tracks = List.empty();

  Uri url = Uri.parse('$apiUser/$uid/last_swipes');

  // Llamada a la API para obtener los últimos 5 swipes
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    tracks = (data as List).map((track) => Track.fromJson(track)).toList();
  }

  return tracks;
}

/// Esta función recibe el UID de un usuario y un booleano que indica si quiere buscar las canciones que le han gustado
/// o que no y las devuelve como una lista paginada <br>
/// @param uid UID del usuario <br>
/// @param liked (opcional) Boolean que indica si desea obtener las que le gustó o las que no <br>
/// @param url (opcional) URL a buscar <br>
/// @returns Lista de canciones paginada
Future<PaginatedTracks> getLibraryUser(
    {required String uid,
    bool liked = true,
    String url = '',
    int limit = 10}) async {
  PaginatedTracks paginatedTracks = PaginatedTracks.empty();

  if (url.isEmpty) {
    url = '$apiUser/$uid/${liked ? 'liked' : 'disliked'}';
  }

  Uri uri = Uri.parse(url);

  // Llamada a la API para obtener las canciones del usuario
  final response = await http.get(uri, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    paginatedTracks = PaginatedTracks.fromJson(json.decode(response.body));
  }

  return paginatedTracks;
}

/// Esta función recibe el UID de un usuario y un ID de canción y devuelve si el usuario la
/// ha marcado como me gusta <br>
/// @param uid UID del usuario <br>
/// @param idTrack ID de la canción <br>
/// @returns Bool que indica si ha marcado la canción como me gusta
Future<bool> isTrackLiked({required String uid, required int idTrack}) async {
  bool exists = false;

  Uri url = Uri.parse('$apiUser/$uid/is_track_liked/$idTrack');

  // Llamada a la API para obtener si se ha marcado la canción como favorita
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    exists = json.decode(response.body);
  }

  return exists;
}

/// Esta función recibe el UID de un usuario, el ID de una canción y el nuevo valor del like del Swipe
/// y lo actualiza en la base de datos <br>
/// @param uid UID del usuario <br>
/// @param idTrack ID de la canción <br>
/// @param newLike Valor del nuevo like del Swipe <br>
/// @returns Bool que indica si se ha actualizado
Future<bool> updateSwipe(
    {required String uid, required int idTrack, required int newLike}) async {
  Uri url = Uri.parse('$apiUser/$uid/update_swipe');

  print('UPDATING...');
  print(idTrack);
  print(newLike);

  // Llamada a la API para guardar los ajustes
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({'id': idTrack, 'like': newLike}),
  );

  return response.statusCode == 200;
}

/// Función que recibe el ID de una canción y devuelve sus stats <br>
/// @param idTrack ID de la canción <br>
/// @returns Stats
Future<Stats> getTrackStats({required int idTrack}) async {
  Stats stats = Stats.empty();

  Uri url = Uri.parse('$apiTrack/$idTrack/stats');

  // Llamada a la API para obtener las stats de la canción
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    stats = Stats.fromJson(json.decode(response.body));
  }

  return stats;
}

/// Función que recibe el ID de un album y devuelve sus stats <br>
/// @param idAlbum ID de la album <br>
/// @returns Stats
Future<Stats> getAlbumStats({required int idAlbum}) async {
  Stats stats = Stats.empty();

  Uri url = Uri.parse('$apiAlbum/$idAlbum/stats');

  // Llamada a la API para obtener las stats del album
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    stats = Stats.fromJson(json.decode(response.body));
  }

  return stats;
}

/// Función que recibe el ID de un artista y devuelve sus stats <br>
/// @param idArtist ID del artista <br>
/// @returns Stats
Future<Stats> getArtistStats({required int idArtist}) async {
  Stats stats = Stats.empty();

  Uri url = Uri.parse('$apiArtist/$idArtist/stats');

  // Llamada a la API para obtener las stats del artista
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    stats = Stats.fromJson(json.decode(response.body));
  }

  return stats;
}

/// Esta función recibe una lista de IDs de canciones y devuelve sus stats <br>
/// @param idTracks Lista de IDs de canciones <br>
/// @returns Mapa con el id de cada canción y sus stats
Future<Map<int, Stats>> getTracksStats({required List<int> idTracks}) async {
  // Variable que almacenará el mapa con los datos
  Map<int, Stats> stats = <int, Stats>{};

  Uri url = Uri.parse('$apiTrack/stats');

  // Llamada a la API para obtener las stats
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(idTracks));

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    stats = data
        .map((key, value) => MapEntry(int.parse(key), Stats.fromJson(value)));
  }

  return stats;
}

/// Esta función recibe el UID de un usuario y devuelve sus datos <br>
/// @param uid UID del usuario <br>
/// @returns Usuario
Future<UserApp> getUserByUID({required String uid}) async {
  // Variable que almacena los datos del usuario
  UserApp userApp = UserApp.empty();

  Uri url = Uri.parse('$apiUser/$uid');

  // Llamada a la API para obtener los datos del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    userApp = UserApp.fromJson(jsonDecode(response.body));
  }

  return userApp;
}

/// Esta función recibe un usuario actualizado y lo actualiza en la base de datos <br>
/// @param user UserApp <br>
/// @returns Bool que indica si se ha actualizado o no el usuario
Future<bool> updateUser({required UserApp user}) async {
  bool updated = false;

  Uri url = Uri.parse('$apiUser/${user.uid}');

  // Llamada a la API para obtener las stats
  final response = await http.put(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(user));

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    UserApp userApp = UserApp.fromJson(jsonDecode(response.body));

    updated = user.photoUrl == userApp.photoUrl &&
        user.name == userApp.name &&
        user.lastName == userApp.lastName &&
        user.username == userApp.username;
  }

  return updated;
}

/// Esta función recibe el ID de un artista y obtiene el número de canciones guardadas (tanto como me gusta como no me gusta) <br>
/// @param idArtist ID del artista <br>
/// @returns Número de canciones guardadas
Future<int> getSavedSongsByArtist({required int idArtist}) async {
  int total = 0;

  Uri url = Uri.parse('$apiArtist/$idArtist/saved_tracks');

  // Llamada a la API para obtener el número de canciones guardadas
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    total = jsonDecode(response.body);
  }

  return total;
}

/// Esta función recibe el UID de un usuario y un ID de artista y devuelve si el usuario lo
/// ha marcado como favorito <br>
/// @param uid UID del usuario <br>
/// @param idArtist ID del artista <br>
/// @returns Bool que indica si ha marcado al artista como favorio
Future<bool> isArtistFavorite(
    {required String uid, required int idArtist}) async {
  bool exists = false;

  Uri url = Uri.parse('$apiUser/$uid/is_artist_favorite/$idArtist');

  // Llamada a la API para obtener si se ha marcado el artista como favorito
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  // Si la respuesta es 200, parseamos el json
  if (response.statusCode == 200) {
    exists = json.decode(response.body);
  }

  return exists;
}

/// Esta función recibe el ID de un artista y devuelve el top 3 de sus canciones con más me gustas <br>
/// @param idArtist ID del artista <br>
/// @returns Lista de canciones
Future<List<Track>> getTopTracksByArtist({required int idArtist}) async {
  List<Track> tracks = List<Track>.empty();

  Uri url = Uri.parse('$apiArtist/$idArtist/top_tracks');

  // Llamada a la API para obtener el top 3 canciones
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    tracks = (data as List).map((track) => Track.fromJson(track)).toList();
  }

  return tracks;
}

/// Esta función recibe el ID de un artista y devuelve el top 3 de sus albumes con más me gustas <br>
/// @param idArtist ID del artista <br>
/// @returns Lista de albumes
Future<List<Album>> getTopAlbumsByArtist({required int idArtist}) async {
  List<Album> albums = List<Album>.empty();

  Uri url = Uri.parse('$apiArtist/$idArtist/top_albums');

  // Llamada a la API para obtener el top 3 albumes
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    albums = (data as List).map((album) => Album.fromJson(album)).toList();
  }

  return albums;
}

/// Esta función recibe el UID de un usuario y el ID del artista y lo elimina de sus favoritos <br>
/// @param uid UID del usuario <br>
/// @param idArtist ID del artista a eliminar <br>
/// @returns Bool que indica si se ha eliminado el artista
Future<bool> deleteArtistFromFavorites(
    {required String uid, required int idArtist}) async {
  bool deleted = false;

  Uri url = Uri.parse('$apiUser/$uid/artist/$idArtist');

  // Llamada a la API para eliminar al artista
  final response = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    deleted = jsonDecode(response.body) > 0;
  }

  return deleted;
}

/// Esta función envia una petición para renovar el token de Spotify <br>
/// @returns Nuevo token
Future<String?> renewToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('spotify_refresh_token');

  if (refreshToken == null) return null;

  final response = await http.post(
    Uri.parse('$apiSpotify/refresh'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refreshToken': refreshToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final newAccessToken = data['access_token'];
    final newRefreshToken = data['refresh_token'];

    await prefs.setString('spotify_refresh_token', newRefreshToken);
    return newAccessToken;
  } else {
    print('Error renovando token desde backend: ${response.body}');
    return null;
  }
}

/// Esta función devuelve el client ID de la app de Spotify <br>
/// @returns Client ID de la app en Spotify
Future<String> getSpotifyClientID() async {
  String clientId = '';

  Uri url = Uri.parse('$apiSpotify/client_id');

  // Llamada a la API para obtener el client ID
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    clientId = json.decode(response.body);
  }

  return clientId;
}

/// Esta función recibe el UID de un usuario y devuelve un listado de IDs de canciones que le han gustado <br>
/// @param uid UID del usuario <br>
/// @returns Lista de IDs
Future<List<int>> getLikedTracksIds({required String uid}) async {
  List<int> ids = [];

  Uri url = Uri.parse('$apiUser/$uid/liked_ids');

  // Llamada a la API para obtener los ids de las canciones que le han gustado
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    ids = List<int>.from(json.decode(response.body));
  }

  return ids;
}

/// Esta función recibe el UID de un usuario y devuelve un listado de IDs de canciones que no le han gustado <br>
/// @param uid UID del usuario <br>
/// @returns Lista de IDs
Future<List<int>> getDislikedTracksIds({required String uid}) async {
  List<int> ids = [];

  Uri url = Uri.parse('$apiUser/$uid/disliked_ids');

  // Llamada a la API para obtener los ids de las canciones que no le han gustado
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    ids = List<int>.from(json.decode(response.body));
  }

  return ids;
}

/// Esta función recibe el UID de un usuario y devuelve un listado de IDs de canciones ha swipeado <br>
/// @param uid UID del usuario <br>
/// @returns Lista de IDs
Future<List<int>> getSwipedTracksIds({required String uid}) async {
  List<int> ids = [];

  Uri url = Uri.parse('$apiUser/$uid/swiped_ids');

  // Llamada a la API para obtener los ids de las canciones que ha swipeado
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    ids = List<int>.from(json.decode(response.body));
  }

  return ids;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 artistas con más me gustas del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de artistas
Future<List<Artist>> getTopLikedArtistsByUser({required String uid}) async {
  List<Artist> artists = [];

  Uri url = Uri.parse('$apiUser/$uid/top_liked_artists');

  // Llamada a la API para obtener los 10 artistas con más likes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    artists =
        (data as List).map((artist) => Artist.fromJson(artist, 0)).toList();
  }

  return artists;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 artistas con más no me gustas del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de artistas
Future<List<Artist>> getTopDislikedArtistsByUser({required String uid}) async {
  List<Artist> artists = [];

  Uri url = Uri.parse('$apiUser/$uid/top_disliked_artists');

  // Llamada a la API para obtener los 10 artistas con más dislikes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    artists =
        (data as List).map((artist) => Artist.fromJson(artist, 0)).toList();
  }

  return artists;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 artistas con más swipes del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de artistas
Future<List<Artist>> getTopSwipedArtistsByUser({required String uid}) async {
  List<Artist> artists = [];

  Uri url = Uri.parse('$apiUser/$uid/top_swipes_artists');

  // Llamada a la API para obtener los 10 artistas con más likes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    artists =
        (data as List).map((artist) => Artist.fromJson(artist, 0)).toList();
  }

  return artists;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 albumes con más me gustas del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de albumes
Future<List<Album>> getTopLikedAlbumsByUser({required String uid}) async {
  List<Album> albums = [];

  Uri url = Uri.parse('$apiUser/$uid/top_liked_albums');

  // Llamada a la API para obtener los 10 albumes con más likes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    albums = (data as List).map((album) => Album.fromJson(album)).toList();
  }

  return albums;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 albumes con más no me gustas del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de albumes
Future<List<Album>> getTopDislikedAlbumsByUser({required String uid}) async {
  List<Album> albums = [];

  Uri url = Uri.parse('$apiUser/$uid/top_disliked_albums');

  // Llamada a la API para obtener los 10 albumes con más dislikes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    albums = (data as List).map((album) => Album.fromJson(album)).toList();
  }

  return albums;
}

/// Esta función recibe el UID de un usuario y devuelve una lista de los 10 albumes con más swipes del usuario <br>
/// @param uid UID del usuario <br>
/// @returns Lista de albumes
Future<List<Album>> getTopSwipedAlbumsByUser({required String uid}) async {
  List<Album> albums = [];

  Uri url = Uri.parse('$apiUser/$uid/top_swipes_albums');

  // Llamada a la API para obtener los 10 albumes con más likes del usuario
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    albums = (data as List).map((album) => Album.fromJson(album)).toList();
  }

  return albums;
}

/// Esta función recibe el UID de un usuario y devuelve la lista de sus seguidores <br>
/// @param uid UID del usuario <br>
/// @returns Lista de usuarios
Future<List<UserApp>> getFollowersByUser({required String uid}) async {
  List<UserApp> users = [];

  Uri url = Uri.parse('$apiUser/$uid/followers');

  // Llamada a la API para obtener los seguidores
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    users = (data as List).map((user) => UserApp.fromJson(user)).toList();
  }

  return users;
}

/// Esta función recibe el UID de un usuario y devuelve la lista de sus seguidos <br>
/// @param uid UID del usuario <br>
/// @returns Lista de usuarios
Future<List<UserApp>> getFollowingByUser({required String uid}) async {
  List<UserApp> users = [];

  Uri url = Uri.parse('$apiUser/$uid/following');

  // Llamada a la API para obtener los seguidos
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    users = (data as List).map((user) => UserApp.fromJson(user)).toList();
  }

  return users;
}

/// Esta función recibe el UID de un usuario y lo elimina de la base de datos <br>
/// @param uid UID del usuario <br>
/// @returns Bool
Future<bool> deleteUser({required String uid}) async {
  Uri url = Uri.parse('$apiUser/$uid');

  // Llamada a la API para eliminar al usuario
  final response = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  return response.statusCode == 200;
}

/// Esta función recibe el UID de un usuario y reactiva su cuenta <br>
/// @param uid UID del usuario
Future<void> reactivateAccount({required String uid}) async {
  Uri url = Uri.parse('$apiUser/$uid/reactivate_account');

  // Llamada a la API para reactivar la cuenta
  await http.put(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
}

/// Esta función recibe el UID de un usuario y acepta todas sus solicitudes de amistad entrantes <br>
/// @param uid UID del usuario
Future<void> acceptAllRequests({required String uid}) async {
  print('entra');
  Uri url = Uri.parse('$apiUser/$uid/accept_all_requests');

  // Llamada a la API para reactivar la cuenta
  await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
}
