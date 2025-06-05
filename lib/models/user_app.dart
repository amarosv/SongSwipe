/// Clase que representa a un usuario de la app <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserApp {
  /// UID del usuario
  final String uid;

  /// Nombre del usuario
  String name;

  /// Apellidos del usuario
  String lastName;

  /// Email del usuario
  final String email;

  /// Url de la imagen del usuario
  String photoUrl;

  /// Fecha de unión del usuario
  final String dateJoining;

  /// Nombre de usuario
  String username;

  /// Proovedor del usuario
  final String supplier;

  /// Boolean que indica si el usuario está eliminado
  final bool userDeleted;

  /// Boolean que indica si el usuario tiene la cuenta bloqueada
  final bool userBlocked;

  /// Constructor del UserApp
  UserApp({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.photoUrl,
    required this.dateJoining,
    required this.username,
    required this.supplier,
    required this.userDeleted,
    required this.userBlocked,
  });

  /// Método que crea un UserApp vacío
  factory UserApp.empty() {
    return UserApp(
        uid: '',
        name: '',
        lastName: '',
        email: '',
        photoUrl: '',
        dateJoining: '',
        username: '',
        supplier: '',
        userDeleted: false,
        userBlocked: false);
  }

  /// Método que parsea un JSON en UserApp
  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
        uid: json["uid"] ?? '',
        name: json["name"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        photoUrl: json["photoURL"] ?? '',
        dateJoining: json["dateJoining"] ?? '',
        username: json["username"] ?? '',
        supplier: json["supplier"] ?? '',
        userDeleted: json["userDeleted"] ?? false,
        userBlocked: json["userBlocked"] ?? false,
      );

  /// Método que convierte un UserApp en JSON
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "lastName": lastName,
        "email": email,
        "photoURL": photoUrl,
        "dateJoining": dateJoining,
        "username": username,
        "supplier": supplier,
        "userDeleted": userDeleted,
        "userBlocked": userBlocked,
      };
}
