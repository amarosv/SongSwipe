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
  String get info_app => 'aksajhsdhsadj';

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
  String get skip_songs => 'skip and back songs';

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
  String get show_tutorial => 'show tutorial';
}
