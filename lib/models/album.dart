import 'package:songswipe/models/export_models.dart';

/// Clase que representa un album y sus atributos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Album {
  /// ID del album
  final int id;

  /// Título del album
  final String title;

  /// UPC del album
  final String upc;

  /// Link del album
  final String link;

  /// Link para compartir el album
  final String share;

  /// Portada del album
  final String cover;

  /// Portada pequeña del album
  final String coverSmall;

  /// Portada mediana del album
  final String coverMedium;

  /// Portada grande del album
  final String coverBig;

  /// Portada xl del album
  final String coverXl;

  /// Imagen MD5 del album
  final String md5Image;

  /// ID del género del album
  final int genreId;

  /// Lista de géneros del album
  final List<Genre> genres;

  /// Etiqueta del album
  final String label;

  /// Número de canciones del album
  final int nbTracks;

  /// Duración del album
  final int duration;

  /// Número de fans del album
  final int fans;

  /// Fecha de lanzamiento del album
  final String releaseDate;

  /// Tipo de grabación
  final String recordType;

  /// Booleano que indica si el album está disponible
  final bool available;

  /// Enlace del tracklist del album
  final String tracklist;

  /// Booleano que indica si las letras del album son explicitas
  final bool explicitLyrics;

  /// Entero que indica el contenido explicito de la letra de la canción
  final int explicitContentLyrics;

  /// Entero que indica el contenido explicito de la portada de la canción
  final int explicitContentCover;

  /// Lista de contribuidores del album
  final List<Contributor> contributors;

  /// Artista del album
  final Artist artist;

  /// Tipo del album
  final String type;

  /// Lista de canciones del album
  final List<Track> tracks;

  /// Constructor del album
  Album({
    required this.id,
    required this.title,
    required this.upc,
    required this.link,
    required this.share,
    required this.cover,
    required this.coverSmall,
    required this.coverMedium,
    required this.coverBig,
    required this.coverXl,
    required this.md5Image,
    required this.genreId,
    required this.genres,
    required this.label,
    required this.nbTracks,
    required this.duration,
    required this.fans,
    required this.releaseDate,
    required this.recordType,
    required this.available,
    required this.tracklist,
    required this.explicitLyrics,
    required this.explicitContentLyrics,
    required this.explicitContentCover,
    required this.contributors,
    required this.artist,
    required this.type,
    required this.tracks,
  });

  /// Método que parsea un JSON en Album
  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        upc: json["upc"] ?? '',
        link: json["link"] ?? '',
        share: json["share"] ?? '',
        cover: json["cover"] ?? '',
        coverSmall: json["cover_small"] ?? '',
        coverMedium: json["cover_medium"] ?? '',
        coverBig: json["cover_big"] ?? '',
        coverXl: json["cover_xl"] ?? '',
        md5Image: json["md5_image"] ?? '',
        genreId: json["genre_id"] ?? 0,
        genres: (json['genres']?['data'] as List<dynamic>?)
                ?.map((item) => Genre.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        label: json["label"] ?? '',
        nbTracks: json["nb_tracks"] ?? 0,
        duration: json["duration"] ?? 0,
        fans: json["fans"] ?? 0,
        releaseDate: json["release_date"] ?? '',
        recordType: json["record_type"] ?? '',
        available: json["available"] ?? false,
        tracklist: json["tracklist"] ?? '',
        explicitLyrics: json["explicit_lyrics"] ?? false,
        explicitContentLyrics: json["explicit_content_lyrics"] ?? -1,
        explicitContentCover: json["explicit_content_cover"] ?? -1,
        contributors: (json['contributors'] as List<dynamic>?)
                ?.map((item) =>
                    Contributor.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        artist: json['artist'] != null
            ? Artist.fromJson(json['artist'] as Map<String, dynamic>, 0)
            : Artist.empty(),
        type: json["type"] ?? '',
        tracks: (json['tracks']?['data'] as List<dynamic>?)
                ?.map((item) => Track.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
      );

  /// Método que crea un album vacío
  factory Album.empty() {
    return Album(
        id: 0,
        title: '',
        upc: '',
        link: '',
        share: '',
        cover: '',
        coverSmall: '',
        coverMedium: '',
        coverBig: '',
        coverXl: '',
        md5Image: '',
        genreId: 0,
        genres: [],
        label: '',
        nbTracks: 0,
        duration: 0,
        fans: 0,
        releaseDate: '',
        recordType: '',
        available: false,
        tracklist: '',
        explicitLyrics: false,
        explicitContentLyrics: 0,
        explicitContentCover: 0,
        contributors: [],
        artist: Artist.empty(),
        type: '',
        tracks: []);
  }
}
