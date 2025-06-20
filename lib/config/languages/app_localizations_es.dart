// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get email => 'email';

  @override
  String get password => 'contraseña';

  @override
  String get confirm_password => 'confirmar contraseña';

  @override
  String get email_placeholder => 'escribe tu email';

  @override
  String get password_placeholder => 'escribe tu contraseña';

  @override
  String get confirm_password_placeholder => 'confirma tu contraseña';

  @override
  String get create_account => 'crear cuenta';

  @override
  String get or => 'o';

  @override
  String get already_have_an_account => 'tengo una cuenta';

  @override
  String get login => 'iniciar sesión';

  @override
  String get spanish => 'español';

  @override
  String get english => 'inglés';

  @override
  String get italian => 'italiano';

  @override
  String get forgot_password => 'recuperar contraseña';

  @override
  String get not_registered => 'no tengo cuenta';

  @override
  String get error_password_empty => 'la contraseña no puede estar vacía';

  @override
  String get error_password_length =>
      'la contraseña debe tener una longitud de 8 caracteres';

  @override
  String get error_password_capital =>
      'la contraseña debe tener al menos 1 letra mayúscula';

  @override
  String get error_password_lowercase =>
      'la contraseña debe tener al menos 1 letra minúscula';

  @override
  String get error_password_number =>
      'la contraseña debe tener al menos 1 número';

  @override
  String get error_password_special =>
      'la contraseña debe tener al menos un caracter especial';

  @override
  String get error_password_invalid =>
      'la contraseña debe tener una longitud de 8 caracteres, contener 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial';

  @override
  String get error_passwords_match => 'las contraseñas no coinciden';

  @override
  String get error_password_weak =>
      'la contraseña proporcionada es demasiado débil.';

  @override
  String get error_email_empty => 'el email no puede estar vacío';

  @override
  String get error_email_invalid => 'el email no es válido';

  @override
  String get error_account =>
      'la cuenta ya existe para ese correo electrónico.';

  @override
  String get complete_profile => 'completa tu perfil';

  @override
  String get username => 'nombre de usuario';

  @override
  String get username_placeholder => 'escribe tu nombre de usuario';

  @override
  String get username_info =>
      'puedes cambiar tu nombre de usuario más tarde en la página del perfil';

  @override
  String get name => 'nombre';

  @override
  String get name_placeholder => 'escribe tu nombre';

  @override
  String get lastname => 'apellidos';

  @override
  String get lastname_placeholder => 'escribe tus apellidos';

  @override
  String get upload_your_photo => 'sube tu foto';

  @override
  String get continue_s => 'continuar';

  @override
  String get sent_email => 'hemos enviado un email a ';

  @override
  String get verify => 'por favor verifique el email para continuar.';

  @override
  String get resend => 'reenviar email';

  @override
  String get change_email => 'cambiar email';

  @override
  String get sent => 'enviado!';

  @override
  String get resent => 'te hemos enviado otro email de verificación';

  @override
  String get verified => 'verificado!';

  @override
  String get verified_email => 'has verificado tu email';

  @override
  String get attention => '¡atención!';

  @override
  String get fill_fields => 'por favor, rellena todos los campos';

  @override
  String get error_account_not_exists =>
      'no se ha encontrado un usuario para ese email o la contraseña es incorrecta';

  @override
  String get error => 'ha ocurrido un error';

  @override
  String get select_artists => 'selecciona al menos 5 artistas';

  @override
  String get search_artist => 'busca un artista...';

  @override
  String get done => 'hecho';

  @override
  String get select_genres => 'selecciona al menos 3 géneros';

  @override
  String get search_genre => 'busca un género...';

  @override
  String get info => 'información';

  @override
  String get full_name => 'nombre completo';

  @override
  String get date_joining => 'unión';

  @override
  String get saved_songs => 'canciones guardadas';

  @override
  String get followers => 'seguidores';

  @override
  String get following => 'siguiendo';

  @override
  String get see_fav_artists => 'ver mis artistas favoritos';

  @override
  String get see_fav_genres => 'ver mis géneros favoritos';

  @override
  String get see_stats => 'ver mis estadísticas';

  @override
  String get edit_profile => 'editar perfil';

  @override
  String get swipes => 'swipes';

  @override
  String get profile => 'perfil';

  @override
  String get library => 'biblioteca';

  @override
  String get discover => 'descubrir';

  @override
  String get friends => 'amigos';

  @override
  String get settings => 'ajustes';

  @override
  String get appearance => 'apariencia';

  @override
  String get profile_privacy => 'perfil y privacidad';

  @override
  String get language => 'idioma';

  @override
  String get audio => 'audio';

  @override
  String get notifications => 'notificaciones';

  @override
  String get about_songswipe => 'acerca de SongSwipe';

  @override
  String get logout => 'cerrar sesión';

  @override
  String get logout_dialog_content =>
      '¿está seguro de que desea cerrar sesión?';

  @override
  String get yes => 'sí';

  @override
  String get no => 'no';

  @override
  String get select_your_username => 'selecciona tu username';

  @override
  String get stats => 'estadísticas';

  @override
  String get followers_following => 'seguidores y siguiendo';

  @override
  String get visibility => 'visibilidad';

  @override
  String get make_account_private => 'poner cuenta como privada';

  @override
  String get account_private_label =>
      'cambiar de privado a público aceptará automáticamente todas las solicitudes de amistad pendientes.';

  @override
  String get devices => 'dispositivos';

  @override
  String get delete_account => 'eliminar cuenta';

  @override
  String get who_can_see => '¿quién puede verlo?';

  @override
  String get currently_private_account =>
      'actualmente tu cuenta es privada, cambiar este ajuste pondrá tu cuenta como pública. ¿estás seguro?';

  @override
  String get play_loop => 'reproducir canción en bucle';

  @override
  String get autoplay => 'reproducir automáticamente';

  @override
  String get only_audio => 'solo audio';

  @override
  String get label_only_audio =>
      'mostrar u ocultar la portada, el título y el artista';

  @override
  String get allow_notifications => 'permitir notificaciones';

  @override
  String get new_friend_request => 'nueva solicitud de amistad';

  @override
  String get friend_request_approved => 'solicitud de amistad aprobada';

  @override
  String get app => 'app';

  @override
  String get new_app_update => 'nueva actualización de la app';

  @override
  String get weekly_recap => 'resumen semanal';

  @override
  String get label_weekly_recap =>
      'te enviaremos una notificación todos los domingos a las 8pm.';

  @override
  String get account_blocked => 'cuenta bloqueada';

  @override
  String get label_account_blocked =>
      'te enviaremos una notificación si bloqueamos tu cuenta';

  @override
  String get mode => 'modo';

  @override
  String get dark => 'oscuro';

  @override
  String get light => 'claro';

  @override
  String get system => 'sistema';

  @override
  String get theme => 'tema';

  @override
  String get red => 'rojo';

  @override
  String get yellow => 'amarillo';

  @override
  String get pink => 'rosa';

  @override
  String get cards => 'cartas';

  @override
  String get animated_cover => 'portada animada';

  @override
  String get skip_songs => 'botones saltar y retroceder';

  @override
  String get blurred_as_background => 'portada difuminada como fondo';

  @override
  String get label_blurred_background =>
      'desactive esta opción para que los colores de fondo estén relacionados con la portada.';

  @override
  String get january => 'enero';

  @override
  String get february => 'febrero';

  @override
  String get march => 'marzo';

  @override
  String get april => 'abril';

  @override
  String get may => 'mayo';

  @override
  String get june => 'junio';

  @override
  String get july => 'julio';

  @override
  String get august => 'agosto';

  @override
  String get september => 'septiembre';

  @override
  String get october => 'octubre';

  @override
  String get november => 'noviembre';

  @override
  String get december => 'diciembre';

  @override
  String get in_ranking => 'en el ranking';

  @override
  String get save => 'guardar';

  @override
  String get discard => 'descartar';

  @override
  String get skip => 'saltar';

  @override
  String get back => 'retroceder';

  @override
  String get ok => 'ok';

  @override
  String get show_tutorial => 'mostrar tutorial';

  @override
  String get search => 'buscar';

  @override
  String get requests => 'solicitudes';

  @override
  String get sent_requests => 'enviadas';

  @override
  String get receive_requests => 'recibidas';

  @override
  String get search_friend => 'busca a un amigo...';

  @override
  String get send_request => 'enviar solicitud';

  @override
  String get request_sent => 'solicitud de amistad enviada';

  @override
  String get request_sent_not_found => 'no se encontraron solicitudes enviadas';

  @override
  String get request_receive_not_found =>
      'no se encontraron solicitudes recibidas';

  @override
  String get your_friend => 'tu amigo';

  @override
  String get see_fav_tracks => 'ver sus canciones favoritas';

  @override
  String get see_their_stats => 'ver sus estadísticas';

  @override
  String get no_last_swipes => 'no se encontraron swipes';

  @override
  String get liked => 'guardadas';

  @override
  String get disliked => 'descartadas';

  @override
  String get no_tracks => 'no se encontraron canciones';

  @override
  String get showing => 'mostrando';

  @override
  String get tracks => 'cancion/es';

  @override
  String get export_tracks => 'exportar canciones';

  @override
  String get selected_tracks => 'cancion/es seleccionadas';

  @override
  String get release_date => 'fecha de lanzamiento';

  @override
  String get duration => 'duración';

  @override
  String get album => 'álbum';

  @override
  String get position_album => 'posición en el';

  @override
  String get ranking => 'ranking';

  @override
  String get explicit_content => 'contenido explícito';

  @override
  String get lyrics => 'letras';

  @override
  String get by => 'de';

  @override
  String get likes => 'me gustas';

  @override
  String get dislikes => 'no me gustas';

  @override
  String get related_tracks => 'canciones relacionadas';

  @override
  String get see_more => 'ver más...';

  @override
  String get last_swipes => 'últimos 5 swipes';

  @override
  String get number_songs => 'número de canciones';

  @override
  String get type => 'tipo';

  @override
  String get offered_by => 'datos ofrecidos por';

  @override
  String get reset_picture => 'restablecer foto';

  @override
  String get update => 'actualizar';

  @override
  String get genre => 'género';

  @override
  String get about_songswipe_text =>
      'es una forma innovadora de descubrir música hecha a tu medida. Explora nuevas canciones deslizando entre ellas, escucha una breve muestra y decide si quieres guardarlas o descartarlas. Cada canción que te gusta se guarda en tu colección personal para que puedas volver a ella cuando quieras.\n\nAdemás, puedes conectarte con tus amigos, ver qué están escuchando y compartir tus descubrimientos musicales. Cuando encuentres una canción que te encante, tendrás la opción de transferirla fácilmente a tu servicio de música habitual.\nDescubre, conecta y disfruta la música como nunca antes.';

  @override
  String get most_liked_tracks => 'canciones con más me gustas';

  @override
  String get most_liked_albums => 'albumes con más me gustas';

  @override
  String get see_top_tracks => 'ver canciones top';

  @override
  String get see_all_albums => 'ver todos los albumes';

  @override
  String get related_artists => 'artistas similares';

  @override
  String get of_txt => 'de';

  @override
  String get tracks_exported => 'canciones exportadas';

  @override
  String get tracks_succes_export => 'canciones exportadas correctamente';

  @override
  String get as => 'como';

  @override
  String get export_to => 'exportar a';

  @override
  String get cant_export => 'no se pudieron exportar';

  @override
  String get playlist_description => 'canciones exportadas de SongSwipe';

  @override
  String get cant_select => 'no puedes seleccionar más de';

  @override
  String get plural_tracks => 'canciones';

  @override
  String get no_more_tracks_discover => '¡no hay más canciones por descubrir!';

  @override
  String get my_stats => 'mis estadísticas';

  @override
  String get their_stats => 'sus estadísticas';

  @override
  String get top_liked_artists => 'top 10 artistas que más te gustan';

  @override
  String get top_disliked_artists => 'top 10 artistas que menos te gustan';

  @override
  String get top_swiped_artists => 'top 10 artistas que más has swipeado';

  @override
  String get top_liked_albums => 'top 10 albums que más te gustan';

  @override
  String get top_disliked_albums => 'top 10 albums que menos te gustan';

  @override
  String get top_swiped_albums => 'top 10 albums que más has swipeado';

  @override
  String get top_liked_artists_by => 'top 10 artistas que más le gustan';

  @override
  String get top_disliked_artists_by => 'top 10 artistas que menos le gustan';

  @override
  String get top_swiped_artists_by => 'top 10 artistas que más ha swipeado';

  @override
  String get top_liked_albums_by => 'top 10 albums que más le gustan';

  @override
  String get top_disliked_albums_by => 'top 10 albums que menos le gustan';

  @override
  String get top_swiped_albums_by => 'top 10 albums que más ha swipeado';

  @override
  String get my_followers => 'mis seguidores';

  @override
  String get my_following => 'mis seguidos';

  @override
  String get their_followers => 'sus seguidores';

  @override
  String get their_following => 'sus seguidos';

  @override
  String get their_fav_tracks => 'sus canciones favoritas';

  @override
  String get email_reset_sent =>
      'correo para restablecer la contraseña enviado';

  @override
  String get login_abort => 'inicio de sesión cancelado.';

  @override
  String get select_one_track => 'selecciona al menos una canción';

  @override
  String get top_tracks => 'top canciones';

  @override
  String get all_albums => 'todos los albumes';

  @override
  String get confirm_delete_account_warning =>
      '¿Seguro que quieres eliminar tu cuenta?';

  @override
  String get delete_account_irreversible =>
      'esta acción eliminará permanentemente tu cuenta y todos tus datos. ¿Deseas continuar?';

  @override
  String get account_deleted_success =>
      'su cuenta ha sido eliminada exitosamente';

  @override
  String get warning => '¡¡¡peligro!!!';

  @override
  String get cancel => 'cancelar';

  @override
  String get reactivated_account => 'cuenta reactivada';

  @override
  String get nothing_to_show => 'nada para mostrar';

  @override
  String get my_artists => 'mis artistas';

  @override
  String get my_genres => 'mis géneros';

  @override
  String get must_have_artists =>
      'debes tener al menos 5 artistas como favoritos';

  @override
  String get must_have_genres =>
      'debes tener al menos 3 géneros como favoritos';

  @override
  String get search_artists_title => 'buscar artistas';

  @override
  String get search_genres_title => 'buscar géneros';

  @override
  String get add => 'añadir';

  @override
  String get email_not_exist => 'no se encontró ningún usuario con ese email';
}
