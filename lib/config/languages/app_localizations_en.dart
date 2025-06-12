// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'email';

  @override
  String get password => 'password';

  @override
  String get confirm_password => 'confirm password';

  @override
  String get email_placeholder => 'enter your email';

  @override
  String get password_placeholder => 'enter your password';

  @override
  String get confirm_password_placeholder => 'confirm your password';

  @override
  String get create_account => 'create account';

  @override
  String get or => 'or';

  @override
  String get already_have_an_account => 'already have an account?';

  @override
  String get login => 'login';

  @override
  String get spanish => 'spanish';

  @override
  String get english => 'english';

  @override
  String get italian => 'italian';

  @override
  String get forgot_password => 'forgot password?';

  @override
  String get not_registered => 'not registered?';

  @override
  String get error_password_empty => 'password can\'t be empty';

  @override
  String get error_password_length => 'password must be 8 characters long';

  @override
  String get error_password_capital =>
      'password must contain at least 1 capital letter';

  @override
  String get error_password_lowercase =>
      'password must contain at least 1 lowercase letter';

  @override
  String get error_password_number => 'password must contain at least 1 number';

  @override
  String get error_password_special =>
      'password must contain at least 1 special character';

  @override
  String get error_password_invalid =>
      'password must be 8 characters long, must contain 1 capital letter, 1 lowercase letter, 1 number and 1 special character';

  @override
  String get error_passwords_match => 'passwords don\'t match';

  @override
  String get error_password_weak => 'the password provided is too weak.';

  @override
  String get error_email_empty => 'email can\'t be empty';

  @override
  String get error_email_invalid => 'email isn\'t valid';

  @override
  String get error_account => 'the account already exists for that email.';

  @override
  String get complete_profile => 'complete your profile';

  @override
  String get username => 'username';

  @override
  String get username_placeholder => 'enter your username';

  @override
  String get username_info =>
      'you can change your username later on the profile page.';

  @override
  String get name => 'name';

  @override
  String get name_placeholder => 'enter your name';

  @override
  String get lastname => 'last name';

  @override
  String get lastname_placeholder => 'enter your last name';

  @override
  String get upload_your_photo => 'upload your photo';

  @override
  String get continue_s => 'continue';

  @override
  String get sent_email => 'we\'ve sent an email to ';

  @override
  String get verify => 'please verify the email to continue.';

  @override
  String get resend => 'resend email';

  @override
  String get change_email => 'change email';

  @override
  String get sent => 'sent!';

  @override
  String get resent => 'we\'ve sent you another email';

  @override
  String get verified => 'verified!';

  @override
  String get verified_email => 'you have verified your email';

  @override
  String get attention => 'attention!';

  @override
  String get fill_fields => 'please fill in all fields';

  @override
  String get error_account_not_exists =>
      'no user found for that email or password is wrong';

  @override
  String get error => 'an error has occurred';

  @override
  String get select_artists => 'select at least 5 artists';

  @override
  String get search_artist => 'search an artist...';

  @override
  String get done => 'done';

  @override
  String get select_genres => 'select at least 3 genres';

  @override
  String get search_genre => 'search an genre...';

  @override
  String get info => 'information';

  @override
  String get full_name => 'full name';

  @override
  String get date_joining => 'joined';

  @override
  String get saved_songs => 'saved songs';

  @override
  String get followers => 'followers';

  @override
  String get following => 'following';

  @override
  String get see_fav_artists => 'see my favorite artists';

  @override
  String get see_fav_genres => 'see my favorite genres';

  @override
  String get see_stats => 'see my stats';

  @override
  String get edit_profile => 'edit profile';

  @override
  String get swipes => 'swipes';

  @override
  String get profile => 'profile';

  @override
  String get library => 'library';

  @override
  String get discover => 'discover';

  @override
  String get friends => 'friends';

  @override
  String get settings => 'settings';

  @override
  String get appearance => 'appearance';

  @override
  String get profile_privacy => 'profile and privacy';

  @override
  String get language => 'language';

  @override
  String get audio => 'audio';

  @override
  String get notifications => 'notifications';

  @override
  String get about_songswipe => 'about SongSwipe';

  @override
  String get logout => 'log out';

  @override
  String get logout_dialog_content => 'are you sure you want to log out?';

  @override
  String get yes => 'yes';

  @override
  String get no => 'no';

  @override
  String get select_your_username => 'select your username';

  @override
  String get stats => 'stats';

  @override
  String get followers_following => 'followers and following';

  @override
  String get visibility => 'visibility';

  @override
  String get make_account_private => 'make account private';

  @override
  String get account_private_label =>
      'switching from private to public will automatically accept all pending friend requests.';

  @override
  String get devices => 'devices';

  @override
  String get delete_account => 'delete account';

  @override
  String get who_can_see => 'who can see it?';

  @override
  String get currently_private_account =>
      'your account is currently private, changing this setting will make your account public. are you sure?';

  @override
  String get play_loop => 'play song in loop';

  @override
  String get autoplay => 'autoplay';

  @override
  String get only_audio => 'only audio';

  @override
  String get label_only_audio => 'show or hide cover art, title and artist';

  @override
  String get allow_notifications => 'allow notifications';

  @override
  String get new_friend_request => 'new friend request';

  @override
  String get friend_request_approved => 'friend request approved';

  @override
  String get app => 'app';

  @override
  String get new_app_update => 'new app update';

  @override
  String get weekly_recap => 'weekly recap';

  @override
  String get label_weekly_recap =>
      'we will send you a notification every sunday at 8pm';

  @override
  String get account_blocked => 'account blocked';

  @override
  String get label_account_blocked =>
      'we will send you a notification if we block your account';

  @override
  String get mode => 'mode';

  @override
  String get dark => 'dark';

  @override
  String get light => 'light';

  @override
  String get system => 'system';

  @override
  String get theme => 'theme';

  @override
  String get red => 'red';

  @override
  String get yellow => 'yellow';

  @override
  String get pink => 'pink';

  @override
  String get cards => 'cards';

  @override
  String get animated_cover => 'animated cover';

  @override
  String get skip_songs => 'buttons skip and back';

  @override
  String get blurred_as_background => 'blurred cover as background';

  @override
  String get label_blurred_background =>
      'disable this option to make the background colors related to the cover';

  @override
  String get january => 'january';

  @override
  String get february => 'february';

  @override
  String get march => 'march';

  @override
  String get april => 'april';

  @override
  String get may => 'may';

  @override
  String get june => 'june';

  @override
  String get july => 'july';

  @override
  String get august => 'august';

  @override
  String get september => 'september';

  @override
  String get october => 'october';

  @override
  String get november => 'november';

  @override
  String get december => 'december';

  @override
  String get in_ranking => 'in the ranking';

  @override
  String get save => 'save';

  @override
  String get discard => 'discard';

  @override
  String get skip => 'skip';

  @override
  String get back => 'back';

  @override
  String get ok => 'ok';

  @override
  String get show_tutorial => 'show tutorialsearch';

  @override
  String get search => 'search';

  @override
  String get requests => 'requests';

  @override
  String get sent_requests => 'sent';

  @override
  String get receive_requests => 'receive';

  @override
  String get search_friend => 'search a friend...';

  @override
  String get send_request => 'send request';

  @override
  String get request_sent => 'friend request sent';

  @override
  String get request_sent_not_found => 'no submitted requests found';

  @override
  String get request_receive_not_found => 'no received requests found';

  @override
  String get your_friend => 'your friend';

  @override
  String get see_fav_tracks => 'see their favorite tracks';

  @override
  String get see_their_stats => 'see their stats';

  @override
  String get no_last_swipes => 'no swipes found';

  @override
  String get liked => 'liked';

  @override
  String get disliked => 'disliked';

  @override
  String get no_tracks => 'no tracks found';

  @override
  String get showing => 'showing';

  @override
  String get tracks => 'track/s';

  @override
  String get export_tracks => 'export tracks';

  @override
  String get selected_tracks => 'selected track/s';

  @override
  String get release_date => 'release date';

  @override
  String get duration => 'duration';

  @override
  String get album => 'album';

  @override
  String get position_album => 'position in the';

  @override
  String get ranking => 'ranking';

  @override
  String get explicit_content => 'explicit content';

  @override
  String get lyrics => 'lyrics';

  @override
  String get by => 'by';

  @override
  String get likes => 'likes';

  @override
  String get dislikes => 'dislikes';

  @override
  String get related_tracks => 'related tracks';

  @override
  String get see_more => 'see more...';

  @override
  String get last_swipes => 'last 5 swipes';

  @override
  String get number_songs => 'number of songs';

  @override
  String get type => 'type';

  @override
  String get offered_by => 'data offered by';

  @override
  String get reset_picture => 'reset picture';

  @override
  String get update => 'update';

  @override
  String get genre => 'genre';

  @override
  String get about_songswipe_text =>
      'is an innovative way to discover music that suits your style. Swipe through tracks, listen to a short preview, and decide whether to save or skip them. Every song you like is stored in your personal collection for easy access anytime.\n\nYou can also connect with friends, explore the music they’ve saved, and share your discoveries with them. When you find a track you love, you’ll have the option to transfer it to your usual music service.\nDiscover, connect, and enjoy music like never before.';

  @override
  String get most_liked_tracks => 'most liked tracks';

  @override
  String get most_liked_albums => 'most liked albums';

  @override
  String get see_top_tracks => 'see top tracks';

  @override
  String get see_all_albums => 'see all albums';

  @override
  String get related_artists => 'related artists';

  @override
  String get of_txt => 'of';

  @override
  String get tracks_exported => 'tracks exported';

  @override
  String get tracks_succes_export => 'tracks exported successfully';

  @override
  String get as => 'as';

  @override
  String get export_to => 'export to';

  @override
  String get cant_export => 'could not export';

  @override
  String get playlist_description => 'tracks exported from SongSwipe';

  @override
  String get cant_select => 'you cannot select more than';

  @override
  String get plural_tracks => 'tracks';

  @override
  String get no_more_tracks_discover => 'there are no more songs to discover!';

  @override
  String get my_stats => 'my stats';

  @override
  String get their_stats => 'their stats';

  @override
  String get top_liked_artists => 'top 10 liked artists';

  @override
  String get top_disliked_artists => 'top 10 disliked artists';

  @override
  String get top_swiped_artists => 'top 10 swiped artists';

  @override
  String get top_liked_albums => 'top 10 liked albums';

  @override
  String get top_disliked_albums => 'top 10 disliked albums';

  @override
  String get top_swiped_albums => 'top 10 swiped albums';

  @override
  String get top_liked_artists_by => 'top 10 liked artists';

  @override
  String get top_disliked_artists_by => 'top 10 disliked artists';

  @override
  String get top_swiped_artists_by => 'top 10 swiped artists';

  @override
  String get top_liked_albums_by => 'top 10 liked albums';

  @override
  String get top_disliked_albums_by => 'top 10 disliked albums';

  @override
  String get top_swiped_albums_by => 'top 10 swiped albums';

  @override
  String get my_followers => 'my followers';

  @override
  String get my_following => 'my following';

  @override
  String get their_followers => 'their followers';

  @override
  String get their_following => 'their following';

  @override
  String get their_fav_tracks => 'their favorite tracks';

  @override
  String get email_reset_sent => 'password reset email sent';

  @override
  String get login_abort => 'login canceled.';

  @override
  String get select_one_track => 'select at least one song';

  @override
  String get top_tracks => 'top tracks';

  @override
  String get all_albums => 'all albums';

  @override
  String get confirm_delete_account_warning =>
      'are you sure you want to delete your account?';

  @override
  String get delete_account_irreversible =>
      'this action will permanently delete your account and all your data. Do you wish to continue?';

  @override
  String get account_deleted_success =>
      'your account has been successfully deleted';

  @override
  String get warning => 'warning!!!';

  @override
  String get cancel => 'cancel';

  @override
  String get reactivated_account => 'reactivated account';

  @override
  String get nothing_to_show => 'nothing to show';

  @override
  String get my_artists => 'my artists';

  @override
  String get my_genres => 'my genres';

  @override
  String get must_have_artists =>
      'you must have 5 artists as favorites at least';

  @override
  String get must_have_genres => 'you must have 3 genres as favorites at least';

  @override
  String get search_artists_title => 'search artists';

  @override
  String get search_genres_title => 'search genres';

  @override
  String get add => 'add';
}
