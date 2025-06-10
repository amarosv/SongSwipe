import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'languages/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirm_password;

  /// No description provided for @email_placeholder.
  ///
  /// In en, this message translates to:
  /// **'enter your email'**
  String get email_placeholder;

  /// No description provided for @password_placeholder.
  ///
  /// In en, this message translates to:
  /// **'enter your password'**
  String get password_placeholder;

  /// No description provided for @confirm_password_placeholder.
  ///
  /// In en, this message translates to:
  /// **'confirm your password'**
  String get confirm_password_placeholder;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'create account'**
  String get create_account;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'already have an account?'**
  String get already_have_an_account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get login;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'english'**
  String get english;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'italian'**
  String get italian;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'forgot password?'**
  String get forgot_password;

  /// No description provided for @not_registered.
  ///
  /// In en, this message translates to:
  /// **'not registered?'**
  String get not_registered;

  /// No description provided for @error_password_empty.
  ///
  /// In en, this message translates to:
  /// **'password can\'t be empty'**
  String get error_password_empty;

  /// No description provided for @error_password_length.
  ///
  /// In en, this message translates to:
  /// **'password must be 8 characters long'**
  String get error_password_length;

  /// No description provided for @error_password_capital.
  ///
  /// In en, this message translates to:
  /// **'password must contain at least 1 capital letter'**
  String get error_password_capital;

  /// No description provided for @error_password_lowercase.
  ///
  /// In en, this message translates to:
  /// **'password must contain at least 1 lowercase letter'**
  String get error_password_lowercase;

  /// No description provided for @error_password_number.
  ///
  /// In en, this message translates to:
  /// **'password must contain at least 1 number'**
  String get error_password_number;

  /// No description provided for @error_password_special.
  ///
  /// In en, this message translates to:
  /// **'password must contain at least 1 special character'**
  String get error_password_special;

  /// No description provided for @error_password_invalid.
  ///
  /// In en, this message translates to:
  /// **'password must be 8 characters long, must contain 1 capital letter, 1 lowercase letter, 1 number and 1 special character'**
  String get error_password_invalid;

  /// No description provided for @error_passwords_match.
  ///
  /// In en, this message translates to:
  /// **'passwords don\'t match'**
  String get error_passwords_match;

  /// No description provided for @error_password_weak.
  ///
  /// In en, this message translates to:
  /// **'the password provided is too weak.'**
  String get error_password_weak;

  /// No description provided for @error_email_empty.
  ///
  /// In en, this message translates to:
  /// **'email can\'t be empty'**
  String get error_email_empty;

  /// No description provided for @error_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'email isn\'t valid'**
  String get error_email_invalid;

  /// No description provided for @error_account.
  ///
  /// In en, this message translates to:
  /// **'the account already exists for that email.'**
  String get error_account;

  /// No description provided for @complete_profile.
  ///
  /// In en, this message translates to:
  /// **'complete your profile'**
  String get complete_profile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @username_placeholder.
  ///
  /// In en, this message translates to:
  /// **'enter your username'**
  String get username_placeholder;

  /// No description provided for @username_info.
  ///
  /// In en, this message translates to:
  /// **'you can change your username later on the profile page.'**
  String get username_info;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get name;

  /// No description provided for @name_placeholder.
  ///
  /// In en, this message translates to:
  /// **'enter your name'**
  String get name_placeholder;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'last name'**
  String get lastname;

  /// No description provided for @lastname_placeholder.
  ///
  /// In en, this message translates to:
  /// **'enter your last name'**
  String get lastname_placeholder;

  /// No description provided for @upload_your_photo.
  ///
  /// In en, this message translates to:
  /// **'upload your photo'**
  String get upload_your_photo;

  /// No description provided for @continue_s.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get continue_s;

  /// No description provided for @sent_email.
  ///
  /// In en, this message translates to:
  /// **'we\'ve sent an email to '**
  String get sent_email;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'please verify the email to continue.'**
  String get verify;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'resend email'**
  String get resend;

  /// No description provided for @change_email.
  ///
  /// In en, this message translates to:
  /// **'change email'**
  String get change_email;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'sent!'**
  String get sent;

  /// No description provided for @resent.
  ///
  /// In en, this message translates to:
  /// **'we\'ve sent you another email'**
  String get resent;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'verified!'**
  String get verified;

  /// No description provided for @verified_email.
  ///
  /// In en, this message translates to:
  /// **'you have verified your email'**
  String get verified_email;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'attention!'**
  String get attention;

  /// No description provided for @fill_fields.
  ///
  /// In en, this message translates to:
  /// **'please fill in all fields'**
  String get fill_fields;

  /// No description provided for @error_account_not_exists.
  ///
  /// In en, this message translates to:
  /// **'no user found for that email or password is wrong'**
  String get error_account_not_exists;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'an error has occurred'**
  String get error;

  /// No description provided for @select_artists.
  ///
  /// In en, this message translates to:
  /// **'select at least 5 artists'**
  String get select_artists;

  /// No description provided for @search_artist.
  ///
  /// In en, this message translates to:
  /// **'search an artist...'**
  String get search_artist;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get done;

  /// No description provided for @select_genres.
  ///
  /// In en, this message translates to:
  /// **'select at least 3 genres'**
  String get select_genres;

  /// No description provided for @search_genre.
  ///
  /// In en, this message translates to:
  /// **'search an genre...'**
  String get search_genre;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'information'**
  String get info;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'full name'**
  String get full_name;

  /// No description provided for @date_joining.
  ///
  /// In en, this message translates to:
  /// **'joined'**
  String get date_joining;

  /// No description provided for @saved_songs.
  ///
  /// In en, this message translates to:
  /// **'saved songs'**
  String get saved_songs;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'following'**
  String get following;

  /// No description provided for @see_fav_artists.
  ///
  /// In en, this message translates to:
  /// **'see my favorite artists'**
  String get see_fav_artists;

  /// No description provided for @see_fav_genres.
  ///
  /// In en, this message translates to:
  /// **'see my favorite genres'**
  String get see_fav_genres;

  /// No description provided for @see_stats.
  ///
  /// In en, this message translates to:
  /// **'see my stats'**
  String get see_stats;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'edit profile'**
  String get edit_profile;

  /// No description provided for @swipes.
  ///
  /// In en, this message translates to:
  /// **'swipes'**
  String get swipes;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'library'**
  String get library;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'discover'**
  String get discover;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'friends'**
  String get friends;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'appearance'**
  String get appearance;

  /// No description provided for @profile_privacy.
  ///
  /// In en, this message translates to:
  /// **'profile and privacy'**
  String get profile_privacy;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'audio'**
  String get audio;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notifications;

  /// No description provided for @about_songswipe.
  ///
  /// In en, this message translates to:
  /// **'about SongSwipe'**
  String get about_songswipe;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'log out'**
  String get logout;

  /// No description provided for @logout_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to log out?'**
  String get logout_dialog_content;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @select_your_username.
  ///
  /// In en, this message translates to:
  /// **'select your username'**
  String get select_your_username;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'stats'**
  String get stats;

  /// No description provided for @followers_following.
  ///
  /// In en, this message translates to:
  /// **'followers and following'**
  String get followers_following;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'visibility'**
  String get visibility;

  /// No description provided for @make_account_private.
  ///
  /// In en, this message translates to:
  /// **'make account private'**
  String get make_account_private;

  /// No description provided for @account_private_label.
  ///
  /// In en, this message translates to:
  /// **'switching from private to public will automatically accept all pending friend requests.'**
  String get account_private_label;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'devices'**
  String get devices;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'delete account'**
  String get delete_account;

  /// No description provided for @who_can_see.
  ///
  /// In en, this message translates to:
  /// **'who can see it?'**
  String get who_can_see;

  /// No description provided for @currently_private_account.
  ///
  /// In en, this message translates to:
  /// **'your account is currently private, changing this setting will make your account public. are you sure?'**
  String get currently_private_account;

  /// No description provided for @play_loop.
  ///
  /// In en, this message translates to:
  /// **'play song in loop'**
  String get play_loop;

  /// No description provided for @autoplay.
  ///
  /// In en, this message translates to:
  /// **'autoplay'**
  String get autoplay;

  /// No description provided for @only_audio.
  ///
  /// In en, this message translates to:
  /// **'only audio'**
  String get only_audio;

  /// No description provided for @label_only_audio.
  ///
  /// In en, this message translates to:
  /// **'show or hide cover art, title and artist'**
  String get label_only_audio;

  /// No description provided for @allow_notifications.
  ///
  /// In en, this message translates to:
  /// **'allow notifications'**
  String get allow_notifications;

  /// No description provided for @new_friend_request.
  ///
  /// In en, this message translates to:
  /// **'new friend request'**
  String get new_friend_request;

  /// No description provided for @friend_request_approved.
  ///
  /// In en, this message translates to:
  /// **'friend request approved'**
  String get friend_request_approved;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'app'**
  String get app;

  /// No description provided for @new_app_update.
  ///
  /// In en, this message translates to:
  /// **'new app update'**
  String get new_app_update;

  /// No description provided for @weekly_recap.
  ///
  /// In en, this message translates to:
  /// **'weekly recap'**
  String get weekly_recap;

  /// No description provided for @label_weekly_recap.
  ///
  /// In en, this message translates to:
  /// **'we will send you a notification every sunday at 8pm'**
  String get label_weekly_recap;

  /// No description provided for @account_blocked.
  ///
  /// In en, this message translates to:
  /// **'account blocked'**
  String get account_blocked;

  /// No description provided for @label_account_blocked.
  ///
  /// In en, this message translates to:
  /// **'we will send you a notification if we block your account'**
  String get label_account_blocked;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'mode'**
  String get mode;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get light;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get system;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'theme'**
  String get theme;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get red;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'yellow'**
  String get yellow;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'pink'**
  String get pink;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'cards'**
  String get cards;

  /// No description provided for @animated_cover.
  ///
  /// In en, this message translates to:
  /// **'animated cover'**
  String get animated_cover;

  /// No description provided for @skip_songs.
  ///
  /// In en, this message translates to:
  /// **'buttons skip and back'**
  String get skip_songs;

  /// No description provided for @blurred_as_background.
  ///
  /// In en, this message translates to:
  /// **'blurred cover as background'**
  String get blurred_as_background;

  /// No description provided for @label_blurred_background.
  ///
  /// In en, this message translates to:
  /// **'disable this option to make the background colors related to the cover'**
  String get label_blurred_background;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'january'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'february'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'march'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'april'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'may'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'june'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'july'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'august'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'september'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'october'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'november'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'december'**
  String get december;

  /// No description provided for @in_ranking.
  ///
  /// In en, this message translates to:
  /// **'in the ranking'**
  String get in_ranking;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'discard'**
  String get discard;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get ok;

  /// No description provided for @show_tutorial.
  ///
  /// In en, this message translates to:
  /// **'show tutorialsearch'**
  String get show_tutorial;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'requests'**
  String get requests;

  /// No description provided for @sent_requests.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get sent_requests;

  /// No description provided for @receive_requests.
  ///
  /// In en, this message translates to:
  /// **'receive'**
  String get receive_requests;

  /// No description provided for @search_friend.
  ///
  /// In en, this message translates to:
  /// **'search a friend...'**
  String get search_friend;

  /// No description provided for @send_request.
  ///
  /// In en, this message translates to:
  /// **'send request'**
  String get send_request;

  /// No description provided for @request_sent.
  ///
  /// In en, this message translates to:
  /// **'friend request sent'**
  String get request_sent;

  /// No description provided for @request_sent_not_found.
  ///
  /// In en, this message translates to:
  /// **'no submitted requests found'**
  String get request_sent_not_found;

  /// No description provided for @request_receive_not_found.
  ///
  /// In en, this message translates to:
  /// **'no received requests found'**
  String get request_receive_not_found;

  /// No description provided for @your_friend.
  ///
  /// In en, this message translates to:
  /// **'your friend'**
  String get your_friend;

  /// No description provided for @see_fav_tracks.
  ///
  /// In en, this message translates to:
  /// **'see their favorite tracks'**
  String get see_fav_tracks;

  /// No description provided for @see_their_stats.
  ///
  /// In en, this message translates to:
  /// **'see their stats'**
  String get see_their_stats;

  /// No description provided for @no_last_swipes.
  ///
  /// In en, this message translates to:
  /// **'no swipes found'**
  String get no_last_swipes;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'liked'**
  String get liked;

  /// No description provided for @disliked.
  ///
  /// In en, this message translates to:
  /// **'disliked'**
  String get disliked;

  /// No description provided for @no_tracks.
  ///
  /// In en, this message translates to:
  /// **'no tracks found'**
  String get no_tracks;

  /// No description provided for @showing.
  ///
  /// In en, this message translates to:
  /// **'showing'**
  String get showing;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'track/s'**
  String get tracks;

  /// No description provided for @export_tracks.
  ///
  /// In en, this message translates to:
  /// **'export tracks'**
  String get export_tracks;

  /// No description provided for @selected_tracks.
  ///
  /// In en, this message translates to:
  /// **'selected track/s'**
  String get selected_tracks;

  /// No description provided for @release_date.
  ///
  /// In en, this message translates to:
  /// **'release date'**
  String get release_date;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get duration;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'album'**
  String get album;

  /// No description provided for @position_album.
  ///
  /// In en, this message translates to:
  /// **'position in the'**
  String get position_album;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'ranking'**
  String get ranking;

  /// No description provided for @explicit_content.
  ///
  /// In en, this message translates to:
  /// **'explicit content'**
  String get explicit_content;

  /// No description provided for @lyrics.
  ///
  /// In en, this message translates to:
  /// **'lyrics'**
  String get lyrics;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'likes'**
  String get likes;

  /// No description provided for @dislikes.
  ///
  /// In en, this message translates to:
  /// **'dislikes'**
  String get dislikes;

  /// No description provided for @related_tracks.
  ///
  /// In en, this message translates to:
  /// **'related tracks'**
  String get related_tracks;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'see more...'**
  String get see_more;

  /// No description provided for @last_swipes.
  ///
  /// In en, this message translates to:
  /// **'last 5 swipes'**
  String get last_swipes;

  /// No description provided for @number_songs.
  ///
  /// In en, this message translates to:
  /// **'number of songs'**
  String get number_songs;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get type;

  /// No description provided for @offered_by.
  ///
  /// In en, this message translates to:
  /// **'data offered by'**
  String get offered_by;

  /// No description provided for @reset_picture.
  ///
  /// In en, this message translates to:
  /// **'reset picture'**
  String get reset_picture;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get update;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'genre'**
  String get genre;

  /// No description provided for @about_songswipe_text.
  ///
  /// In en, this message translates to:
  /// **'is an innovative way to discover music that suits your style. Swipe through tracks, listen to a short preview, and decide whether to save or skip them. Every song you like is stored in your personal collection for easy access anytime.\n\nYou can also connect with friends, explore the music they’ve saved, and share your discoveries with them. When you find a track you love, you’ll have the option to transfer it to your usual music service.\nDiscover, connect, and enjoy music like never before.'**
  String get about_songswipe_text;

  /// No description provided for @most_liked_tracks.
  ///
  /// In en, this message translates to:
  /// **'most liked tracks'**
  String get most_liked_tracks;

  /// No description provided for @most_liked_albums.
  ///
  /// In en, this message translates to:
  /// **'most liked albums'**
  String get most_liked_albums;

  /// No description provided for @see_top_tracks.
  ///
  /// In en, this message translates to:
  /// **'see top tracks'**
  String get see_top_tracks;

  /// No description provided for @see_all_albums.
  ///
  /// In en, this message translates to:
  /// **'see all albums'**
  String get see_all_albums;

  /// No description provided for @related_artists.
  ///
  /// In en, this message translates to:
  /// **'related artists'**
  String get related_artists;

  /// No description provided for @of_txt.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get of_txt;

  /// No description provided for @tracks_exported.
  ///
  /// In en, this message translates to:
  /// **'tracks exported'**
  String get tracks_exported;

  /// No description provided for @tracks_succes_export.
  ///
  /// In en, this message translates to:
  /// **'tracks exported successfully'**
  String get tracks_succes_export;

  /// No description provided for @as.
  ///
  /// In en, this message translates to:
  /// **'as'**
  String get as;

  /// No description provided for @export_to.
  ///
  /// In en, this message translates to:
  /// **'export to'**
  String get export_to;

  /// No description provided for @cant_export.
  ///
  /// In en, this message translates to:
  /// **'could not export'**
  String get cant_export;

  /// No description provided for @playlist_description.
  ///
  /// In en, this message translates to:
  /// **'tracks exported from SongSwipe'**
  String get playlist_description;

  /// No description provided for @cant_select.
  ///
  /// In en, this message translates to:
  /// **'you cannot select more than'**
  String get cant_select;

  /// No description provided for @plural_tracks.
  ///
  /// In en, this message translates to:
  /// **'tracks'**
  String get plural_tracks;

  /// No description provided for @no_more_tracks_discover.
  ///
  /// In en, this message translates to:
  /// **'there are no more songs to discover!'**
  String get no_more_tracks_discover;

  /// No description provided for @my_stats.
  ///
  /// In en, this message translates to:
  /// **'my stats'**
  String get my_stats;

  /// No description provided for @their_stats.
  ///
  /// In en, this message translates to:
  /// **'their stats'**
  String get their_stats;

  /// No description provided for @top_liked_artists.
  ///
  /// In en, this message translates to:
  /// **'top 10 liked artists'**
  String get top_liked_artists;

  /// No description provided for @top_disliked_artists.
  ///
  /// In en, this message translates to:
  /// **'top 10 disliked artists'**
  String get top_disliked_artists;

  /// No description provided for @top_swiped_artists.
  ///
  /// In en, this message translates to:
  /// **'top 10 swiped artists'**
  String get top_swiped_artists;

  /// No description provided for @top_liked_albums.
  ///
  /// In en, this message translates to:
  /// **'top 10 liked albums'**
  String get top_liked_albums;

  /// No description provided for @top_disliked_albums.
  ///
  /// In en, this message translates to:
  /// **'top 10 disliked albums'**
  String get top_disliked_albums;

  /// No description provided for @top_swiped_albums.
  ///
  /// In en, this message translates to:
  /// **'top 10 swiped albums'**
  String get top_swiped_albums;

  /// No description provided for @top_liked_artists_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 liked artists'**
  String get top_liked_artists_by;

  /// No description provided for @top_disliked_artists_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 disliked artists'**
  String get top_disliked_artists_by;

  /// No description provided for @top_swiped_artists_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 swiped artists'**
  String get top_swiped_artists_by;

  /// No description provided for @top_liked_albums_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 liked albums'**
  String get top_liked_albums_by;

  /// No description provided for @top_disliked_albums_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 disliked albums'**
  String get top_disliked_albums_by;

  /// No description provided for @top_swiped_albums_by.
  ///
  /// In en, this message translates to:
  /// **'top 10 swiped albums'**
  String get top_swiped_albums_by;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
