/// Clase que representa un género y sus atributos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Genre {
  /// ID del género
  final int id;
  /// Nombre del género
  final String name;
  /// Imagen del género
  final String picture;
  /// Imagen pequeña del género
  final String pictureSmall;
  /// Imagen mediana del género
  final String pictureMedium;
  /// Imagen grande del género
  final String pictureBig;
  /// Imagen xl del género
  final String pictureXL;

  Genre({
    required this.id,
    required this.name,
    required this.picture,
    required this.pictureSmall,
    required this.pictureMedium,
    required this.pictureBig,
    required this.pictureXL
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      pictureSmall: json['picture_small'] ?? '',
      pictureMedium: json['picture_medium'] ?? '',
      pictureBig: json['picture_big'] ?? '',
      pictureXL: json['picture_xl'] ?? ''
    );
  }

  factory Genre.empty() {
    return Genre(
      id: 0,
      name: '',
      picture: '',
      pictureSmall: '',
      pictureMedium: '',
      pictureBig: '',
      pictureXL: ''
    );
  }
}