/// Clase que representa un swipe de una canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Swipe {
  /// ID de la canción
  final int id;

  /// ID del album
  final int idAlbum;

  /// Like 1 o dislike 0
  final int like;

  /// Constructor del Swipe
  Swipe({
    required this.id,
    required this.idAlbum,
    required this.like
  });

  /// Método que parsea un JSON en Swipe
  factory Swipe.fromJson(Map<String, dynamic> json) {
    return Swipe(
      id: json['id'] ?? 0,
      idAlbum: json['idAlbum'] ?? 0,
      like: json['like'] ?? 0
    );
  }

  /// Método que crea un Swipe vacío
  factory Swipe.empty() {
    return Swipe(
      id: 0,
      idAlbum: 0,
      like: 0
    );
  }

  /// Método que convierte el Swipe en JSON
  Map<String, dynamic> toJson() => {
    "like": like,
    "id": id,
    "idAlbum": idAlbum
  };
}