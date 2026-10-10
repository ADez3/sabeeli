// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Votre chemin au quotidien';

  @override
  String get navHome => 'Accueil';

  @override
  String get navQuran => 'Coran';

  @override
  String get navPrayer => 'Prière';

  @override
  String get navAzkar => 'Adhkar';

  @override
  String get navMore => 'Plus';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Lever du soleil';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerJumuah => 'Joumou\'a';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Icha';

  @override
  String get midnight => 'Milieu de la nuit';

  @override
  String get lastThird => 'Dernier tiers de la nuit';

  @override
  String get salam => 'Assalamou alaykoum';

  @override
  String get nextPrayer => 'Prochaine prière';

  @override
  String prayerTimeNow(String prayer) {
    return 'C\'est l\'heure de $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'dans $duration';
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
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get prayerTimes => 'Horaires de prière';

  @override
  String get diveHint => 'Glissez vers le haut pour votre journée';

  @override
  String get now => 'Maintenant';

  @override
  String get yourDay => 'Votre journée';

  @override
  String get location => 'Localisation';

  @override
  String get setLocation => 'Définir votre localisation';

  @override
  String get setLocationHint =>
      'Les horaires de prière et la Qibla sont calculés selon l\'endroit où vous vous trouvez. Votre position ne quitte jamais votre appareil.';

  @override
  String get useCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get searchCity => 'Rechercher une ville';

  @override
  String get searchCityHint => 'Nom de la ville';

  @override
  String get locating => 'Recherche de votre position…';

  @override
  String get locationDisabled =>
      'Les services de localisation sont désactivés.';

  @override
  String get locationDenied => 'L\'autorisation de localisation a été refusée.';

  @override
  String get locationDeniedForever =>
      'L\'autorisation de localisation est bloquée. Autorisez-la dans les paramètres de l\'application.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get unknownPlace => 'Position actuelle';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get networkError =>
      'Pas de connexion. Vérifiez votre accès à Internet et réessayez.';

  @override
  String get genericError => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get retry => 'Réessayer';

  @override
  String get calculation => 'Calcul';

  @override
  String get calculationMethod => 'Méthode de calcul';

  @override
  String get asrMethod => 'Heure de l\'Asr';

  @override
  String get asrStandard => 'Standard (chaféite, malékite, hanbalite)';

  @override
  String get asrHanafi => 'Hanafite';

  @override
  String get highLatitudeRule => 'Règle des hautes latitudes';

  @override
  String get highLatMiddle => 'Milieu de la nuit';

  @override
  String get highLatSeventh => 'Un septième de la nuit';

  @override
  String get highLatAngle => 'Angle du crépuscule';

  @override
  String get highLatNone => 'Aucune';

  @override
  String get adjustments => 'Ajustements manuels';

  @override
  String get adjustmentsHint =>
      'Ajoutez ou retirez des minutes pour correspondre à votre mosquée locale.';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get methodMuslimWorldLeague => 'Ligue islamique mondiale';

  @override
  String get methodEgyptian => 'Autorité générale égyptienne de géodésie';

  @override
  String get methodKarachi => 'Université des sciences islamiques, Karachi';

  @override
  String get methodUmmAlQura => 'Umm al-Qura, La Mecque';

  @override
  String get methodDubai => 'Dubaï';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodKuwait => 'Koweït';

  @override
  String get methodNorthAmerica => 'Islamic Society of North America (ISNA)';

  @override
  String get methodSingapore => 'Singapour (MUIS)';

  @override
  String get methodTurkey => 'Diyanet, Turquie';

  @override
  String get methodTehran => 'Institut de géophysique, Téhéran';

  @override
  String get methodFrance => 'France (UOIF, 12°)';

  @override
  String get methodRussia => 'Direction spirituelle des musulmans de Russie';

  @override
  String get methodMorocco => 'Ministère des Habous, Maroc';

  @override
  String get methodAlgeria => 'Ministère des Affaires religieuses, Algérie';

  @override
  String get methodTunisia => 'Tunisie';

  @override
  String get methodJordan => 'Ministère des Awqaf, Jordanie';

  @override
  String get methodIndonesia => 'Kemenag, Indonésie';

  @override
  String get methodMalaysia => 'JAKIM, Malaisie';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSound => 'Son de notification';

  @override
  String get notificationSilent => 'Silencieux';

  @override
  String get notificationOff => 'Désactivé';

  @override
  String get reminderBefore => 'Rappel avant';

  @override
  String get reminderOff => 'Aucun rappel';

  @override
  String minutesBefore(int minutes) {
    return '$minutes min avant';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'C\'est l\'heure de la prière de $prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer dans $minutes minutes';
  }

  @override
  String get notificationsBlocked =>
      'Les notifications sont désactivées pour Sabeeli.';

  @override
  String get exactAlarmsNeeded =>
      'Autorisez « Alarmes et rappels » pour que les notifications de prière arrivent à l\'heure exacte.';

  @override
  String get allow => 'Autoriser';

  @override
  String get channelSilent => 'Notifications de prière silencieuses';

  @override
  String get channelPrayer => 'Horaires de prière';

  @override
  String get channelReminder => 'Rappels de prière';

  @override
  String get qibla => 'Qibla';

  @override
  String get qiblaDirection => 'Direction de la Qibla';

  @override
  String get facingQibla => 'Vous êtes face à la Qibla';

  @override
  String get turnTowards =>
      'Tournez jusqu\'à ce que la flèche pointe vers le haut';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° depuis le nord';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance km jusqu\'à la Kaaba';
  }

  @override
  String get calibrateCompass =>
      'La précision de la boussole est faible. Décrivez un huit avec votre téléphone pour l\'étalonner.';

  @override
  String get compassUnavailable =>
      'Cet appareil n\'a pas de boussole. Utilisez l\'orientation ci-dessous avec une boussole physique.';

  @override
  String get qiblaNeedsLocation =>
      'Définissez votre localisation pour trouver la Qibla.';

  @override
  String get quran => 'Le Saint Coran';

  @override
  String get surahs => 'Sourates';

  @override
  String get juzs => 'Juz';

  @override
  String get bookmarks => 'Signets';

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
      other: '$count versets',
      one: '1 verset',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, verset $ayah';
  }

  @override
  String get meccan => 'Mecquoise';

  @override
  String get medinan => 'Médinoise';

  @override
  String get continueReading => 'Reprendre la lecture';

  @override
  String get startReading => 'Commencer la lecture';

  @override
  String get lastRead => 'Dernière lecture';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get tafsirMuyassar => 'Tafsir al-Muyassar';

  @override
  String get translation => 'Traduction';

  @override
  String get copy => 'Copier';

  @override
  String get share => 'Partager';

  @override
  String get copied => 'Copié';

  @override
  String get bookmark => 'Ajouter un signet';

  @override
  String get removeBookmark => 'Retirer le signet';

  @override
  String get bookmarkAdded => 'Signet ajouté';

  @override
  String get bookmarkRemoved => 'Signet retiré';

  @override
  String get setAsLastRead => 'Marquer là où je me suis arrêté';

  @override
  String get lastReadSaved => 'Position de lecture enregistrée';

  @override
  String get noBookmarks =>
      'Aucun signet pour l\'instant. Touchez un verset pendant la lecture pour l\'ajouter.';

  @override
  String get fontSize => 'Taille du texte';

  @override
  String get searchSurah => 'Rechercher une sourate';

  @override
  String get sajda => 'Sajda';

  @override
  String get translationUnavailable =>
      'Cette traduction n\'est pas encore téléchargée.';

  @override
  String get download => 'Télécharger';

  @override
  String get downloading => 'Téléchargement…';

  @override
  String get translationLanguage => 'Langue de la traduction';

  @override
  String get noTranslation => 'Aucune';

  @override
  String get readerSettings => 'Paramètres de lecture';

  @override
  String get dailyAyah => 'Verset du jour';

  @override
  String get skyView => 'Ciel';

  @override
  String get listView => 'Liste';

  @override
  String khatmahProgress(int percent) {
    return '$percent % du Coran lu';
  }

  @override
  String get skyHint =>
      'Chaque étoile est une sourate. Elle brille davantage à mesure que vous la lisez.';

  @override
  String revelationOrder(int order) {
    return 'Révélée ${order}e sur 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'Pages $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent % lu';
  }

  @override
  String get openSurah => 'Ouvrir';

  @override
  String get azkar => 'Adhkar';

  @override
  String get azkarMorning => 'Adhkar du matin';

  @override
  String get azkarEvening => 'Adhkar du soir';

  @override
  String get azkarAfterPrayer => 'Après la prière';

  @override
  String get azkarSleep => 'Avant de dormir';

  @override
  String get azkarWaking => 'Au réveil';

  @override
  String get allCategories => 'Toutes les invocations';

  @override
  String get tapToCount => 'Touchez pour compter';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois',
      two: 'Deux fois',
      one: 'Une fois',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Terminé';

  @override
  String get azkarDone => 'Qu\'Allah accepte de vous';

  @override
  String get restart => 'Recommencer';

  @override
  String progressOf(int done, int total) {
    return '$done sur $total';
  }

  @override
  String get source => 'Source';

  @override
  String get virtue => 'Mérite';

  @override
  String get searchAzkar => 'Rechercher une invocation';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invocations',
      one: '1 invocation',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get target => 'Objectif';

  @override
  String get noTarget => 'Sans limite';

  @override
  String totalCount(int count) {
    return 'Total : $count';
  }

  @override
  String rounds(int count) {
    return 'Tours : $count';
  }

  @override
  String get vibration => 'Vibration';

  @override
  String get more => 'Plus';

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get numerals => 'Chiffres';

  @override
  String get numeralsAuto => 'Automatique (selon la région)';

  @override
  String get numeralsWestern => 'Occidentaux';

  @override
  String get numeralsArabic => 'Arabes orientaux';

  @override
  String get numeralsPersian => 'Persans / ourdous';

  @override
  String get hijriCalendar => 'Calendrier hégirien';

  @override
  String get hijriCalendarHint =>
      'Les pays ne s\'accordent pas toujours sur le début d\'un mois. Ajustez le calendrier pour suivre l\'annonce locale.';

  @override
  String get hijriMethod => 'Calendrier';

  @override
  String get hijriUmmAlQura => 'Umm al-Qura (Arabie saoudite)';

  @override
  String get hijriTabular => 'Arithmétique (algorithme koweïtien)';

  @override
  String get hijriOffset => 'Décaler tous les mois';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '1 jour',
      zero: 'Aucun décalage',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'Ce mois-ci';

  @override
  String hijriMonthStartedOn(String month) {
    return 'Début de $month';
  }

  @override
  String get hijriAutomatic => 'Automatique';

  @override
  String get hijriResetAll => 'Réinitialiser toutes les corrections';

  @override
  String get hijriCorrections => 'Corrections des mois';

  @override
  String get hijriYearSuffix => 'H';

  @override
  String get hijriMonth1 => 'Mouharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabi\' al-Awwal';

  @override
  String get hijriMonth4 => 'Rabi\' al-Thani';

  @override
  String get hijriMonth5 => 'Joumada al-Oula';

  @override
  String get hijriMonth6 => 'Joumada al-Akhira';

  @override
  String get hijriMonth7 => 'Rajab';

  @override
  String get hijriMonth8 => 'Cha\'bane';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Chawwal';

  @override
  String get hijriMonth11 => 'Dhou al-Qi\'da';

  @override
  String get hijriMonth12 => 'Dhou al-Hijja';

  @override
  String get eidAlFitr => 'Aïd al-Fitr';

  @override
  String get eidAlAdha => 'Aïd al-Adha';

  @override
  String get dayOfArafah => 'Jour d\'Arafat';

  @override
  String get ashura => 'Achoura';

  @override
  String get islamicNewYear => 'Nouvel an hégirien';

  @override
  String get whiteDays => 'Jours blancs';

  @override
  String get ramadanBegins => 'Début du Ramadan';

  @override
  String get about => 'À propos';

  @override
  String get aboutText =>
      'Sabeeli est un compagnon gratuit pour la vie quotidienne du musulman. Il fonctionne hors ligne, sans publicité, et ne collecte aucune donnée.';

  @override
  String get credits => 'Sources et remerciements';

  @override
  String version(String version) {
    return 'Version $version';
  }
}
