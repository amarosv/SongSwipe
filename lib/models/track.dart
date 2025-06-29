import 'package:songswipe/models/export_models.dart';

/// Clase que representa una canción y sus atributos <br>
/// @author Amaro Suárez <br>
/// @version 1.1
class Track {
  /// ID de la canción
  final int id;

  /// Booleano que indica si la canción es readable
  final bool readable;

  /// Título de la canción
  final String title;

  /// Título corto de la canción
  final String titleShort;

  /// Título version de la canción
  final String titleVersion;

  /// ISRC de la canción
  final String isrc;

  /// Link de la canción
  final String link;

  /// Link para compartir de la canción
  final String share;

  /// Duración de la canción
  final int duration;

  /// Posición de la canción en el album
  final int trackPosition;

  /// Número del disco
  final int diskNumber;

  /// Posición en el ranking de la canción
  final int rank;

  /// Fecha de lanzamiento de la canción
  final String releaseDate;

  /// Booleano que indica si la letra de la canción es explicita
  final bool explicitLyrics;

  /// Entero que indica el contenido explicito de la letra de la canción
  final int explicitContentLyrics;

  /// Entero que indica el contenido explicito de la portada de la canción
  final int explicitContentCover;

  /// Preview de 30sg de la canción
  final String preview;

  /// BPM de la canción
  final double bpm;

  /// Gain de la canción
  final double gain;

  /// Lista de los países donde está disponible la canción
  final List<String> availableCountries;

  /// Lista de contribuidores de la canción
  final List<Contributor> contributors;

  /// MD5 de la imagen de la canción
  final String md5Image;

  /// Token de la canción
  final String trackToken;

  /// Artista de la canción
  final Artist artist;

  /// Album de la canción
  final Album album;

  /// Tipo de la canción
  final String type;

  /// Valor del Swipe
  final bool like;

  /// Letras de la canción
  String lyrics;

  /// Número de likes de la canción
  int likes;

  /// Constructor de la canción
  Track(
      {required this.id,
      required this.readable,
      required this.title,
      required this.titleShort,
      required this.titleVersion,
      required this.isrc,
      required this.link,
      required this.share,
      required this.duration,
      required this.trackPosition,
      required this.diskNumber,
      required this.rank,
      required this.releaseDate,
      required this.explicitLyrics,
      required this.explicitContentLyrics,
      required this.explicitContentCover,
      required this.preview,
      required this.bpm,
      required this.gain,
      required this.availableCountries,
      required this.contributors,
      required this.md5Image,
      required this.trackToken,
      required this.artist,
      required this.album,
      required this.type,
      this.like = false,
      this.lyrics = '',
      this.likes = 0});

  /// Método que parsea un JSON en Canción
  factory Track.fromJson(Map<String, dynamic> json) => Track(
      id: json["id"] ?? 0,
      readable: json["readable"] ?? false,
      title: json["title"] ?? '',
      titleShort: json["title_short"] ?? '',
      titleVersion: json["title_version"] ?? '',
      isrc: json["isrc"] ?? '',
      link: json["link"] ?? '',
      share: json["share"] ?? '',
      duration: json["duration"] ?? 0,
      trackPosition: json["track_position"] ?? 0,
      diskNumber: json["disk_number"] ?? 0,
      rank: json["rank"] ?? 0,
      releaseDate: json["release_date"] ?? '',
      explicitLyrics: json["explicit_lyrics"] ?? false,
      explicitContentLyrics: json["explicit_content_lyrics"] ?? -1,
      explicitContentCover: json["explicit_content_cover"] ?? -1,
      preview: json["preview"] ?? '',
      bpm: (json['bpm'] is int
              ? (json['bpm'] as int).toDouble()
              : json['bpm']) ??
          0.0,
      gain: (json['gain'] is int
              ? (json['gain'] as int).toDouble()
              : json['gain']) ??
          0.0,
      availableCountries: json['available_countries'] != null
          ? List<String>.from(json['available_countries'])
          : [],
      contributors: (json['contributors'] as List<dynamic>?)
              ?.map(
                  (item) => Contributor.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      md5Image: json["md5_image"] != null
          ? 'https://e-cdn-images.dzcdn.net/images/cover/${json['md5_image']}/500x500.jpg'
          : '',
      trackToken: json["track_token"] ?? '',
      artist: json['artist'] != null
          ? Artist.fromJson(json['artist'], 0)
          : Artist.empty(),
      album:
          json['album'] != null ? Album.fromJson(json['album']) : Album.empty(),
      type: json["type"] ?? '',
      like: json["like"] ?? false,
      lyrics: json["lyrics"] ?? '',
      likes: json['likes'] ?? 0);

  /// Método que crea una canción vacía
  factory Track.empty() {
    return Track(
        id: 0,
        readable: false,
        title: '',
        titleShort: '',
        titleVersion: '',
        isrc: '',
        link: '',
        share: '',
        duration: 0,
        trackPosition: 0,
        diskNumber: 0,
        rank: 0,
        releaseDate: '',
        explicitLyrics: false,
        explicitContentLyrics: 0,
        explicitContentCover: 0,
        preview: '',
        bpm: 0,
        gain: 0,
        availableCountries: [],
        contributors: [],
        md5Image: '',
        trackToken: '',
        artist: Artist.empty(),
        album: Album.empty(),
        type: '',
        like: false,
        lyrics: '',
        likes: 0);
  }

  /// Función que construye la cadena de artistas y contribuidores de la canción <br>
  /// @returns Cadena de artistas y contribuidores
  String buildArtistsText() {
    final names = <String>{};
    names.add(artist.name);
    for (final contributor in contributors) {
      names.add(contributor.name);
    }
    return names.join(', ');
  }

  /// Esta función devuelve las 4 primeras líneas de las letras <br>
  /// @returns 4 primeras líneas de las letras de la canción
  String getFirstFourLyricsLines() {
    // Variable que almacena las primeras cuatro líneas
    String result = '';

    List<String> lines = lyrics.split('\n');

    for (int i = 0; i < 4; i++) {
      String line = i >= lines.length ? '' : '${lines[i]}\n';

      result += line;
    }

    return result;
  }
}
