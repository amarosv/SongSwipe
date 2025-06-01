/// Clase que representa unas stats <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class Stats {
  /// Likes
  int likes;
  /// Dislikes
  int dislikes;
  /// Swipes
  int swipes;

  /// Constructor de stats
  Stats({
    required this.likes,
    required this.dislikes,
    required this.swipes,
  });

  /// Método que parsea un JSON en Stats
  factory Stats.fromJson(Map<String, dynamic> json) =>
      Stats(
        likes: json["likes"] ?? 0,
        dislikes: json["dislikes"] ?? 0,
        swipes: json["swipes"] ?? 0,
      );

  /// Método que crea Stats vacío
  factory Stats.empty() {
    return Stats(
      likes: 0,
      dislikes: 0,
      swipes: 0
    );
  }

  /// Método que convierte Stats en un JSON
  Map<String, dynamic> toJson() => {
        "likes": likes,
        "dislikes": dislikes,
        "swipes": swipes,
      };
}
