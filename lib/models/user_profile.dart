/// Clase que representa a un usuario y sus datos a mostrar en la pantalla
/// de perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserProfile {
    /// UID del usuario
    final String uid;
    /// Nombre de usuario del usuario
    final String username;
    /// Nombre del usuario
    final String name;
    /// Apellidos del usuario
    final String lastName;
    /// URL de la foto del usuario
    final String photoUrl;
    /// Fecha de unión del usuario
    final String dateJoining;
    /// Email del usuario
    final String email;
    /// Número de swipes del usuario
    final int swipes;
    /// Número de seguidores del usuario
    final int followers;
    /// Número de seguidos del usuario
    final int following;

    /// Constructor del UserProfile
    UserProfile({
        required this.uid,
        required this.username,
        required this.name,
        required this.lastName,
        required this.photoUrl,
        required this.dateJoining,
        required this.email,
        required this.swipes,
        required this.followers,
        required this.following,
    });

    /// Método que parsea un JSON a UserProfile
    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        uid: json["uid"],
        username: json["username"],
        name: json["name"],
        lastName: json["lastName"],
        photoUrl: json["photoUrl"],
        dateJoining: json["dateJoining"],
        email: json["email"],
        swipes: json["swipes"],
        followers: json["followers"],
        following: json["following"],
    );

    /// Método que convierte el UserProfile en JSON
    Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "name": name,
        "lastName": lastName,
        "photoUrl": photoUrl,
        "dateJoining": dateJoining,
        "email": email,
        "swipes": swipes,
        "followers": followers,
        "following": following,
    };

    /// Método que crea un UserProfile vacío
    factory UserProfile.empty() {
      return UserProfile(
        uid: '',
        username: '',
        name: '',
        lastName: '',
        photoUrl: '',
        dateJoining: '',
        email: '',
        swipes: 0,
        followers: 0,
        following: 0
      );
    }
}