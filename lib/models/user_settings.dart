import 'package:equatable/equatable.dart';

/// Clase que representa los ajustes de un usuario y sus propiedades
/// de perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserSettings extends Equatable {
  /// Modo de la aplicación
  int mode;

  /// Tema de la aplicación
  int theme;

  /// Portada animada para la carta
  bool cardAnimatedCover;

  /// Poder saltar canciones
  bool cardSkipSongs;

  /// Fondo blur de la portada de la canción
  bool cardBlurredCoverAsBackground;

  /// Privacidad de las canciones guardadas
  int privacyVisSavedSongs;

  /// Privacidad de las estadísticas
  int privacyVisStats;

  /// Privacidad de los seguidores y seguidos
  int privacyVisFol;

  /// Cuenta privada
  bool privateAccount;

  /// Lenguaje de la aplicación
  String language;

  /// Audio de la canción en loop
  bool audioLoop;

  /// Auto play en la canción
  bool audioAutoPlay;

  /// Mostrar solo audio
  bool audioOnlyAudio;

  /// Recibir notificaciones
  bool notifications;

  /// Recibir notificaciones de las solicitudes de amistad
  bool notiFriendsRequest;

  /// Recibir notificaciones de las solicitudes aprobadas
  bool notiFriendsApproved;

  /// Recibir notificaciones de las actualizaciones de la app
  bool notiAppUpdate;

  /// Recibir notificaciones de los recap semanales
  bool notiAppRecap;

  /// Recibir notificaciones de bloqueo de la cuenta
  bool notiAccountBlocked;

  /// Mostrar tutorial de Swipe
  bool showTutorial;

  /// Constructor de los ajustes del usuario
  UserSettings({
    required this.mode,
    required this.theme,
    required this.cardAnimatedCover,
    required this.cardSkipSongs,
    required this.cardBlurredCoverAsBackground,
    required this.privacyVisSavedSongs,
    required this.privacyVisStats,
    required this.privacyVisFol,
    required this.privateAccount,
    required this.language,
    required this.audioLoop,
    required this.audioAutoPlay,
    required this.audioOnlyAudio,
    required this.notifications,
    required this.notiFriendsRequest,
    required this.notiFriendsApproved,
    required this.notiAppUpdate,
    required this.notiAppRecap,
    required this.notiAccountBlocked,
    required this.showTutorial,
  });

  /// Método que parsea un JSON a UserSettings
  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        mode: json["mode"],
        theme: json["theme"],
        cardAnimatedCover: json["cardAnimatedCover"],
        cardSkipSongs: json["cardSkipSongs"],
        cardBlurredCoverAsBackground: json["cardBlurredCoverAsBackground"],
        privacyVisSavedSongs: json["privacyVisSavedSongs"],
        privacyVisStats: json["privacyVisStats"],
        privacyVisFol: json["privacyVisFol"],
        privateAccount: json["privateAccount"],
        language: json["language"]?.toString() ?? 'en',
        audioLoop: json["audioLoop"],
        audioAutoPlay: json["audioAutoPlay"],
        audioOnlyAudio: json["audioOnlyAudio"],
        notifications: json["notifications"],
        notiFriendsRequest: json["notiFriendsRequest"],
        notiFriendsApproved: json["notiFriendsApproved"],
        notiAppUpdate: json["notiAppUpdate"],
        notiAppRecap: json["notiAppRecap"],
        notiAccountBlocked: json["notiAccountBlocked"],
        showTutorial: json["showTutorial"],
      );

  /// Método que crea un UserSettings vacío
  factory UserSettings.empty() {
    return UserSettings(
        mode: 0,
        theme: 0,
        cardAnimatedCover: false,
        cardSkipSongs: false,
        cardBlurredCoverAsBackground: false,
        privacyVisSavedSongs: 0,
        privacyVisStats: 0,
        privacyVisFol: 0,
        privateAccount: false,
        language: '',
        audioLoop: false,
        audioAutoPlay: false,
        audioOnlyAudio: false,
        notifications: false,
        notiFriendsRequest: false,
        notiFriendsApproved: false,
        notiAppUpdate: false,
        notiAppRecap: false,
        notiAccountBlocked: false,
        showTutorial: false);
  }

  /// Método que convierte el UserSettings en JSON
  Map<String, dynamic> toJson() => {
        "mode": mode,
        "theme": theme,
        "cardAnimatedCover": cardAnimatedCover,
        "cardSkipSongs": cardSkipSongs,
        "cardBlurredCoverAsBackground": cardBlurredCoverAsBackground,
        "privacyVisSavedSongs": privacyVisSavedSongs,
        "privacyVisStats": privacyVisStats,
        "privacyVisFol": privacyVisFol,
        "privateAccount": privateAccount,
        "language": language,
        "audioLoop": audioLoop,
        "audioAutoPlay": audioAutoPlay,
        "audioOnlyAudio": audioOnlyAudio,
        "notifications": notifications,
        "notiFriendsRequest": notiFriendsRequest,
        "notiFriendsApproved": notiFriendsApproved,
        "notiAppUpdate": notiAppUpdate,
        "notiAppRecap": notiAppRecap,
        "notiAccountBlocked": notiAccountBlocked,
        "showTutorial": showTutorial,
      };

  UserSettings copy() => UserSettings(
        mode: mode,
        theme: theme,
        cardAnimatedCover: cardAnimatedCover,
        cardSkipSongs: cardSkipSongs,
        cardBlurredCoverAsBackground: cardBlurredCoverAsBackground,
        privacyVisSavedSongs: privacyVisSavedSongs,
        privacyVisStats: privacyVisStats,
        privacyVisFol: privacyVisFol,
        privateAccount: privateAccount,
        language: language,
        audioLoop: audioLoop,
        audioAutoPlay: audioAutoPlay,
        audioOnlyAudio: audioOnlyAudio,
        notifications: notifications,
        notiFriendsRequest: notiFriendsRequest,
        notiFriendsApproved: notiFriendsApproved,
        notiAppUpdate: notiAppUpdate,
        notiAppRecap: notiAppRecap,
        notiAccountBlocked: notiAccountBlocked,
        showTutorial: showTutorial
      );

  @override
  List<Object?> get props => [
        mode,
        theme,
        cardAnimatedCover,
        cardSkipSongs,
        cardBlurredCoverAsBackground,
        privacyVisSavedSongs,
        privacyVisStats,
        privacyVisFol,
        privateAccount,
        language,
        audioLoop,
        audioAutoPlay,
        audioOnlyAudio,
        notifications,
        notiFriendsRequest,
        notiFriendsApproved,
        notiAppUpdate,
        notiAppRecap,
        notiAccountBlocked,
        showTutorial
      ];
}
