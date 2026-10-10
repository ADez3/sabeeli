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
      'Les heures de prière et la qibla sont calculées sur votre téléphone à partir de votre position. Seule une position arrondie est envoyée à OpenStreetMap, pour afficher le nom de votre ville.';

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
  String get you => 'Vous';

  @override
  String get makkah => 'La Mecque';

  @override
  String get qiblaGreatCircle =>
      'La qibla suit le chemin le plus court sur la Terre, pas une ligne droite sur une carte plane.';

  @override
  String get globeView => 'Globe';

  @override
  String get compassView => 'Boussole';

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

  @override
  String get afterPrayer => 'Après la prière';

  @override
  String afterPrayerOf(String prayer) {
    return 'Après $prayer';
  }

  @override
  String get afterPrayerHint => 'Les adhkar après le salam, pas à pas';

  @override
  String get showTranslation => 'Traduction';

  @override
  String get turnTheBeads => 'Faites tourner les grains, ou touchez';

  @override
  String get doneStep => 'Terminé';

  @override
  String get previousStep => 'Précédent';

  @override
  String get skipStep => 'Passer';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rappels d’Allah',
      one: '1 rappel d’Allah',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer dans';
  }

  @override
  String atTime(String time) {
    return 'à $time';
  }

  @override
  String get nowLabel => 'Maintenant';

  @override
  String pageAyah(int page, int ayah) {
    return 'Page $page · Verset $ayah';
  }

  @override
  String get tasbihHint => 'Faites tourner les grains';

  @override
  String get azkarHint => 'Matin, soir et plus';

  @override
  String get ayahOfTheDay => 'Verset du jour';

  @override
  String get navToday => 'Aujourd’hui';

  @override
  String get navDhikr => 'Dhikr';

  @override
  String get riwayah => 'Riwaya';

  @override
  String get riwayahAuto => 'Automatique, selon la région';

  @override
  String get riwayahHafs => 'Hafs d’après ʿAsim';

  @override
  String get riwayahWarsh => 'Warsh d’après Nafiʿ';

  @override
  String get riwayahQalun => 'Qalun d’après Nafiʿ';

  @override
  String get riwayahHafsHint =>
      'Lue dans la plus grande partie du monde musulman';

  @override
  String get riwayahWarshHint =>
      'Maroc, Algérie, Mauritanie, Afrique de l’Ouest';

  @override
  String get riwayahQalunHint => 'Libye, Tunisie';

  @override
  String get riwayahNote =>
      'Chaque riwaya est affichée dans son propre mushaf du Complexe du Roi Fahd. Le tafsir et les traductions y sont alignés verset par verset.';

  @override
  String get general => 'Général';

  @override
  String get dhikrSubtitle => 'Rappelle-toi d’Allah, Il se rappelle de toi';

  @override
  String get qiblaSubtitle =>
      'La direction de la Kaaba depuis l’endroit où vous êtes';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get unitSeconds => 's';

  @override
  String get pageColour => 'Page';

  @override
  String get pageAuto => 'Auto';

  @override
  String get pageNight => 'Nuit';

  @override
  String get pageSepia => 'Sépia';

  @override
  String get pagePaper => 'Papier';

  @override
  String get welcomeTagline =>
      'La prière, le Coran et le rappel, sous le vrai ciel au-dessus de vous. Gratuit, privé, et à vous.';

  @override
  String get welcomeBegin => 'Commencer';

  @override
  String get welcomeNext => 'Suivant';

  @override
  String get welcomeStart => 'C’est parti';

  @override
  String get welcomePlaceTitle => 'Où êtes-vous ?';

  @override
  String get welcomeNotifyTitle => 'À chaque prière';

  @override
  String get welcomeNotifyBody =>
      'Une notification discrète, avec le son de votre téléphone, à l’heure de chaque prière. Réglable prière par prière.';

  @override
  String get welcomeNotifyAllow => 'Autoriser les notifications';

  @override
  String get welcomeNotifyOn => 'Notifications activées';

  @override
  String get welcomeExactAlarms => 'Les recevoir à la minute près';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'Le Coran s’ouvre en $riwayah. Modifiable dans les réglages.';
  }

  @override
  String get prepareSoon => 'Bientôt';

  @override
  String get prepareHint => 'le temps des ablutions';

  @override
  String get channelDaily => 'Rappels quotidiens';

  @override
  String get dailyReminders => 'Rappels quotidiens';

  @override
  String get dailyMorning => 'Adhkar du matin';

  @override
  String get dailyMorningBody =>
      'Quelques minutes de rappel pour commencer la journée.';

  @override
  String get dailyEvening => 'Adhkar du soir';

  @override
  String get dailyEveningBody => 'Les adhkar du soir, au déclin du jour.';

  @override
  String get dailySleep => 'Adhkar du coucher';

  @override
  String get dailySleepBody => 'Terminez la journée par le rappel.';

  @override
  String get dailyQuran => 'Votre lecture du jour';

  @override
  String get dailyQuranBody => 'Une page du Coran vous attend.';

  @override
  String get dailyRemindersIntro =>
      'Des rappels pour les adhkar et votre lecture quotidienne, à l’heure de votre choix. Ils sont facultatifs : la même notification chaque jour peut devenir pesante avec le temps. N’activez que ceux qui vous aident vraiment, et désactivez-les quand vous voulez.';

  @override
  String get dailyRemindersOff => 'Désactivés';

  @override
  String dailyRemindersOn(int count) {
    return '$count activés';
  }

  @override
  String get betaBadge => 'Bêta';

  @override
  String get betaTitle => 'Sabeeli est en bêta';

  @override
  String get betaBody =>
      'L’application est encore jeune. Ses textes, ses traductions et les informations qu’elle présente doivent encore être revus par des gens de science. Si vous remarquez une erreur, même un détail, dites-le-nous : chaque signalement aide.';

  @override
  String get betaShakeHint =>
      'Secouez votre téléphone sur n’importe quel écran pour signaler un problème, avec une capture.';

  @override
  String get betaUnderstood => 'J’ai compris';

  @override
  String get reportTitle => 'Signaler un problème';

  @override
  String get reportHint => 'Qu’est-ce qui ne va pas ? (facultatif)';

  @override
  String get reportSend => 'Envoyer par e-mail';

  @override
  String get reportAttach => 'Joindre la capture d’écran';

  @override
  String get reportPrivacy =>
      'Votre messagerie s’ouvre avec le signalement prêt. Rien n’est envoyé tant que vous n’appuyez pas sur envoyer.';

  @override
  String get reportNoMail =>
      'Aucune application de messagerie sur ce téléphone';

  @override
  String get shakeToReport => 'Secouer pour signaler un problème';

  @override
  String get khatmahPlan => 'Plan de khatma';

  @override
  String get planAKhatmah => 'Planifier une khatma';

  @override
  String khatmahDays(int days) {
    return '$days jours';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'Jour $day sur $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'Aujourd’hui : pages $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages restantes aujourd’hui',
      one: '1 page restante aujourd’hui',
    );
    return '$_temp0';
  }

  @override
  String get khatmahDone => 'La part du jour est lue';

  @override
  String khatmahPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Environ $count pages par jour',
      one: 'Environ 1 page par jour',
    );
    return '$_temp0';
  }

  @override
  String khatmahEnds(String date) {
    return 'fin le $date';
  }

  @override
  String get khatmahFromStart => 'Depuis le début';

  @override
  String khatmahFromHere(int page) {
    return 'Depuis la page $page';
  }

  @override
  String get khatmahStart => 'Commencer';

  @override
  String get khatmahEnd => 'Arrêter le plan';

  @override
  String get khatmahFinished => 'Khatma terminée. Qu’Allah l’accepte.';

  @override
  String readOnDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lu $count jours sur les 7 derniers',
      one: 'Lu 1 jour sur les 7 derniers',
    );
    return '$_temp0';
  }

  @override
  String get fastRamadan => 'Ramadan';

  @override
  String get fastMondayThursday => 'Lundis et jeudis';

  @override
  String get fastWhiteDays => 'Les jours blancs';

  @override
  String get fastArafah => 'Le jour de ‘Arafa';

  @override
  String get fastAshura => 'Tasu‘a et ‘Achoura';

  @override
  String fastTomorrow(String name) {
    return 'Demain : $name';
  }

  @override
  String get fastTomorrowBody =>
      'Un rappel pour qui souhaite jeûner. Le sahour avant le Fajr.';

  @override
  String get suhoorTitle => 'Sahour';

  @override
  String suhoorBody(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Fajr dans $minutes minutes',
      one: 'Fajr dans 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get fastingReminders => 'Jeûne';

  @override
  String get fastReminderTitle => 'Jeûnes surérogatoires';

  @override
  String get fastReminderBody => 'La veille d’un jeûne de la sunna.';

  @override
  String get suhoorReminderTitle => 'Sahour pendant le Ramadan';

  @override
  String get suhoorReminderBody => 'Avant le Fajr, pendant le Ramadan.';

  @override
  String get iftarIn => 'Iftar dans';

  @override
  String get suhoorEndsIn => 'Fin du sahour dans';

  @override
  String ramadanDay(int day) {
    return 'Ramadan · jour $day';
  }

  @override
  String fastToday(String name) {
    return 'Aujourd’hui : $name';
  }

  @override
  String iftarAt(String time) {
    return 'Iftar $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'Sahour jusqu’à $time';
  }

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get sourceCode => 'Code source (GPL-3.0)';
}
