/// Clase que representa los ajustes de un usuario y sus propiedades
/// de perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class UserSettings {
    final int mode;
    final int theme;
    final bool cardAnimatedCover;
    final bool cardSkipSongs;
    final bool cardBlurredCoverAsBackground;
    final int privacyVisSavedSongs;
    final int privacyVisStats;
    final int privacyVisFol;
    final bool privateAccount;
    final String language;
    final bool audioLoop;
    final bool audioAutoPlay;
    final bool audioOnlyAudio;
    final bool notifications;
    final bool notiFriendsRequest;
    final bool notiFriendsApproved;
    final bool notiAppUpdate;
    final bool notiAppRecap;
    final bool notiAccountBlocked;

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
    });

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
        language: json["language"],
        audioLoop: json["audioLoop"],
        audioAutoPlay: json["audioAutoPlay"],
        audioOnlyAudio: json["audioOnlyAudio"],
        notifications: json["notifications"],
        notiFriendsRequest: json["notiFriendsRequest"],
        notiFriendsApproved: json["notiFriendsApproved"],
        notiAppUpdate: json["notiAppUpdate"],
        notiAppRecap: json["notiAppRecap"],
        notiAccountBlocked: json["notiAccountBlocked"],
    );

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
        notiAccountBlocked: false
      );
    }

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
    };
}