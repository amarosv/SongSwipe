/// Clase que representa a un artista con sus atributos <br>
/// @author Amaro Suárez <br>
/// @version 1.1
class Artist {
  /// ID del artista
  final int id;
  /// Nombre del artista
  final String name;
  /// Link del artista
  final String link;
  /// Link para compartir al artista
  final String share;
  /// Imagen del artista
  final String picture;
  /// Imagen pequeña del artista
  final String pictureSmall;
  /// Imagen mediana del artista
  final String pictureMedium;
  /// Imagen grande del artista
  final String pictureBig;
  /// Imagen xl del artista
  final String pictureXL;
  /// Número de albumes del artista
  final int nbAlbum;
  /// Número de fans del artista
  final int nbFans;
  /// Booleano que indica si el artista tiene radio
  final bool radio;
  /// Tracklist del artista
  final String trackList;
  /// Número de canciones guardadas del artista
  final int savedTracks;

  /// Constructor del Artist
  Artist({
    required this.id,
    required this.name,
    required this.link,
    required this.share,
    required this.picture,
    required this.pictureSmall,
    required this.pictureMedium,
    required this.pictureBig,
    required this.pictureXL,
    required this.nbAlbum,
    required this.nbFans,
    required this.radio,
    required this.trackList,
    required this.savedTracks,
  });

  /// Método que parsea un JSON en Artist
  factory Artist.fromJson(Map<String, dynamic> json, int savedTracks) {
    return Artist(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      link: json['link'] ?? '',
      share: json['share'] ?? '',
      picture: json['picture'] ?? '',
      pictureSmall: json['picture_small'] ?? '',
      pictureMedium: json['picture_medium'] ?? '',
      pictureBig: json['picture_big'] ?? '',
      pictureXL: json['picture_xl'] ?? '',
      nbAlbum: json['nb_album'] ?? 0,
      nbFans: json['nb_fan'] ?? 0,
      radio: json['radio'] ?? false,
      trackList: json['tracklist'] ?? '',
      savedTracks: savedTracks
    );
  }

  /// Método que crea un Artist vacío
  factory Artist.empty() {
    return Artist(
      id: 0,
      name: '',
      link: '',
      share: '',
      picture: '',
      pictureSmall: '',
      pictureMedium: '',
      pictureBig: '',
      pictureXL: '',
      nbAlbum: 0,
      nbFans: 0,
      radio: false,
      trackList: '',
      savedTracks: 0
    );
  }
}