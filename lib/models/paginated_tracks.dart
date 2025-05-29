import 'package:songswipe/models/export_models.dart';

/// Clase que representa una página de canciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class PaginatedTracks {
  /// URL de la siguiente página
  String linkNextPage;

  /// URL de la página anterior
  dynamic linkPreviousPage;

  /// Número de la página actual
  int page;

  /// Número total de páginas
  int totalPages;

  /// Número total de canciones
  int totalTracks;

  /// Número inicial de canción
  int offset;

  /// Número final de canción
  int last;

  /// Límite de canciones que se muestran
  int limit;

  /// Lista de canciones
  List<Track> tracks;

  /// Constructor del paginatedtracks
  PaginatedTracks({
    required this.linkNextPage,
    required this.linkPreviousPage,
    required this.page,
    required this.totalPages,
    required this.totalTracks,
    required this.offset,
    required this.last,
    required this.limit,
    required this.tracks,
  });
  
  /// Método que parsea un JSON en PaginatedTracks
  factory PaginatedTracks.fromJson(Map<String, dynamic> json) =>
      PaginatedTracks(
        linkNextPage: json["linkNextPage"] ?? '',
        linkPreviousPage: json["linkPreviousPage"] ?? '',
        page: json["page"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        totalTracks: json["totalTracks"] ?? 0,
        offset: json["offset"] ?? 0,
        last: json["last"] ?? 0,
        limit: json["limit"] ?? 0,
        tracks: (json['tracks'] as List<dynamic>?)
                ?.map((item) => Track.fromJson(item as Map<String, dynamic>))
                .toList() ?? [],
      );

  /// Método que crea un paginatedtracks vacío
  factory PaginatedTracks.empty() {
    return PaginatedTracks(
      linkNextPage: '',
      linkPreviousPage: '',
      page: 0,
      totalPages: 0,
      totalTracks: 0,
      offset: 0,
      last: 0,
      limit: 0,
      tracks: []
    );
  }
}
