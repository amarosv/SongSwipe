import 'package:songswipe/models/export_models.dart';

/// Clase que representa una página de albums <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PaginatedAlbum {
  /// Lista de albums
  List<Album> albums;

  /// Total de canciones
  int total;

  /// URL a la página siguiente
  String next;

  /// Constructor
  PaginatedAlbum({
    required this.albums,
    required this.total,
    required this.next,
  });

  /// Método que crea un PaginatedAlbum vacío
  factory PaginatedAlbum.empty() {
    return PaginatedAlbum(albums: [], total: 0, next: '');
  }

  /// Método que parsea un JSON en PaginatedAlbum
  factory PaginatedAlbum.fromJson(Map<String, dynamic> json) => PaginatedAlbum(
        albums: (json['data'] as List<dynamic>?)
                ?.map((item) => Album.fromJson(item as Map<String, dynamic>))
                .toList() ?? [],
        total: json["total"] ?? 0,
        next: json["next"] ?? '',
      );
}
