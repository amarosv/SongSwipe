import 'package:songswipe/models/export_models.dart';

/// Clase que representa una página de géneros <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PaginatedGenres {
  /// URL de la siguiente página
  String linkNextPage;

  /// URL de la página anterior
  dynamic linkPreviousPage;

  /// Número de la página actual
  int page;

  /// Número total de páginas
  int totalPages;

  /// Número total de géneros
  int totalGenres;

  /// Número inicial de géneros
  int offset;

  /// Número final de géneros
  int last;

  /// Límite de géneros que se muestran
  int limit;

  /// Lista de géneros
  List<Genre> genres;

  /// Constructor del paginatedtracks
  PaginatedGenres({
    required this.linkNextPage,
    required this.linkPreviousPage,
    required this.page,
    required this.totalPages,
    required this.totalGenres,
    required this.offset,
    required this.last,
    required this.limit,
    required this.genres,
  });
  
  /// Método que parsea un JSON en PaginatedArtist
  factory PaginatedGenres.fromJson(Map<String, dynamic> json) =>
      PaginatedGenres(
        linkNextPage: json["linkNextPage"] ?? '',
        linkPreviousPage: json["linkPreviousPage"] ?? '',
        page: json["page"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        totalGenres: json["totalTracks"] ?? 0,
        offset: json["offset"] ?? 0,
        last: json["last"] ?? 0,
        limit: json["limit"] ?? 0,
        genres: (json['genres'] as List<dynamic>?)
                ?.map((item) => Genre.fromJson(item as Map<String, dynamic>))
                .toList() ?? [],
      );

  /// Método que crea un paginatedartists vacío
  factory PaginatedGenres.empty() {
    return PaginatedGenres(
      linkNextPage: '',
      linkPreviousPage: '',
      page: 0,
      totalPages: 0,
      totalGenres: 0,
      offset: 0,
      last: 0,
      limit: 0,
      genres: []
    );
  }
}
