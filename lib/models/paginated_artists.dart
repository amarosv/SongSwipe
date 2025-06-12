import 'package:songswipe/models/export_models.dart';

/// Clase que representa una página de artistas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PaginatedArtists {
  /// URL de la siguiente página
  String linkNextPage;

  /// URL de la página anterior
  dynamic linkPreviousPage;

  /// Número de la página actual
  int page;

  /// Número total de páginas
  int totalPages;

  /// Número total de artistas
  int totalArtists;

  /// Número inicial de artista
  int offset;

  /// Número final de artista
  int last;

  /// Límite de artistas que se muestran
  int limit;

  /// Lista de artistas
  List<Artist> artists;

  /// Constructor del paginatedtracks
  PaginatedArtists({
    required this.linkNextPage,
    required this.linkPreviousPage,
    required this.page,
    required this.totalPages,
    required this.totalArtists,
    required this.offset,
    required this.last,
    required this.limit,
    required this.artists,
  });
  
  /// Método que parsea un JSON en PaginatedArtist
  factory PaginatedArtists.fromJson(Map<String, dynamic> json) =>
      PaginatedArtists(
        linkNextPage: json["linkNextPage"] ?? '',
        linkPreviousPage: json["linkPreviousPage"] ?? '',
        page: json["page"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        totalArtists: json["totalTracks"] ?? 0,
        offset: json["offset"] ?? 0,
        last: json["last"] ?? 0,
        limit: json["limit"] ?? 0,
        artists: (json['artists'] as List<dynamic>?)
                ?.map((item) => Artist.fromJson(item as Map<String, dynamic>, 0))
                .toList() ?? [],
      );

  /// Método que crea un paginatedartists vacío
  factory PaginatedArtists.empty() {
    return PaginatedArtists(
      linkNextPage: '',
      linkPreviousPage: '',
      page: 0,
      totalPages: 0,
      totalArtists: 0,
      offset: 0,
      last: 0,
      limit: 0,
      artists: []
    );
  }
}
