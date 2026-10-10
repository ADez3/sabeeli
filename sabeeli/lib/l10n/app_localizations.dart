import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('id'),
    Locale('tr'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sabeeli'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your daily path'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @navAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get navAzkar;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerJumuah.
  ///
  /// In en, this message translates to:
  /// **'Jumu\'ah'**
  String get prayerJumuah;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @midnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get midnight;

  /// No description provided for @lastThird.
  ///
  /// In en, this message translates to:
  /// **'Last third of the night'**
  String get lastThird;

  /// No description provided for @salam.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum'**
  String get salam;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayer;

  /// No description provided for @prayerTimeNow.
  ///
  /// In en, this message translates to:
  /// **'It is time for {prayer}'**
  String prayerTimeNow(String prayer);

  /// No description provided for @timeUntil.
  ///
  /// In en, this message translates to:
  /// **'in {duration}'**
  String timeUntil(String duration);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get prayerTimes;

  /// No description provided for @diveHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe up for your day'**
  String get diveHint;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @yourDay.
  ///
  /// In en, this message translates to:
  /// **'Your day'**
  String get yourDay;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @setLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get setLocation;

  /// No description provided for @setLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Prayer times and the Qibla are calculated from where you are. Your location never leaves your device.'**
  String get setLocationHint;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useCurrentLocation;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get searchCity;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get searchCityHint;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get locating;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off.'**
  String get locationDisabled;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Allow it from the app settings.'**
  String get locationDeniedForever;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @unknownPlace.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get unknownPlace;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get networkError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get calculation;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationMethod;

  /// No description provided for @asrMethod.
  ///
  /// In en, this message translates to:
  /// **'Asr time'**
  String get asrMethod;

  /// No description provided for @asrStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (Shafi\'i, Maliki, Hanbali)'**
  String get asrStandard;

  /// No description provided for @asrHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get asrHanafi;

  /// No description provided for @highLatitudeRule.
  ///
  /// In en, this message translates to:
  /// **'High latitude rule'**
  String get highLatitudeRule;

  /// No description provided for @highLatMiddle.
  ///
  /// In en, this message translates to:
  /// **'Middle of the night'**
  String get highLatMiddle;

  /// No description provided for @highLatSeventh.
  ///
  /// In en, this message translates to:
  /// **'One seventh of the night'**
  String get highLatSeventh;

  /// No description provided for @highLatAngle.
  ///
  /// In en, this message translates to:
  /// **'Twilight angle'**
  String get highLatAngle;

  /// No description provided for @highLatNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get highLatNone;

  /// No description provided for @adjustments.
  ///
  /// In en, this message translates to:
  /// **'Manual adjustments'**
  String get adjustments;

  /// No description provided for @adjustmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Add or remove minutes to match your local mosque.'**
  String get adjustmentsHint;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @methodMuslimWorldLeague.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMuslimWorldLeague;

  /// No description provided for @methodEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority of Survey'**
  String get methodEgyptian;

  /// No description provided for @methodKarachi.
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get methodKarachi;

  /// No description provided for @methodUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura, Makkah'**
  String get methodUmmAlQura;

  /// No description provided for @methodDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// No description provided for @methodQatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get methodQatar;

  /// No description provided for @methodKuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get methodKuwait;

  /// No description provided for @methodNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'Islamic Society of North America (ISNA)'**
  String get methodNorthAmerica;

  /// No description provided for @methodSingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore (MUIS)'**
  String get methodSingapore;

  /// No description provided for @methodTurkey.
  ///
  /// In en, this message translates to:
  /// **'Diyanet, Turkey'**
  String get methodTurkey;

  /// No description provided for @methodTehran.
  ///
  /// In en, this message translates to:
  /// **'Institute of Geophysics, Tehran'**
  String get methodTehran;

  /// No description provided for @methodFrance.
  ///
  /// In en, this message translates to:
  /// **'France (UOIF, 12°)'**
  String get methodFrance;

  /// No description provided for @methodRussia.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Administration of Muslims of Russia'**
  String get methodRussia;

  /// No description provided for @methodMorocco.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Habous, Morocco'**
  String get methodMorocco;

  /// No description provided for @methodAlgeria.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Religious Affairs, Algeria'**
  String get methodAlgeria;

  /// No description provided for @methodTunisia.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get methodTunisia;

  /// No description provided for @methodJordan.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Awqaf, Jordan'**
  String get methodJordan;

  /// No description provided for @methodIndonesia.
  ///
  /// In en, this message translates to:
  /// **'Kemenag, Indonesia'**
  String get methodIndonesia;

  /// No description provided for @methodMalaysia.
  ///
  /// In en, this message translates to:
  /// **'JAKIM, Malaysia'**
  String get methodMalaysia;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Notification sound'**
  String get notificationSound;

  /// No description provided for @notificationSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get notificationSilent;

  /// No description provided for @notificationOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notificationOff;

  /// No description provided for @reminderBefore.
  ///
  /// In en, this message translates to:
  /// **'Reminder before'**
  String get reminderBefore;

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get reminderOff;

  /// No description provided for @minutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String minutesBefore(int minutes);

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{prayer}'**
  String notificationTitle(String prayer);

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'It is time for {prayer} prayer'**
  String notificationBody(String prayer);

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'{prayer} in {minutes} minutes'**
  String reminderBody(String prayer, int minutes);

  /// No description provided for @notificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Sabeeli.'**
  String get notificationsBlocked;

  /// No description provided for @exactAlarmsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Alarms & reminders\" so prayer notifications arrive exactly on time.'**
  String get exactAlarmsNeeded;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @channelSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent prayer notifications'**
  String get channelSilent;

  /// No description provided for @channelPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get channelPrayer;

  /// No description provided for @channelReminder.
  ///
  /// In en, this message translates to:
  /// **'Prayer reminders'**
  String get channelReminder;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction'**
  String get qiblaDirection;

  /// No description provided for @facingQibla.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get facingQibla;

  /// No description provided for @turnTowards.
  ///
  /// In en, this message translates to:
  /// **'Turn until the arrow points up'**
  String get turnTowards;

  /// No description provided for @degreesFromNorth.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° from north'**
  String degreesFromNorth(String degrees);

  /// No description provided for @distanceToKaaba.
  ///
  /// In en, this message translates to:
  /// **'{distance} km to the Kaaba'**
  String distanceToKaaba(String distance);

  /// No description provided for @calibrateCompass.
  ///
  /// In en, this message translates to:
  /// **'Compass accuracy is low. Move your phone in a figure-eight to calibrate.'**
  String get calibrateCompass;

  /// No description provided for @compassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This device has no compass. Use the bearing below with a physical compass.'**
  String get compassUnavailable;

  /// No description provided for @qiblaNeedsLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location to find the Qibla.'**
  String get qiblaNeedsLocation;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get quran;

  /// No description provided for @surahs.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get surahs;

  /// No description provided for @juzs.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juzs;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @juzNumber.
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String juzNumber(int number);

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String pageNumber(int number);

  /// No description provided for @ayahCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ayah} other{{count} ayahs}}'**
  String ayahCount(int count);

  /// No description provided for @surahAyah.
  ///
  /// In en, this message translates to:
  /// **'{surah}, ayah {ayah}'**
  String surahAyah(String surah, int ayah);

  /// No description provided for @meccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get meccan;

  /// No description provided for @medinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get medinan;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get startReading;

  /// No description provided for @lastRead.
  ///
  /// In en, this message translates to:
  /// **'Last read'**
  String get lastRead;

  /// No description provided for @tafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get tafsir;

  /// No description provided for @tafsirMuyassar.
  ///
  /// In en, this message translates to:
  /// **'Tafsir al-Muyassar'**
  String get tafsirMuyassar;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// No description provided for @setAsLastRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as where I stopped'**
  String get setAsLastRead;

  /// No description provided for @lastReadSaved.
  ///
  /// In en, this message translates to:
  /// **'Reading position saved'**
  String get lastReadSaved;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet. Tap an ayah while reading to bookmark it.'**
  String get noBookmarks;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @searchSurah.
  ///
  /// In en, this message translates to:
  /// **'Search surahs'**
  String get searchSurah;

  /// No description provided for @sajda.
  ///
  /// In en, this message translates to:
  /// **'Sajda'**
  String get sajda;

  /// No description provided for @translationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This translation is not downloaded yet.'**
  String get translationUnavailable;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get downloading;

  /// No description provided for @translationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Translation language'**
  String get translationLanguage;

  /// No description provided for @noTranslation.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noTranslation;

  /// No description provided for @readerSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading settings'**
  String get readerSettings;

  /// No description provided for @dailyAyah.
  ///
  /// In en, this message translates to:
  /// **'Ayah of the day'**
  String get dailyAyah;

  /// No description provided for @azkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// No description provided for @azkarMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning azkar'**
  String get azkarMorning;

  /// No description provided for @azkarEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening azkar'**
  String get azkarEvening;

  /// No description provided for @azkarAfterPrayer.
  ///
  /// In en, this message translates to:
  /// **'After prayer'**
  String get azkarAfterPrayer;

  /// No description provided for @azkarSleep.
  ///
  /// In en, this message translates to:
  /// **'Before sleep'**
  String get azkarSleep;

  /// No description provided for @azkarWaking.
  ///
  /// In en, this message translates to:
  /// **'Upon waking'**
  String get azkarWaking;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All supplications'**
  String get allCategories;

  /// No description provided for @tapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get tapToCount;

  /// No description provided for @repeatCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Once} =2{Twice} other{{count} times}}'**
  String repeatCount(int count);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @azkarDone.
  ///
  /// In en, this message translates to:
  /// **'May Allah accept from you'**
  String get azkarDone;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get restart;

  /// No description provided for @progressOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String progressOf(int done, int total);

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @virtue.
  ///
  /// In en, this message translates to:
  /// **'Virtue'**
  String get virtue;

  /// No description provided for @searchAzkar.
  ///
  /// In en, this message translates to:
  /// **'Search supplications'**
  String get searchAzkar;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 supplication} other{{count} supplications}}'**
  String itemsCount(int count);

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @noTarget.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noTarget;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String totalCount(int count);

  /// No description provided for @rounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds: {count}'**
  String rounds(int count);

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @numerals.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numerals;

  /// No description provided for @numeralsAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic (by region)'**
  String get numeralsAuto;

  /// No description provided for @numeralsWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get numeralsWestern;

  /// No description provided for @numeralsArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic (Eastern)'**
  String get numeralsArabic;

  /// No description provided for @numeralsPersian.
  ///
  /// In en, this message translates to:
  /// **'Persian / Urdu'**
  String get numeralsPersian;

  /// No description provided for @hijriCalendar.
  ///
  /// In en, this message translates to:
  /// **'Hijri calendar'**
  String get hijriCalendar;

  /// No description provided for @hijriCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'Countries do not always agree on when a month begins. Adjust the calendar to follow your local announcement.'**
  String get hijriCalendarHint;

  /// No description provided for @hijriMethod.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get hijriMethod;

  /// No description provided for @hijriUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura (Saudi Arabia)'**
  String get hijriUmmAlQura;

  /// No description provided for @hijriTabular.
  ///
  /// In en, this message translates to:
  /// **'Arithmetical (Kuwaiti algorithm)'**
  String get hijriTabular;

  /// No description provided for @hijriOffset.
  ///
  /// In en, this message translates to:
  /// **'Shift all months'**
  String get hijriOffset;

  /// No description provided for @hijriOffsetValue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{No shift} =1{1 day} other{{days} days}}'**
  String hijriOffsetValue(int days);

  /// No description provided for @hijriThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get hijriThisMonth;

  /// No description provided for @hijriMonthStartedOn.
  ///
  /// In en, this message translates to:
  /// **'Start of {month}'**
  String hijriMonthStartedOn(String month);

  /// No description provided for @hijriAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get hijriAutomatic;

  /// No description provided for @hijriResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all corrections'**
  String get hijriResetAll;

  /// No description provided for @hijriCorrections.
  ///
  /// In en, this message translates to:
  /// **'Month corrections'**
  String get hijriCorrections;

  /// No description provided for @hijriYearSuffix.
  ///
  /// In en, this message translates to:
  /// **'AH'**
  String get hijriYearSuffix;

  /// No description provided for @hijriMonth1.
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMonth1;

  /// No description provided for @hijriMonth2.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriMonth2;

  /// No description provided for @hijriMonth3.
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Awwal'**
  String get hijriMonth3;

  /// No description provided for @hijriMonth4.
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Thani'**
  String get hijriMonth4;

  /// No description provided for @hijriMonth5.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Ula'**
  String get hijriMonth5;

  /// No description provided for @hijriMonth6.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Akhirah'**
  String get hijriMonth6;

  /// No description provided for @hijriMonth7.
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriMonth7;

  /// No description provided for @hijriMonth8.
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban'**
  String get hijriMonth8;

  /// No description provided for @hijriMonth9.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriMonth9;

  /// No description provided for @hijriMonth10.
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriMonth10;

  /// No description provided for @hijriMonth11.
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Qa\'dah'**
  String get hijriMonth11;

  /// No description provided for @hijriMonth12.
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Hijjah'**
  String get hijriMonth12;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Sabeeli is a free companion for the daily life of a Muslim. It works offline, has no ads, and collects no data.'**
  String get aboutText;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Sources & credits'**
  String get credits;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'fr',
    'id',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
