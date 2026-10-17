// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Dein täglicher Weg';

  @override
  String get navHome => 'Start';

  @override
  String get navQuran => 'Koran';

  @override
  String get navPrayer => 'Gebet';

  @override
  String get navAzkar => 'Adhkar';

  @override
  String get navMore => 'Mehr';

  @override
  String get prayerFajr => 'Fadschr';

  @override
  String get prayerSunrise => 'Sonnenaufgang';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerJumuah => 'Dschumu\'a';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Ischa';

  @override
  String get midnight => 'Mitternacht';

  @override
  String get lastThird => 'Letztes Drittel der Nacht';

  @override
  String get salam => 'Assalamu alaikum';

  @override
  String get nextPrayer => 'Nächstes Gebet';

  @override
  String prayerTimeNow(String prayer) {
    return 'Es ist Zeit für $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'in $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get today => 'Heute';

  @override
  String get tomorrow => 'Morgen';

  @override
  String get prayerTimes => 'Gebetszeiten';

  @override
  String get diveHint => 'Nach oben wischen für deinen Tag';

  @override
  String get now => 'Jetzt';

  @override
  String get yourDay => 'Dein Tag';

  @override
  String get location => 'Standort';

  @override
  String get setLocation => 'Standort festlegen';

  @override
  String get setLocationHint =>
      'Gebetszeiten und Qibla werden auf deinem Handy anhand deines Standorts berechnet. Nur eine gerundete Position wird an OpenStreetMap gesendet, um deinen Ort zu benennen.';

  @override
  String get useCurrentLocation => 'Aktuellen Standort verwenden';

  @override
  String get searchCity => 'Stadt suchen';

  @override
  String get searchCityHint => 'Name der Stadt';

  @override
  String get locating => 'Standort wird ermittelt…';

  @override
  String get locationDisabled => 'Die Standortdienste sind ausgeschaltet.';

  @override
  String get locationDenied => 'Die Standortberechtigung wurde verweigert.';

  @override
  String get locationDeniedForever =>
      'Die Standortberechtigung ist blockiert. Erlaube sie in den App-Einstellungen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get unknownPlace => 'Aktueller Standort';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get networkError =>
      'Keine Verbindung. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get genericError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get calculation => 'Berechnung';

  @override
  String get calculationMethod => 'Berechnungsmethode';

  @override
  String get asrMethod => 'Asr-Zeit';

  @override
  String get asrStandard => 'Standard (Schafi\'i, Maliki, Hanbali)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get highLatitudeRule => 'Regel für hohe Breiten';

  @override
  String get highLatMiddle => 'Mitte der Nacht';

  @override
  String get highLatSeventh => 'Ein Siebtel der Nacht';

  @override
  String get highLatAngle => 'Dämmerungswinkel';

  @override
  String get highLatNone => 'Keine';

  @override
  String get adjustments => 'Manuelle Anpassungen';

  @override
  String get adjustmentsHint =>
      'Füge Minuten hinzu oder ziehe sie ab, passend zu deiner Moschee.';

  @override
  String get hourShift => 'Stundenkorrektur';

  @override
  String get hourShiftHint =>
      'Nur wenn alle Zeiten um ganze Stunden abweichen: Dann ist die Zeitzone deines Handys falsch (zum Beispiel noch GMT+1, obwohl das Land seine Zeit geändert hat). Besser ist es, die richtige Zeitzone am Handy einzustellen.';

  @override
  String hoursShort(int hours) {
    return '$hours Std.';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get methodMuslimWorldLeague => 'Islamische Weltliga';

  @override
  String get methodEgyptian => 'Ägyptische Generalbehörde für Vermessung';

  @override
  String get methodKarachi =>
      'Universität für Islamische Wissenschaften, Karatschi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura, Mekka';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodQatar => 'Katar';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodNorthAmerica => 'Islamic Society of North America (ISNA)';

  @override
  String get methodSingapore => 'Singapur (MUIS)';

  @override
  String get methodTurkey => 'Diyanet, Türkei';

  @override
  String get methodTehran => 'Institut für Geophysik, Teheran';

  @override
  String get methodFrance => 'Frankreich (UOIF, 12°)';

  @override
  String get methodRussia => 'Geistliche Verwaltung der Muslime Russlands';

  @override
  String get methodMorocco => 'Ministerium für Habous, Marokko';

  @override
  String get methodAlgeria =>
      'Ministerium für religiöse Angelegenheiten, Algerien';

  @override
  String get methodTunisia => 'Tunesien';

  @override
  String get methodJordan => 'Ministerium für Awqaf, Jordanien';

  @override
  String get methodIndonesia => 'Kemenag, Indonesien';

  @override
  String get methodMalaysia => 'JAKIM, Malaysia';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationSound => 'Benachrichtigungston';

  @override
  String get notificationSilent => 'Lautlos';

  @override
  String get notificationOff => 'Aus';

  @override
  String get reminderBefore => 'Erinnerung vorher';

  @override
  String get reminderOff => 'Keine Erinnerung';

  @override
  String minutesBefore(int minutes) {
    return '$minutes Min. vorher';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'Es ist Zeit für das $prayer-Gebet';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer in $minutes Minuten';
  }

  @override
  String get notificationsBlocked =>
      'Benachrichtigungen sind für Sabeeli ausgeschaltet.';

  @override
  String get exactAlarmsNeeded =>
      'Erlaube „Wecker und Erinnerungen“, damit Gebetsbenachrichtigungen pünktlich ankommen.';

  @override
  String get allow => 'Erlauben';

  @override
  String get channelSilent => 'Lautlose Gebetsbenachrichtigungen';

  @override
  String get channelPrayer => 'Gebetszeiten';

  @override
  String get channelReminder => 'Gebetserinnerungen';

  @override
  String get qibla => 'Qibla';

  @override
  String get qiblaDirection => 'Qibla-Richtung';

  @override
  String get facingQibla => 'Du blickst zur Qibla';

  @override
  String get turnTowards => 'Dreh dich, bis der Pfeil nach oben zeigt';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° von Norden';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance km bis zur Kaaba';
  }

  @override
  String get calibrateCompass =>
      'Der Kompass ist ungenau. Bewege dein Handy in Form einer Acht, um ihn zu kalibrieren.';

  @override
  String get compassUnavailable =>
      'Dieses Gerät hat keinen Kompass. Nutze die Gradzahl unten mit einem echten Kompass.';

  @override
  String get qiblaNeedsLocation =>
      'Lege deinen Standort fest, um die Qibla zu finden.';

  @override
  String get you => 'Du';

  @override
  String get makkah => 'Mekka';

  @override
  String get qiblaGreatCircle =>
      'Die Qibla folgt dem kürzesten Weg über die Erde, nicht einer geraden Linie auf einer flachen Karte.';

  @override
  String get globeView => 'Globus';

  @override
  String get compassView => 'Kompass';

  @override
  String get quran => 'Der edle Koran';

  @override
  String get surahs => 'Suren';

  @override
  String get juzs => 'Dschuz';

  @override
  String get bookmarks => 'Lesezeichen';

  @override
  String juzNumber(int number) {
    return 'Dschuz $number';
  }

  @override
  String pageNumber(int number) {
    return 'Seite $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Verse',
      one: '1 Vers',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, Vers $ayah';
  }

  @override
  String get meccan => 'Mekkanisch';

  @override
  String get medinan => 'Medinensisch';

  @override
  String get continueReading => 'Weiterlesen';

  @override
  String get startReading => 'Lesen beginnen';

  @override
  String get lastRead => 'Zuletzt gelesen';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get tafsirMuyassar => 'Tafsir al-Muyassar';

  @override
  String get translation => 'Übersetzung';

  @override
  String get copy => 'Kopieren';

  @override
  String get share => 'Teilen';

  @override
  String get copied => 'Kopiert';

  @override
  String get bookmark => 'Lesezeichen';

  @override
  String get removeBookmark => 'Lesezeichen entfernen';

  @override
  String get bookmarkAdded => 'Lesezeichen hinzugefügt';

  @override
  String get bookmarkRemoved => 'Lesezeichen entfernt';

  @override
  String get setAsLastRead => 'Als Lesestelle merken';

  @override
  String get lastReadSaved => 'Lesestelle gespeichert';

  @override
  String get noBookmarks =>
      'Noch keine Lesezeichen. Tippe beim Lesen auf einen Vers, um ihn zu markieren.';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get searchSurah => 'Suren suchen';

  @override
  String get sajda => 'Sadschda';

  @override
  String get translationUnavailable =>
      'Diese Übersetzung ist noch nicht heruntergeladen.';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloading => 'Wird heruntergeladen…';

  @override
  String get translationLanguage => 'Sprache der Übersetzung';

  @override
  String get noTranslation => 'Keine';

  @override
  String get readerSettings => 'Leseeinstellungen';

  @override
  String get dailyAyah => 'Vers des Tages';

  @override
  String get skyView => 'Himmel';

  @override
  String get listView => 'Liste';

  @override
  String khatmahProgress(int percent) {
    return '$percent % des Korans gelesen';
  }

  @override
  String get skyHint =>
      'Jeder Stern ist eine Sure. Er leuchtet heller, während du sie liest.';

  @override
  String revelationOrder(int order) {
    return 'Offenbart als $order. von 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'Seiten $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent % gelesen';
  }

  @override
  String get openSurah => 'Öffnen';

  @override
  String get azkar => 'Adhkar';

  @override
  String get azkarMorning => 'Morgen-Adhkar';

  @override
  String get azkarEvening => 'Abend-Adhkar';

  @override
  String get azkarAfterPrayer => 'Nach dem Gebet';

  @override
  String get azkarSleep => 'Vor dem Schlafen';

  @override
  String get azkarWaking => 'Nach dem Aufwachen';

  @override
  String get allCategories => 'Alle Bittgebete';

  @override
  String get tapToCount => 'Tippen zum Zählen';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-mal',
      two: 'Zweimal',
      one: 'Einmal',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get azkarDone => 'Möge Allah es von dir annehmen';

  @override
  String get restart => 'Neu beginnen';

  @override
  String progressOf(int done, int total) {
    return '$done von $total';
  }

  @override
  String get source => 'Quelle';

  @override
  String get virtue => 'Vorzug';

  @override
  String get searchAzkar => 'Bittgebete suchen';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bittgebete',
      one: '1 Bittgebet',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get target => 'Ziel';

  @override
  String get noTarget => 'Ohne Ziel';

  @override
  String totalCount(int count) {
    return 'Gesamt: $count';
  }

  @override
  String rounds(int count) {
    return 'Runden: $count';
  }

  @override
  String get vibration => 'Vibration';

  @override
  String get more => 'Mehr';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get numerals => 'Ziffern';

  @override
  String get numeralsAuto => 'Automatisch (nach Region)';

  @override
  String get numeralsWestern => 'Westlich';

  @override
  String get numeralsArabic => 'Arabisch (östlich)';

  @override
  String get numeralsPersian => 'Persisch / Urdu';

  @override
  String get hijriCalendar => 'Hidschri-Kalender';

  @override
  String get hijriCalendarHint =>
      'Die Länder sind sich nicht immer einig, wann ein Monat beginnt. Passe den Kalender an die Ankündigung bei dir vor Ort an.';

  @override
  String get hijriMethod => 'Kalender';

  @override
  String get hijriUmmAlQura => 'Umm al-Qura (Saudi-Arabien)';

  @override
  String get hijriTabular => 'Rechnerisch (kuwaitischer Algorithmus)';

  @override
  String get hijriOffset => 'Alle Monate verschieben';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
      zero: 'Keine Verschiebung',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'Dieser Monat';

  @override
  String hijriMonthStartedOn(String month) {
    return 'Beginn von $month';
  }

  @override
  String get hijriAutomatic => 'Automatisch';

  @override
  String get hijriResetAll => 'Alle Korrekturen zurücksetzen';

  @override
  String get hijriCorrections => 'Monatskorrekturen';

  @override
  String get hijriYearSuffix => 'n. H.';

  @override
  String get hijriMonth1 => 'Muharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabi\' al-Awwal';

  @override
  String get hijriMonth4 => 'Rabi\' al-Thani';

  @override
  String get hijriMonth5 => 'Dschumada al-Ula';

  @override
  String get hijriMonth6 => 'Dschumada al-Achira';

  @override
  String get hijriMonth7 => 'Radschab';

  @override
  String get hijriMonth8 => 'Scha\'ban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Schawwal';

  @override
  String get hijriMonth11 => 'Dhu al-Qa\'da';

  @override
  String get hijriMonth12 => 'Dhu al-Hiddscha';

  @override
  String get eidAlFitr => 'Eid al-Fitr';

  @override
  String get eidAlAdha => 'Eid al-Adha';

  @override
  String get dayOfArafah => 'Tag von Arafa';

  @override
  String get ashura => 'Aschura';

  @override
  String get islamicNewYear => 'Islamisches Neujahr';

  @override
  String get whiteDays => 'Weiße Tage';

  @override
  String get ramadanBegins => 'Ramadan beginnt';

  @override
  String get about => 'Über';

  @override
  String get aboutText =>
      'Sabeeli ist ein kostenloser Begleiter für den Alltag eines Muslims. Die App funktioniert offline, hat keine Werbung und sammelt keine Daten.';

  @override
  String get credits => 'Quellen & Danksagungen';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get afterPrayer => 'Nach dem Gebet';

  @override
  String afterPrayerOf(String prayer) {
    return 'Nach $prayer';
  }

  @override
  String get afterPrayerHint =>
      'Die Adhkar nach dem Salam, Schritt für Schritt';

  @override
  String get showTranslation => 'Übersetzung';

  @override
  String get turnTheBeads => 'Dreh die Perlen oder tippe';

  @override
  String get doneStep => 'Fertig';

  @override
  String get previousStep => 'Zurück';

  @override
  String get skipStep => 'Überspringen';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gedenken an Allah',
      one: '1 Gedenken an Allah',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer in';
  }

  @override
  String atTime(String time) {
    return 'um $time';
  }

  @override
  String get nowLabel => 'Jetzt';

  @override
  String pageAyah(int page, int ayah) {
    return 'Seite $page · Vers $ayah';
  }

  @override
  String get tasbihHint => 'Dreh die Perlen';

  @override
  String get azkarHint => 'Morgens, abends und mehr';

  @override
  String get ayahOfTheDay => 'Vers des Tages';

  @override
  String get navToday => 'Heute';

  @override
  String get navDhikr => 'Dhikr';

  @override
  String get riwayah => 'Riwaya';

  @override
  String get riwayahAuto => 'Automatisch, nach Region';

  @override
  String get riwayahHafs => 'Hafs nach ʿAsim';

  @override
  String get riwayahWarsh => 'Warsch nach Nafiʿ';

  @override
  String get riwayahQalun => 'Qalun nach Nafiʿ';

  @override
  String get riwayahHafsHint =>
      'In den meisten Teilen der muslimischen Welt gelesen';

  @override
  String get riwayahWarshHint => 'Marokko, Algerien, Mauretanien, Westafrika';

  @override
  String get riwayahQalunHint => 'Libyen, Tunesien';

  @override
  String get riwayahNote =>
      'Jede Riwaya wird in ihrem eigenen Mushaf des König-Fahd-Komplexes angezeigt. Tafsir und Übersetzungen sind ihr Vers für Vers zugeordnet.';

  @override
  String get general => 'Allgemein';

  @override
  String get dhikrSubtitle => 'Gedenke Allahs, und Er gedenkt deiner';

  @override
  String get qiblaSubtitle => 'Die Richtung der Kaaba von deinem Standort aus';

  @override
  String get unitHours => 'Std.';

  @override
  String get unitMinutes => 'Min.';

  @override
  String get unitSeconds => 's';

  @override
  String get pageColour => 'Seite';

  @override
  String get pageAuto => 'Auto';

  @override
  String get pageNight => 'Nacht';

  @override
  String get pageSepia => 'Sepia';

  @override
  String get pagePaper => 'Papier';

  @override
  String get welcomeTagline =>
      'Gebet, Koran und Gedenken, unter dem echten Himmel über dir. Kostenlos, privat und ganz deins.';

  @override
  String get welcomeBegin => 'Beginnen';

  @override
  String get welcomeNext => 'Weiter';

  @override
  String get welcomeStart => 'Los geht\'s';

  @override
  String get welcomePlaceTitle => 'Wo bist du?';

  @override
  String get welcomeNotifyTitle => 'Zu jedem Gebet';

  @override
  String get welcomeNotifyBody =>
      'Eine sanfte Benachrichtigung mit dem eigenen Ton deines Handys, wenn eine Gebetszeit beginnt. Später kannst du es für jedes Gebet einzeln wählen.';

  @override
  String get welcomeNotifyAllow => 'Benachrichtigungen erlauben';

  @override
  String get welcomeNotifyOn => 'Benachrichtigungen sind an';

  @override
  String get welcomeExactAlarms => 'Auf die Minute genau ankommen lassen';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'Der Koran öffnet sich in $riwayah. Du kannst das in den Einstellungen ändern.';
  }

  @override
  String get prepareSoon => 'Bald';

  @override
  String get prepareHint => 'Zeit für die Gebetswaschung';

  @override
  String get channelDaily => 'Tägliche Erinnerungen';

  @override
  String get dailyReminders => 'Tägliche Erinnerungen';

  @override
  String get dailyMorning => 'Morgen-Adhkar';

  @override
  String get dailyMorningBody =>
      'Ein paar Minuten des Gedenkens zum Tagesbeginn.';

  @override
  String get dailyEvening => 'Abend-Adhkar';

  @override
  String get dailyEveningBody => 'Die Abend-Adhkar, wenn der Tag sich neigt.';

  @override
  String get dailySleep => 'Adhkar vor dem Schlafen';

  @override
  String get dailySleepBody => 'Beende den Tag mit Gedenken.';

  @override
  String get dailyQuran => 'Deine tägliche Lesung';

  @override
  String get dailyQuranBody => 'Eine Seite des Korans wartet auf dich.';

  @override
  String get dailyRemindersIntro =>
      'Erinnerungen an die Adhkar und deine tägliche Lesung, zur Uhrzeit deiner Wahl. Sie sind freiwillig: Dieselbe Benachrichtigung jeden Tag kann mit der Zeit zum bloßen Rauschen werden. Schalte also nur die ein, die dir wirklich helfen, und schalte sie aus, wann immer du möchtest.';

  @override
  String get dailyRemindersOff => 'Aus';

  @override
  String dailyRemindersOn(int count) {
    return '$count an';
  }

  @override
  String get betaBadge => 'Beta';

  @override
  String get betaTitle => 'Sabeeli ist in der Beta';

  @override
  String get betaBody =>
      'Die App ist noch jung. Ihre Texte, Übersetzungen und die angezeigten Informationen müssen noch von Gelehrten geprüft werden. Wenn dir etwas Falsches auffällt, auch nur ein kleines Detail, sag es uns bitte: Jede Meldung hilft.';

  @override
  String get betaShakeHint =>
      'Schüttle dein Handy auf einem beliebigen Bildschirm, um ein Problem mit Screenshot zu melden.';

  @override
  String get betaUnderstood => 'Verstanden';

  @override
  String get reportTitle => 'Problem melden';

  @override
  String get reportHint => 'Was stimmt nicht? (optional)';

  @override
  String get reportSend => 'Per E-Mail senden';

  @override
  String get reportAttach => 'Screenshot anhängen';

  @override
  String get reportPrivacy =>
      'Deine Mail-App öffnet sich mit der fertigen Meldung. Nichts wird gesendet, bevor du dort auf Senden tippst.';

  @override
  String get reportNoMail => 'Keine E-Mail-App auf diesem Handy gefunden';

  @override
  String get shakeToReport => 'Schütteln, um ein Problem zu melden';

  @override
  String get khatmahPlan => 'Khatma-Plan';

  @override
  String get planAKhatmah => 'Khatma planen';

  @override
  String khatmahDays(int days) {
    return '$days Tage';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'Tag $day von $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'Heute: Seiten $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Heute noch $count Seiten',
      one: 'Heute noch 1 Seite',
    );
    return '$_temp0';
  }

  @override
  String get khatmahDone => 'Der heutige Teil ist geschafft';

  @override
  String khatmahPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Etwa $count Seiten pro Tag',
      one: 'Etwa 1 Seite pro Tag',
    );
    return '$_temp0';
  }

  @override
  String khatmahEnds(String date) {
    return 'endet am $date';
  }

  @override
  String get khatmahFromStart => 'Von Anfang an';

  @override
  String khatmahFromHere(int page) {
    return 'Ab Seite $page';
  }

  @override
  String get khatmahStart => 'Plan starten';

  @override
  String get khatmahEnd => 'Plan beenden';

  @override
  String get khatmahFinished =>
      'Khatma abgeschlossen. Möge Allah sie annehmen.';

  @override
  String readOnDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'An $count der letzten 7 Tage gelesen',
      one: 'An 1 der letzten 7 Tage gelesen',
    );
    return '$_temp0';
  }

  @override
  String get fastRamadan => 'Ramadan';

  @override
  String get fastMondayThursday => 'Montags und donnerstags';

  @override
  String get fastWhiteDays => 'Die weißen Tage';

  @override
  String get fastArafah => 'Der Tag von Arafa';

  @override
  String get fastAshura => 'Tasu‘a und ‘Aschura';

  @override
  String fastTomorrow(String name) {
    return 'Morgen: $name';
  }

  @override
  String get fastTomorrowBody =>
      'Eine Erinnerung für alle, die fasten möchten. Suhur vor Fadschr.';

  @override
  String get suhoorTitle => 'Suhur';

  @override
  String suhoorBody(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Fadschr in $minutes Minuten',
      one: 'Fadschr in 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get fastingReminders => 'Fasten';

  @override
  String get fastReminderTitle => 'Freiwilliges Fasten';

  @override
  String get fastReminderBody => 'Am Abend vor einem Sunna-Fasten.';

  @override
  String get suhoorReminderTitle => 'Suhur im Ramadan';

  @override
  String get suhoorReminderBody => 'Vor Fadschr, während des Ramadan.';

  @override
  String get iftarIn => 'Iftar in';

  @override
  String get suhoorEndsIn => 'Suhur endet in';

  @override
  String ramadanDay(int day) {
    return 'Ramadan · Tag $day';
  }

  @override
  String fastToday(String name) {
    return 'Heute: $name';
  }

  @override
  String iftarAt(String time) {
    return 'Iftar $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'Suhur bis $time';
  }

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get sourceCode => 'Quellcode (GPL-3.0)';
}
