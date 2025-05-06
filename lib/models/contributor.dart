import 'package:songswipe/models/export_models.dart';

/// Clase que representa a un contribuidor con sus atributos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Contributor extends Artist {
  /// Tipo del contribuidor
  final String type;

  /// Rol del contribuidor
  final String role;

  /// Constructor del Contributor
  Contributor({
    required super.id,
    required super.name,
    required super.link,
    required super.share,
    required super.picture,
    required super.pictureSmall,
    required super.pictureMedium,
    required super.pictureBig,
    required super.pictureXL,
    required super.radio,
    required super.trackList,
    required super.nbAlbum,
    required super.nbFans,
    required super.savedTracks,
    required this.role,
    required this.type,
  });

  /// Método que parsea un JSON en Contributor
  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
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
        savedTracks: 0,
        role: json['role'] ?? '',
        type: json['type'] ?? '');
  }

  /// Método que crea un Contributor vacío
  factory Contributor.empty() {
    return Contributor(
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
        savedTracks: 0,
        role: '',
        type: '');
  }
}
