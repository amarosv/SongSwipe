// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get email => 'email';

  @override
  String get password => 'password';

  @override
  String get confirm_password => 'conferma password';

  @override
  String get email_placeholder => 'inserisci la tua email';

  @override
  String get password_placeholder => 'inserisci la tua password';

  @override
  String get confirm_password_placeholder => 'conferma la tua password';

  @override
  String get create_account => 'creare account';

  @override
  String get or => 'o';

  @override
  String get already_have_an_account => 'hai già un account?';

  @override
  String get login => 'login';

  @override
  String get spanish => 'spagnolo';

  @override
  String get english => 'inglese';

  @override
  String get italian => 'italiano';

  @override
  String get forgot_password => 'ha dimenticato la password?';

  @override
  String get not_registered => 'non registrato?';

  @override
  String get error_password_empty => 'la password non può essere vuota';

  @override
  String get error_password_length =>
      'la password deve essere lunga 8 caratteri';

  @override
  String get error_password_capital =>
      'la password deve contenere almeno 1 lettera maiuscola';

  @override
  String get error_password_lowercase =>
      'la password deve contenere almeno 1 lettera minuscola';

  @override
  String get error_password_number =>
      'la password deve contenere almeno 1 numero';

  @override
  String get error_password_special =>
      'la password deve contenere almeno 1 carattere speciale';

  @override
  String get error_password_invalid =>
      'la password deve essere lunga 8 caratteri, deve contenere 1 maiuscola, 1 minuscola, 1 numero e 1 carattere speciale';

  @override
  String get error_passwords_match => 'le passwords non corrispondono';

  @override
  String get error_password_weak => 'la password fornita è troppo debole.';

  @override
  String get error_email_empty => 'l\'e-mail non può essere vuota';

  @override
  String get error_email_invalid => 'l\'e-mail non è valida';

  @override
  String get error_account => 'l\'account per quell\'email esiste già.';

  @override
  String get complete_profile => 'completa il tuo profilo';

  @override
  String get username => 'username';

  @override
  String get username_placeholder => 'scrive il tuo username';

  @override
  String get username_info =>
      'poui cambiare il tuo username in seguito nella pagina del tuo profilo';

  @override
  String get name => 'nome';

  @override
  String get name_placeholder => 'scrive il tuo nome';

  @override
  String get lastname => 'cognome';

  @override
  String get lastname_placeholder => 'scrive il tuo cognome';

  @override
  String get upload_your_photo => 'carica la tua foto';

  @override
  String get continue_s => 'continuare';

  @override
  String get sent_email => 'abbiamo inviato un\'e-mail a ';

  @override
  String get verify => 'per favor verificare l\'email per continuare.';

  @override
  String get resend => 'inviare nuovamente l\'email';

  @override
  String get change_email => 'cambia email';

  @override
  String get sent => 'inviato!';

  @override
  String get resent => 'abbiamo inviato un nuovo e-mail';

  @override
  String get verified => 'verificato!';

  @override
  String get verified_email => 'hai verificato la tua email';

  @override
  String get attention => 'attenzione!';

  @override
  String get fill_fields => 'si prega di compilare tutti i campi';

  @override
  String get error_account_not_exists =>
      'nessun utente trovato per quell\'email o la password è errata';

  @override
  String get error => 'si è verificato un errore';

  @override
  String get select_artists => 'seleziona almeno 5 artisti';

  @override
  String get search_artist => 'trova un artista..';

  @override
  String get done => 'fatto';

  @override
  String get select_genres => 'seleziona almeno 3 generi';

  @override
  String get search_genre => 'trova un genere...';

  @override
  String get info => 'informazione';

  @override
  String get full_name => 'nome e cognome';

  @override
  String get date_joining => 'incorporazione';

  @override
  String get saved_songs => 'canzoni salvate';

  @override
  String get followers => 'seguaci';

  @override
  String get following => 'seguente';

  @override
  String get see_fav_artists => 'vedi i miei artisti preferiti';

  @override
  String get see_fav_genres => 'vedi i miei generi preferiti';

  @override
  String get see_stats => 'vedi le mie statistiche';

  @override
  String get edit_profile => 'modifica profilo';

  @override
  String get swipes => 'swipes';

  @override
  String get profile => 'profilo';

  @override
  String get library => 'biblioteca';

  @override
  String get discover => 'scoprire';

  @override
  String get friends => 'amici';

  @override
  String get settings => 'opzioni';

  @override
  String get appearance => 'aspetto';

  @override
  String get profile_privacy => 'profilo e privacy';

  @override
  String get language => 'lingua';

  @override
  String get audio => 'audio';

  @override
  String get notifications => 'notifiche';

  @override
  String get about_songswipe => 'informazioni su SongSwipe';

  @override
  String get logout => 'logout';

  @override
  String get logout_dialog_content =>
      'sei sicuro di voler effettuare il logout?';

  @override
  String get yes => 'si';

  @override
  String get no => 'no';

  @override
  String get select_your_username => 'seleziona tuo username';

  @override
  String get stats => 'statistiche';

  @override
  String get followers_following => 'seguaci e seguente';

  @override
  String get visibility => 'visibilità';

  @override
  String get make_account_private => 'rendere l\'account privato';

  @override
  String get account_private_label =>
      'passando da privato a pubblico verranno automaticamente accettate tutte le richieste di amicizia in sospeso.';

  @override
  String get devices => 'dispositivi';

  @override
  String get delete_account => 'eliminare l\'account';

  @override
  String get who_can_see => 'chi può vederlo?';

  @override
  String get currently_private_account =>
      'al momento il tuo account è privato, modificando questa impostazione, il tuo account diventerà pubblico. sei sicuro?';

  @override
  String get play_loop => 'riprodurre la canzone in loop';

  @override
  String get autoplay => 'riproduzione automatica';

  @override
  String get only_audio => 'solo audio';

  @override
  String get label_only_audio =>
      'mostra o nascondi copertina, titolo e artista';

  @override
  String get allow_notifications => 'consentire le notifiche';

  @override
  String get new_friend_request => 'nuova richiesta di amicizia';

  @override
  String get friend_request_approved => 'richiesta di amicizia approvata';

  @override
  String get app => 'app';

  @override
  String get new_app_update => 'nuovo aggiornamento dell\'app';

  @override
  String get weekly_recap => 'riepilogo settimanale';

  @override
  String get label_weekly_recap =>
      'ti invieremo una notifica ogni domenica alle 20:00';

  @override
  String get account_blocked => 'conto bloccato';

  @override
  String get label_account_blocked =>
      'ti invieremo una notifica se blocchiamo il tuo account';

  @override
  String get info_app => 'aksajhsdhsadj';

  @override
  String get mode => 'modalità';

  @override
  String get dark => 'buio';

  @override
  String get light => 'luce';

  @override
  String get system => 'sistema';

  @override
  String get theme => 'tema';

  @override
  String get red => 'rosso';

  @override
  String get yellow => 'giallo';

  @override
  String get pink => 'rosa';

  @override
  String get cards => 'carte';

  @override
  String get animated_cover => 'copertina animata';

  @override
  String get skip_songs => 'pulsanti saltare e ritorno';

  @override
  String get blurred_as_background => 'copertina sfocata come sfondo';

  @override
  String get label_blurred_background =>
      'disabilitare questa opzione per rendere i colori di sfondo correlati alla copertina';

  @override
  String get january => 'gennaio';

  @override
  String get february => 'febbraio';

  @override
  String get march => 'marzo';

  @override
  String get april => 'aprile';

  @override
  String get may => 'maggio';

  @override
  String get june => 'giugno';

  @override
  String get july => 'luglio';

  @override
  String get august => 'agosto';

  @override
  String get september => 'settembre';

  @override
  String get october => 'ottobre';

  @override
  String get november => 'novembre';

  @override
  String get december => 'dicembre';

  @override
  String get in_ranking => 'nella classifica';

  @override
  String get save => 'salva';

  @override
  String get discard => 'escludere';

  @override
  String get skip => 'saltare';

  @override
  String get back => 'ritorno';

  @override
  String get ok => 'ok';

  @override
  String get show_tutorial => 'mostra il tutorial';

  @override
  String get search => 'cercare';

  @override
  String get requests => 'richieste';

  @override
  String get sent_requests => 'inviate';

  @override
  String get receive_requests => 'pervenute';

  @override
  String get search_friend => 'cercare un amico...';

  @override
  String get send_request => 'inviare richiesta';

  @override
  String get request_sent => 'richiesta di amicizia inviata';

  @override
  String get request_sent_not_found =>
      'non sono state trovate richieste inviate';

  @override
  String get request_receive_not_found => 'Nessuna richiesta ricevuta trovata';

  @override
  String get your_friend => 'tuo amico';

  @override
  String get see_fav_tracks => 'vedere i loro canzoni preferiti';

  @override
  String get see_their_stats => 'vedere le loro statistiche';

  @override
  String get no_last_swipes => 'nessun swipe trovato';

  @override
  String get liked => 'salvata';

  @override
  String get disliked => 'scartata';

  @override
  String get no_tracks => 'nessuna canzone trovata';

  @override
  String get showing => 'mostrando';

  @override
  String get tracks => 'canzone/i';

  @override
  String get export_tracks => 'esportare canzoni';

  @override
  String get selected_tracks => 'canzone/i selezionate';

  @override
  String get release_date => 'data di rilascio';

  @override
  String get duration => 'durata';

  @override
  String get album => 'album';

  @override
  String get position_album => 'posizione nell\'album';

  @override
  String get ranking => 'classifica';

  @override
  String get explicit_content => 'contenuto esplicito';

  @override
  String get lyrics => 'testi';

  @override
  String get by => 'di';

  @override
  String get likes => 'piace';

  @override
  String get dislikes => 'antipatie';

  @override
  String get related_tracks => 'canzoni correlate';

  @override
  String get see_more => 'vedere di più...';

  @override
  String get last_swipes => 'ultimi 5 swipes';
}
