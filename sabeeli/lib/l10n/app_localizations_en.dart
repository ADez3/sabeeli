// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Your daily path';

  @override
  String get navHome => 'Home';

  @override
  String get navQuran => 'Quran';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navAzkar => 'Azkar';

  @override
  String get navMore => 'More';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerJumuah => 'Jumu\'ah';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get midnight => 'Midnight';

  @override
  String get lastThird => 'Last third of the night';

  @override
  String get salam => 'Assalamu alaikum';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String prayerTimeNow(String prayer) {
    return 'It is time for $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'in $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get prayerTimes => 'Prayer times';

  @override
  String get diveHint => 'Swipe up for your day';

  @override
  String get now => 'Now';

  @override
  String get yourDay => 'Your day';

  @override
  String get location => 'Location';

  @override
  String get setLocation => 'Set your location';

  @override
  String get setLocationHint =>
      'Prayer times and the Qibla are calculated from where you are. Your location never leaves your device.';

  @override
  String get useCurrentLocation => 'Use my current location';

  @override
  String get searchCity => 'Search for a city';

  @override
  String get searchCityHint => 'City name';

  @override
  String get locating => 'Finding your location…';

  @override
  String get locationDisabled => 'Location services are turned off.';

  @override
  String get locationDenied => 'Location permission was denied.';

  @override
  String get locationDeniedForever =>
      'Location permission is blocked. Allow it from the app settings.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get unknownPlace => 'Current location';

  @override
  String get noResults => 'No results';

  @override
  String get networkError =>
      'No connection. Check your internet and try again.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get calculation => 'Calculation';

  @override
  String get calculationMethod => 'Calculation method';

  @override
  String get asrMethod => 'Asr time';

  @override
  String get asrStandard => 'Standard (Shafi\'i, Maliki, Hanbali)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get highLatitudeRule => 'High latitude rule';

  @override
  String get highLatMiddle => 'Middle of the night';

  @override
  String get highLatSeventh => 'One seventh of the night';

  @override
  String get highLatAngle => 'Twilight angle';

  @override
  String get highLatNone => 'None';

  @override
  String get adjustments => 'Manual adjustments';

  @override
  String get adjustmentsHint =>
      'Add or remove minutes to match your local mosque.';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get methodMuslimWorldLeague => 'Muslim World League';

  @override
  String get methodEgyptian => 'Egyptian General Authority of Survey';

  @override
  String get methodKarachi => 'University of Islamic Sciences, Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura, Makkah';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodNorthAmerica => 'Islamic Society of North America (ISNA)';

  @override
  String get methodSingapore => 'Singapore (MUIS)';

  @override
  String get methodTurkey => 'Diyanet, Turkey';

  @override
  String get methodTehran => 'Institute of Geophysics, Tehran';

  @override
  String get methodFrance => 'France (UOIF, 12°)';

  @override
  String get methodRussia => 'Spiritual Administration of Muslims of Russia';

  @override
  String get methodMorocco => 'Ministry of Habous, Morocco';

  @override
  String get methodAlgeria => 'Ministry of Religious Affairs, Algeria';

  @override
  String get methodTunisia => 'Tunisia';

  @override
  String get methodJordan => 'Ministry of Awqaf, Jordan';

  @override
  String get methodIndonesia => 'Kemenag, Indonesia';

  @override
  String get methodMalaysia => 'JAKIM, Malaysia';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSound => 'Notification sound';

  @override
  String get notificationSilent => 'Silent';

  @override
  String get notificationOff => 'Off';

  @override
  String get reminderBefore => 'Reminder before';

  @override
  String get reminderOff => 'No reminder';

  @override
  String minutesBefore(int minutes) {
    return '$minutes min before';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'It is time for $prayer prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer in $minutes minutes';
  }

  @override
  String get notificationsBlocked =>
      'Notifications are turned off for Sabeeli.';

  @override
  String get exactAlarmsNeeded =>
      'Allow \"Alarms & reminders\" so prayer notifications arrive exactly on time.';

  @override
  String get allow => 'Allow';

  @override
  String get channelSilent => 'Silent prayer notifications';

  @override
  String get channelPrayer => 'Prayer times';

  @override
  String get channelReminder => 'Prayer reminders';

  @override
  String get qibla => 'Qibla';

  @override
  String get qiblaDirection => 'Qibla direction';

  @override
  String get facingQibla => 'You are facing the Qibla';

  @override
  String get turnTowards => 'Turn until the arrow points up';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° from north';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance km to the Kaaba';
  }

  @override
  String get calibrateCompass =>
      'Compass accuracy is low. Move your phone in a figure-eight to calibrate.';

  @override
  String get compassUnavailable =>
      'This device has no compass. Use the bearing below with a physical compass.';

  @override
  String get qiblaNeedsLocation => 'Set your location to find the Qibla.';

  @override
  String get you => 'You';

  @override
  String get makkah => 'Makkah';

  @override
  String get qiblaGreatCircle =>
      'The Qibla follows the shortest path over the Earth, not a straight line on a flat map.';

  @override
  String get globeView => 'Globe';

  @override
  String get compassView => 'Compass';

  @override
  String get quran => 'The Holy Quran';

  @override
  String get surahs => 'Surahs';

  @override
  String get juzs => 'Juz';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String juzNumber(int number) {
    return 'Juz $number';
  }

  @override
  String pageNumber(int number) {
    return 'Page $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayahs',
      one: '1 ayah',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, ayah $ayah';
  }

  @override
  String get meccan => 'Meccan';

  @override
  String get medinan => 'Medinan';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get startReading => 'Start reading';

  @override
  String get lastRead => 'Last read';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get tafsirMuyassar => 'Tafsir al-Muyassar';

  @override
  String get translation => 'Translation';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String get copied => 'Copied';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get setAsLastRead => 'Mark as where I stopped';

  @override
  String get lastReadSaved => 'Reading position saved';

  @override
  String get noBookmarks =>
      'No bookmarks yet. Tap an ayah while reading to bookmark it.';

  @override
  String get fontSize => 'Font size';

  @override
  String get searchSurah => 'Search surahs';

  @override
  String get sajda => 'Sajda';

  @override
  String get translationUnavailable =>
      'This translation is not downloaded yet.';

  @override
  String get download => 'Download';

  @override
  String get downloading => 'Downloading…';

  @override
  String get translationLanguage => 'Translation language';

  @override
  String get noTranslation => 'None';

  @override
  String get readerSettings => 'Reading settings';

  @override
  String get dailyAyah => 'Ayah of the day';

  @override
  String get skyView => 'Sky';

  @override
  String get listView => 'List';

  @override
  String khatmahProgress(int percent) {
    return '$percent% of the Quran read';
  }

  @override
  String get skyHint => 'Each star is a surah. It brightens as you read it.';

  @override
  String revelationOrder(int order) {
    return 'Revealed $order of 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'Pages $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent% read';
  }

  @override
  String get openSurah => 'Open';

  @override
  String get azkar => 'Azkar';

  @override
  String get azkarMorning => 'Morning azkar';

  @override
  String get azkarEvening => 'Evening azkar';

  @override
  String get azkarAfterPrayer => 'After prayer';

  @override
  String get azkarSleep => 'Before sleep';

  @override
  String get azkarWaking => 'Upon waking';

  @override
  String get allCategories => 'All supplications';

  @override
  String get tapToCount => 'Tap to count';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      two: 'Twice',
      one: 'Once',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Completed';

  @override
  String get azkarDone => 'May Allah accept from you';

  @override
  String get restart => 'Start again';

  @override
  String progressOf(int done, int total) {
    return '$done of $total';
  }

  @override
  String get source => 'Source';

  @override
  String get virtue => 'Virtue';

  @override
  String get searchAzkar => 'Search supplications';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count supplications',
      one: '1 supplication',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Reset';

  @override
  String get target => 'Target';

  @override
  String get noTarget => 'No limit';

  @override
  String totalCount(int count) {
    return 'Total: $count';
  }

  @override
  String rounds(int count) {
    return 'Rounds: $count';
  }

  @override
  String get vibration => 'Vibration';

  @override
  String get more => 'More';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get numerals => 'Numbers';

  @override
  String get numeralsAuto => 'Automatic (by region)';

  @override
  String get numeralsWestern => 'Western';

  @override
  String get numeralsArabic => 'Arabic (Eastern)';

  @override
  String get numeralsPersian => 'Persian / Urdu';

  @override
  String get hijriCalendar => 'Hijri calendar';

  @override
  String get hijriCalendarHint =>
      'Countries do not always agree on when a month begins. Adjust the calendar to follow your local announcement.';

  @override
  String get hijriMethod => 'Calendar';

  @override
  String get hijriUmmAlQura => 'Umm al-Qura (Saudi Arabia)';

  @override
  String get hijriTabular => 'Arithmetical (Kuwaiti algorithm)';

  @override
  String get hijriOffset => 'Shift all months';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'No shift',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'This month';

  @override
  String hijriMonthStartedOn(String month) {
    return 'Start of $month';
  }

  @override
  String get hijriAutomatic => 'Automatic';

  @override
  String get hijriResetAll => 'Reset all corrections';

  @override
  String get hijriCorrections => 'Month corrections';

  @override
  String get hijriYearSuffix => 'AH';

  @override
  String get hijriMonth1 => 'Muharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabi\' al-Awwal';

  @override
  String get hijriMonth4 => 'Rabi\' al-Thani';

  @override
  String get hijriMonth5 => 'Jumada al-Ula';

  @override
  String get hijriMonth6 => 'Jumada al-Akhirah';

  @override
  String get hijriMonth7 => 'Rajab';

  @override
  String get hijriMonth8 => 'Sha\'ban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Shawwal';

  @override
  String get hijriMonth11 => 'Dhu al-Qa\'dah';

  @override
  String get hijriMonth12 => 'Dhu al-Hijjah';

  @override
  String get eidAlFitr => 'Eid al-Fitr';

  @override
  String get eidAlAdha => 'Eid al-Adha';

  @override
  String get dayOfArafah => 'Day of Arafah';

  @override
  String get ashura => 'Ashura';

  @override
  String get islamicNewYear => 'Islamic New Year';

  @override
  String get whiteDays => 'White days';

  @override
  String get ramadanBegins => 'Ramadan begins';

  @override
  String get about => 'About';

  @override
  String get aboutText =>
      'Sabeeli is a free companion for the daily life of a Muslim. It works offline, has no ads, and collects no data.';

  @override
  String get credits => 'Sources & credits';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get afterPrayer => 'After prayer';

  @override
  String afterPrayerOf(String prayer) {
    return 'After $prayer';
  }

  @override
  String get afterPrayerHint => 'The adhkar after the salam, step by step';

  @override
  String get showTranslation => 'Translation';

  @override
  String get turnTheBeads => 'Turn the beads, or tap';

  @override
  String get doneStep => 'Done';

  @override
  String get previousStep => 'Previous';

  @override
  String get skipStep => 'Skip';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remembrances of Allah',
      one: '1 remembrance of Allah',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer in';
  }

  @override
  String atTime(String time) {
    return 'at $time';
  }

  @override
  String get nowLabel => 'Now';

  @override
  String pageAyah(int page, int ayah) {
    return 'Page $page · Ayah $ayah';
  }

  @override
  String get tasbihHint => 'Turn the beads';

  @override
  String get azkarHint => 'Morning, evening and more';

  @override
  String get ayahOfTheDay => 'Ayah of the day';

  @override
  String get navToday => 'Today';

  @override
  String get navDhikr => 'Dhikr';

  @override
  String get riwayah => 'Riwayah';

  @override
  String get riwayahAuto => 'Automatic, by region';

  @override
  String get riwayahHafs => 'Hafs from ʿAsim';

  @override
  String get riwayahWarsh => 'Warsh from Nafiʿ';

  @override
  String get riwayahQalun => 'Qalun from Nafiʿ';

  @override
  String get riwayahHafsHint => 'Read across most of the Muslim world';

  @override
  String get riwayahWarshHint => 'Morocco, Algeria, Mauritania, West Africa';

  @override
  String get riwayahQalunHint => 'Libya, Tunisia';

  @override
  String get riwayahNote =>
      'Each riwayah is shown in its own King Fahd Complex mushaf. Tafsir and translations are matched to it ayah by ayah.';

  @override
  String get general => 'General';

  @override
  String get dhikrSubtitle => 'Remember Allah, and He remembers you';

  @override
  String get qiblaSubtitle => 'The direction of the Kaaba from where you are';
}
