// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'আপনার প্রতিদিনের পথ';

  @override
  String get navHome => 'হোম';

  @override
  String get navQuran => 'কুরআন';

  @override
  String get navPrayer => 'নামাজ';

  @override
  String get navAzkar => 'আযকার';

  @override
  String get navMore => 'আরও';

  @override
  String get prayerFajr => 'ফজর';

  @override
  String get prayerSunrise => 'সূর্যোদয়';

  @override
  String get prayerDhuhr => 'যোহর';

  @override
  String get prayerJumuah => 'জুমা';

  @override
  String get prayerAsr => 'আসর';

  @override
  String get prayerMaghrib => 'মাগরিব';

  @override
  String get prayerIsha => 'এশা';

  @override
  String get midnight => 'মধ্যরাত';

  @override
  String get lastThird => 'রাতের শেষ তৃতীয়াংশ';

  @override
  String get salam => 'আসসালামু আলাইকুম';

  @override
  String get nextPrayer => 'পরবর্তী নামাজ';

  @override
  String prayerTimeNow(String prayer) {
    return '$prayer-এর সময় হয়েছে';
  }

  @override
  String timeUntil(String duration) {
    return '$duration পর';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ঘণ্টা $minutes মিনিট';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get today => 'আজ';

  @override
  String get tomorrow => 'আগামীকাল';

  @override
  String get prayerTimes => 'নামাজের সময়';

  @override
  String get diveHint => 'আপনার দিন দেখতে উপরে সোয়াইপ করুন';

  @override
  String get now => 'এখন';

  @override
  String get yourDay => 'আপনার দিন';

  @override
  String get location => 'অবস্থান';

  @override
  String get setLocation => 'আপনার অবস্থান দিন';

  @override
  String get setLocationHint =>
      'নামাজের সময় ও কিবলা আপনার ফোনেই, আপনার অবস্থান থেকে হিসাব করা হয়। শুধু আপনার শহরের নাম জানতে একটি আনুমানিক অবস্থান OpenStreetMap-এ পাঠানো হয়।';

  @override
  String get useCurrentLocation => 'আমার বর্তমান অবস্থান ব্যবহার করুন';

  @override
  String get searchCity => 'শহর খুঁজুন';

  @override
  String get searchCityHint => 'শহরের নাম';

  @override
  String get locating => 'আপনার অবস্থান খোঁজা হচ্ছে…';

  @override
  String get locationDisabled => 'লোকেশন সার্ভিস বন্ধ আছে।';

  @override
  String get locationDenied => 'লোকেশনের অনুমতি দেওয়া হয়নি।';

  @override
  String get locationDeniedForever =>
      'লোকেশনের অনুমতি বন্ধ করা আছে। অ্যাপের সেটিংস থেকে অনুমতি দিন।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get unknownPlace => 'বর্তমান অবস্থান';

  @override
  String get noResults => 'কোনো ফলাফল নেই';

  @override
  String get networkError => 'সংযোগ নেই। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get genericError => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get retry => 'আবার চেষ্টা';

  @override
  String get calculation => 'হিসাব';

  @override
  String get calculationMethod => 'হিসাবের পদ্ধতি';

  @override
  String get asrMethod => 'আসরের সময়';

  @override
  String get asrStandard => 'সাধারণ (শাফেয়ি, মালেকি, হাম্বলি)';

  @override
  String get asrHanafi => 'হানাফি';

  @override
  String get highLatitudeRule => 'উচ্চ অক্ষাংশের নিয়ম';

  @override
  String get highLatMiddle => 'রাতের মাঝামাঝি';

  @override
  String get highLatSeventh => 'রাতের এক-সপ্তমাংশ';

  @override
  String get highLatAngle => 'গোধূলির কোণ';

  @override
  String get highLatNone => 'কোনোটি নয়';

  @override
  String get adjustments => 'নিজে সমন্বয়';

  @override
  String get adjustmentsHint =>
      'আপনার এলাকার মসজিদের সাথে মেলাতে মিনিট যোগ বা বাদ দিন।';

  @override
  String get hourShift => 'ঘণ্টা সংশোধন';

  @override
  String get hourShiftHint =>
      'শুধু তখনই, যখন সব সময় পুরো ঘণ্টা হিসেবে ভুল দেখায়: আপনার ফোনের টাইম জোন ভুল (যেমন, দেশ সময় বদলানোর পরও GMT+1-এ রয়ে গেছে)। ফোনে সঠিক টাইম জোন দেওয়াই ভালো।';

  @override
  String hoursShort(int hours) {
    return '$hours ঘণ্টা';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get methodMuslimWorldLeague => 'মুসলিম ওয়ার্ল্ড লীগ';

  @override
  String get methodEgyptian => 'মিশরীয় জেনারেল অথরিটি অব সার্ভে';

  @override
  String get methodKarachi => 'ইউনিভার্সিটি অব ইসলামিক সায়েন্সেস, করাচি';

  @override
  String get methodUmmAlQura => 'উম্মুল কুরা, মক্কা';

  @override
  String get methodDubai => 'দুবাই';

  @override
  String get methodQatar => 'কাতার';

  @override
  String get methodKuwait => 'কুয়েত';

  @override
  String get methodNorthAmerica => 'ইসলামিক সোসাইটি অব নর্থ আমেরিকা (ISNA)';

  @override
  String get methodSingapore => 'সিঙ্গাপুর (MUIS)';

  @override
  String get methodTurkey => 'দিয়ানাত, তুরস্ক';

  @override
  String get methodTehran => 'ইনস্টিটিউট অব জিওফিজিক্স, তেহরান';

  @override
  String get methodFrance => 'ফ্রান্স (UOIF, 12°)';

  @override
  String get methodRussia => 'রাশিয়ার মুসলিমদের আধ্যাত্মিক প্রশাসন';

  @override
  String get methodMorocco => 'হাবুস মন্ত্রণালয়, মরক্কো';

  @override
  String get methodAlgeria => 'ধর্মবিষয়ক মন্ত্রণালয়, আলজেরিয়া';

  @override
  String get methodTunisia => 'তিউনিসিয়া';

  @override
  String get methodJordan => 'আওকাফ মন্ত্রণালয়, জর্ডান';

  @override
  String get methodIndonesia => 'কেমেনাগ, ইন্দোনেশিয়া';

  @override
  String get methodMalaysia => 'জাকিম, মালয়েশিয়া';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get notificationSound => 'নোটিফিকেশনের শব্দ';

  @override
  String get notificationSilent => 'নীরব';

  @override
  String get notificationOff => 'বন্ধ';

  @override
  String get reminderBefore => 'আগে মনে করানো';

  @override
  String get reminderOff => 'মনে করানো নয়';

  @override
  String minutesBefore(int minutes) {
    return '$minutes মিনিট আগে';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return '$prayer নামাজের সময় হয়েছে';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$minutes মিনিট পর $prayer';
  }

  @override
  String get notificationsBlocked => 'Sabeeli-এর নোটিফিকেশন বন্ধ আছে।';

  @override
  String get exactAlarmsNeeded =>
      'নামাজের নোটিফিকেশন ঠিক সময়ে পেতে \"অ্যালার্ম ও রিমাইন্ডার\" চালু করুন।';

  @override
  String get allow => 'অনুমতি দিন';

  @override
  String get channelSilent => 'নীরব নামাজের নোটিফিকেশন';

  @override
  String get channelPrayer => 'নামাজের সময়';

  @override
  String get channelReminder => 'নামাজের রিমাইন্ডার';

  @override
  String get qibla => 'কিবলা';

  @override
  String get qiblaDirection => 'কিবলার দিক';

  @override
  String get facingQibla => 'আপনি কিবলামুখী আছেন';

  @override
  String get turnTowards => 'তীর উপরের দিকে না আসা পর্যন্ত ঘুরুন';

  @override
  String degreesFromNorth(String degrees) {
    return 'উত্তর থেকে $degrees°';
  }

  @override
  String distanceToKaaba(String distance) {
    return 'কাবা পর্যন্ত $distance কিমি';
  }

  @override
  String get calibrateCompass =>
      'কম্পাসের নির্ভুলতা কম। ঠিক করতে ফোনটি 8-এর মতো করে ঘোরান।';

  @override
  String get compassUnavailable =>
      'এই ডিভাইসে কম্পাস নেই। নিচের দিকনির্দেশটি একটি সাধারণ কম্পাসের সাথে ব্যবহার করুন।';

  @override
  String get qiblaNeedsLocation => 'কিবলা খুঁজতে আপনার অবস্থান দিন।';

  @override
  String get you => 'আপনি';

  @override
  String get makkah => 'মক্কা';

  @override
  String get qiblaGreatCircle =>
      'কিবলা পৃথিবীর ওপর দিয়ে সবচেয়ে ছোট পথ ধরে চলে, সমতল মানচিত্রের সোজা রেখা ধরে নয়।';

  @override
  String get globeView => 'গ্লোব';

  @override
  String get compassView => 'কম্পাস';

  @override
  String get quran => 'আল-কুরআনুল কারীম';

  @override
  String get surahs => 'সূরা';

  @override
  String get juzs => 'পারা';

  @override
  String get bookmarks => 'বুকমার্ক';

  @override
  String juzNumber(int number) {
    return 'পারা $number';
  }

  @override
  String pageNumber(int number) {
    return 'পৃষ্ঠা $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি আয়াত',
      one: '1টি আয়াত',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, আয়াত $ayah';
  }

  @override
  String get meccan => 'মাক্কী';

  @override
  String get medinan => 'মাদানী';

  @override
  String get continueReading => 'পড়া চালিয়ে যান';

  @override
  String get startReading => 'পড়া শুরু করুন';

  @override
  String get lastRead => 'সর্বশেষ পড়া';

  @override
  String get tafsir => 'তাফসীর';

  @override
  String get tafsirMuyassar => 'তাফসীর আল-মুয়াসসার';

  @override
  String get translation => 'অনুবাদ';

  @override
  String get copy => 'কপি';

  @override
  String get share => 'শেয়ার';

  @override
  String get copied => 'কপি হয়েছে';

  @override
  String get bookmark => 'বুকমার্ক';

  @override
  String get removeBookmark => 'বুকমার্ক সরান';

  @override
  String get bookmarkAdded => 'বুকমার্ক যোগ হয়েছে';

  @override
  String get bookmarkRemoved => 'বুকমার্ক সরানো হয়েছে';

  @override
  String get setAsLastRead => 'এখানে থেমেছি বলে চিহ্নিত করুন';

  @override
  String get lastReadSaved => 'পড়ার স্থান সংরক্ষিত হয়েছে';

  @override
  String get noBookmarks =>
      'এখনো কোনো বুকমার্ক নেই। পড়ার সময় কোনো আয়াতে ট্যাপ করে বুকমার্ক করুন।';

  @override
  String get fontSize => 'লেখার আকার';

  @override
  String get searchSurah => 'সূরা খুঁজুন';

  @override
  String get sajda => 'সিজদা';

  @override
  String get translationUnavailable => 'এই অনুবাদটি এখনো ডাউনলোড করা হয়নি।';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get downloading => 'ডাউনলোড হচ্ছে…';

  @override
  String get translationLanguage => 'অনুবাদের ভাষা';

  @override
  String get noTranslation => 'কোনোটি নয়';

  @override
  String get readerSettings => 'পড়ার সেটিংস';

  @override
  String get dailyAyah => 'আজকের আয়াত';

  @override
  String get skyView => 'আকাশ';

  @override
  String get listView => 'তালিকা';

  @override
  String khatmahProgress(int percent) {
    return 'কুরআনের $percent% পড়া হয়েছে';
  }

  @override
  String get skyHint =>
      'প্রতিটি তারা একটি সূরা। আপনি যত পড়বেন, তা তত উজ্জ্বল হবে।';

  @override
  String revelationOrder(int order) {
    return '114টির মধ্যে $orderতম নাযিল';
  }

  @override
  String pagesRange(int from, int to) {
    return 'পৃষ্ঠা $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent% পড়া হয়েছে';
  }

  @override
  String get openSurah => 'খুলুন';

  @override
  String get azkar => 'আযকার';

  @override
  String get azkarMorning => 'সকালের আযকার';

  @override
  String get azkarEvening => 'সন্ধ্যার আযকার';

  @override
  String get azkarAfterPrayer => 'নামাজের পর';

  @override
  String get azkarSleep => 'ঘুমানোর আগে';

  @override
  String get azkarWaking => 'ঘুম থেকে উঠে';

  @override
  String get allCategories => 'সব দোয়া';

  @override
  String get tapToCount => 'গুনতে ট্যাপ করুন';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count বার',
      two: 'দুইবার',
      one: 'একবার',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'সম্পন্ন';

  @override
  String get azkarDone => 'আল্লাহ আপনার পক্ষ থেকে কবুল করুন';

  @override
  String get restart => 'আবার শুরু';

  @override
  String progressOf(int done, int total) {
    return '$total-এর মধ্যে $done';
  }

  @override
  String get source => 'সূত্র';

  @override
  String get virtue => 'ফজিলত';

  @override
  String get searchAzkar => 'দোয়া খুঁজুন';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি দোয়া',
      one: '1টি দোয়া',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'তাসবিহ';

  @override
  String get reset => 'রিসেট';

  @override
  String get target => 'লক্ষ্য';

  @override
  String get noTarget => 'সীমা নেই';

  @override
  String totalCount(int count) {
    return 'মোট: $count';
  }

  @override
  String rounds(int count) {
    return 'চক্র: $count';
  }

  @override
  String get vibration => 'ভাইব্রেশন';

  @override
  String get more => 'আরও';

  @override
  String get settings => 'সেটিংস';

  @override
  String get appearance => 'চেহারা';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeLight => 'লাইট';

  @override
  String get language => 'ভাষা';

  @override
  String get systemLanguage => 'সিস্টেমের ভাষা';

  @override
  String get numerals => 'সংখ্যা';

  @override
  String get numeralsAuto => 'স্বয়ংক্রিয় (অঞ্চল অনুযায়ী)';

  @override
  String get numeralsWestern => 'পশ্চিমা';

  @override
  String get numeralsArabic => 'আরবি (পূর্বী)';

  @override
  String get numeralsPersian => 'ফারসি / উর্দু';

  @override
  String get hijriCalendar => 'হিজরি ক্যালেন্ডার';

  @override
  String get hijriCalendarHint =>
      'মাস কবে শুরু হবে, সে বিষয়ে সব দেশ সবসময় একমত হয় না। আপনার স্থানীয় ঘোষণা অনুযায়ী ক্যালেন্ডার ঠিক করে নিন।';

  @override
  String get hijriMethod => 'ক্যালেন্ডার';

  @override
  String get hijriUmmAlQura => 'উম্মুল কুরা (সৌদি আরব)';

  @override
  String get hijriTabular => 'গাণিতিক (কুয়েতি পদ্ধতি)';

  @override
  String get hijriOffset => 'সব মাস সরান';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days দিন',
      one: '1 দিন',
      zero: 'সরানো হয়নি',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'এই মাস';

  @override
  String hijriMonthStartedOn(String month) {
    return '$month-এর শুরু';
  }

  @override
  String get hijriAutomatic => 'স্বয়ংক্রিয়';

  @override
  String get hijriResetAll => 'সব সংশোধন মুছুন';

  @override
  String get hijriCorrections => 'মাসের সংশোধন';

  @override
  String get hijriYearSuffix => 'হিজরি';

  @override
  String get hijriMonth1 => 'মুহাররম';

  @override
  String get hijriMonth2 => 'সফর';

  @override
  String get hijriMonth3 => 'রবিউল আউয়াল';

  @override
  String get hijriMonth4 => 'রবিউস সানি';

  @override
  String get hijriMonth5 => 'জমাদিউল আউয়াল';

  @override
  String get hijriMonth6 => 'জমাদিউস সানি';

  @override
  String get hijriMonth7 => 'রজব';

  @override
  String get hijriMonth8 => 'শাবান';

  @override
  String get hijriMonth9 => 'রমজান';

  @override
  String get hijriMonth10 => 'শাওয়াল';

  @override
  String get hijriMonth11 => 'জিলকদ';

  @override
  String get hijriMonth12 => 'জিলহজ';

  @override
  String get eidAlFitr => 'ঈদুল ফিতর';

  @override
  String get eidAlAdha => 'ঈদুল আযহা';

  @override
  String get dayOfArafah => 'আরাফার দিন';

  @override
  String get ashura => 'আশুরা';

  @override
  String get islamicNewYear => 'হিজরি নববর্ষ';

  @override
  String get whiteDays => 'আইয়ামে বীয';

  @override
  String get ramadanBegins => 'রমজান শুরু';

  @override
  String get about => 'পরিচিতি';

  @override
  String get aboutText =>
      'Sabeeli একজন মুসলিমের দৈনন্দিন জীবনের একটি বিনামূল্যের সঙ্গী। এটি অফলাইনে চলে, এতে কোনো বিজ্ঞাপন নেই এবং কোনো তথ্য সংগ্রহ করে না।';

  @override
  String get credits => 'সূত্র ও কৃতজ্ঞতা';

  @override
  String version(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get afterPrayer => 'নামাজের পর';

  @override
  String afterPrayerOf(String prayer) {
    return '$prayer-এর পর';
  }

  @override
  String get afterPrayerHint => 'সালামের পরের আযকার, ধাপে ধাপে';

  @override
  String get showTranslation => 'অনুবাদ';

  @override
  String get turnTheBeads => 'দানা ঘোরান, অথবা ট্যাপ করুন';

  @override
  String get doneStep => 'হয়েছে';

  @override
  String get previousStep => 'আগের';

  @override
  String get skipStep => 'বাদ দিন';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আল্লাহর $countটি যিকির',
      one: 'আল্লাহর 1টি যিকির',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer বাকি';
  }

  @override
  String atTime(String time) {
    return '$time-এ';
  }

  @override
  String get nowLabel => 'এখন';

  @override
  String pageAyah(int page, int ayah) {
    return 'পৃষ্ঠা $page · আয়াত $ayah';
  }

  @override
  String get tasbihHint => 'দানা ঘোরান';

  @override
  String get azkarHint => 'সকাল, সন্ধ্যা ও আরও';

  @override
  String get ayahOfTheDay => 'আজকের আয়াত';

  @override
  String get navToday => 'আজ';

  @override
  String get navDhikr => 'যিকির';

  @override
  String get riwayah => 'রিওয়ায়াত';

  @override
  String get riwayahAuto => 'স্বয়ংক্রিয়, অঞ্চল অনুযায়ী';

  @override
  String get riwayahHafs => 'হাফস, আসিম থেকে';

  @override
  String get riwayahWarsh => 'ওয়ারশ, নাফি থেকে';

  @override
  String get riwayahQalun => 'কালুন, নাফি থেকে';

  @override
  String get riwayahHafsHint => 'মুসলিম বিশ্বের বেশিরভাগ অঞ্চলে পড়া হয়';

  @override
  String get riwayahWarshHint =>
      'মরক্কো, আলজেরিয়া, মৌরিতানিয়া, পশ্চিম আফ্রিকা';

  @override
  String get riwayahQalunHint => 'লিবিয়া, তিউনিসিয়া';

  @override
  String get riwayahNote =>
      'প্রতিটি রিওয়ায়াত বাদশাহ ফাহাদ কমপ্লেক্সের নিজস্ব মুসহাফে দেখানো হয়। তাফসীর ও অনুবাদ আয়াত ধরে ধরে এর সাথে মেলানো হয়।';

  @override
  String get general => 'সাধারণ';

  @override
  String get dhikrSubtitle => 'আল্লাহকে স্মরণ করুন, তিনিও আপনাকে স্মরণ করবেন';

  @override
  String get qiblaSubtitle => 'আপনার অবস্থান থেকে কাবার দিক';

  @override
  String get unitHours => 'ঘ';

  @override
  String get unitMinutes => 'মি';

  @override
  String get unitSeconds => 'সে';

  @override
  String get pageColour => 'পৃষ্ঠা';

  @override
  String get pageAuto => 'অটো';

  @override
  String get pageNight => 'রাত';

  @override
  String get pageSepia => 'সেপিয়া';

  @override
  String get pagePaper => 'কাগজ';

  @override
  String get welcomeTagline =>
      'নামাজ, কুরআন ও যিকির, আপনার মাথার ওপরের সত্যিকারের আকাশের নিচে। বিনামূল্যে, ব্যক্তিগত, একান্ত আপনার।';

  @override
  String get welcomeBegin => 'শুরু করুন';

  @override
  String get welcomeNext => 'পরবর্তী';

  @override
  String get welcomeStart => 'শুরু';

  @override
  String get welcomePlaceTitle => 'আপনি কোথায় আছেন?';

  @override
  String get welcomeNotifyTitle => 'প্রতিটি নামাজে';

  @override
  String get welcomeNotifyBody =>
      'প্রতিটি নামাজের সময় হলে আপনার ফোনের নিজস্ব শব্দে একটি মৃদু নোটিফিকেশন। পরে প্রতিটি নামাজের জন্য আলাদাভাবে বেছে নিতে পারবেন।';

  @override
  String get welcomeNotifyAllow => 'নোটিফিকেশনের অনুমতি দিন';

  @override
  String get welcomeNotifyOn => 'নোটিফিকেশন চালু আছে';

  @override
  String get welcomeExactAlarms => 'ঠিক মিনিটে আসতে দিন';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'কুরআন $riwayah রিওয়ায়াতে খুলবে। সেটিংস থেকে এটি বদলাতে পারবেন।';
  }

  @override
  String get prepareSoon => 'শীঘ্রই';

  @override
  String get prepareHint => 'অযুর সময়';

  @override
  String get channelDaily => 'দৈনিক রিমাইন্ডার';

  @override
  String get dailyReminders => 'দৈনিক রিমাইন্ডার';

  @override
  String get dailyMorning => 'সকালের আযকার';

  @override
  String get dailyMorningBody => 'দিন শুরু করতে কয়েক মিনিটের যিকির।';

  @override
  String get dailyEvening => 'সন্ধ্যার আযকার';

  @override
  String get dailyEveningBody => 'দিন শেষ হয়ে আসছে, সন্ধ্যার আযকারের সময়।';

  @override
  String get dailySleep => 'ঘুমানোর আগের আযকার';

  @override
  String get dailySleepBody => 'যিকিরের মাধ্যমে দিন শেষ করুন।';

  @override
  String get dailyQuran => 'আপনার প্রতিদিনের তিলাওয়াত';

  @override
  String get dailyQuranBody => 'কুরআনের একটি পৃষ্ঠা আপনার অপেক্ষায়।';

  @override
  String get dailyRemindersIntro =>
      'আযকার ও প্রতিদিনের তিলাওয়াতের জন্য রিমাইন্ডার, আপনার পছন্দের সময়ে। এগুলো ঐচ্ছিক: প্রতিদিন একই নোটিফিকেশন কিছুদিন পর বিরক্তিকর হয়ে উঠতে পারে, তাই যেগুলো সত্যিই আপনার উপকারে আসে শুধু সেগুলো চালু করুন, আর যখন খুশি বন্ধ করে দিন।';

  @override
  String get dailyRemindersOff => 'বন্ধ';

  @override
  String dailyRemindersOn(int count) {
    return '$countটি চালু';
  }

  @override
  String get betaBadge => 'বেটা';

  @override
  String get betaTitle => 'Sabeeli এখন বেটা পর্যায়ে';

  @override
  String get betaBody =>
      'অ্যাপটি এখনো নতুন। এর লেখা, অনুবাদ ও দেখানো তথ্য এখনো আলেমদের দ্বারা যাচাই করা প্রয়োজন। কোনো ভুল চোখে পড়লে, ছোটখাটো হলেও, অনুগ্রহ করে আমাদের জানান: প্রতিটি রিপোর্টই কাজে আসে।';

  @override
  String get betaShakeHint =>
      'যেকোনো স্ক্রিনে ফোন ঝাঁকিয়ে স্ক্রিনশটসহ সমস্যা জানান।';

  @override
  String get betaUnderstood => 'বুঝেছি';

  @override
  String get reportTitle => 'সমস্যা জানান';

  @override
  String get reportHint => 'কী ভুল হয়েছে? (ঐচ্ছিক)';

  @override
  String get reportSend => 'ইমেইলে পাঠান';

  @override
  String get reportAttach => 'স্ক্রিনশট যুক্ত করুন';

  @override
  String get reportPrivacy =>
      'রিপোর্ট প্রস্তুত অবস্থায় আপনার মেইল অ্যাপ খুলবে। সেখানে পাঠান না চাপা পর্যন্ত কিছুই পাঠানো হবে না।';

  @override
  String get reportNoMail => 'এই ফোনে কোনো ইমেইল অ্যাপ পাওয়া যায়নি';

  @override
  String get shakeToReport => 'ঝাঁকিয়ে সমস্যা জানান';

  @override
  String get khatmahPlan => 'খতমের পরিকল্পনা';

  @override
  String get planAKhatmah => 'খতমের পরিকল্পনা করুন';

  @override
  String khatmahDays(int days) {
    return '$days দিন';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return '$days দিনের মধ্যে $dayতম দিন';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'আজ: পৃষ্ঠা $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আজ $count পৃষ্ঠা বাকি',
      one: 'আজ 1 পৃষ্ঠা বাকি',
    );
    return '$_temp0';
  }

  @override
  String get khatmahDone => 'আজকের অংশ শেষ হয়েছে';

  @override
  String khatmahPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'দিনে প্রায় $count পৃষ্ঠা',
      one: 'দিনে প্রায় 1 পৃষ্ঠা',
    );
    return '$_temp0';
  }

  @override
  String khatmahEnds(String date) {
    return 'শেষ হবে $date';
  }

  @override
  String get khatmahFromStart => 'শুরু থেকে';

  @override
  String khatmahFromHere(int page) {
    return 'পৃষ্ঠা $page থেকে';
  }

  @override
  String get khatmahStart => 'পরিকল্পনা শুরু করুন';

  @override
  String get khatmahEnd => 'পরিকল্পনা শেষ করুন';

  @override
  String get khatmahFinished => 'খতম সম্পন্ন হয়েছে। আল্লাহ কবুল করুন।';

  @override
  String readOnDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'গত 7 দিনের $count দিন পড়েছেন',
      one: 'গত 7 দিনের 1 দিন পড়েছেন',
    );
    return '$_temp0';
  }

  @override
  String get fastRamadan => 'রমজান';

  @override
  String get fastMondayThursday => 'সোম ও বৃহস্পতিবার';

  @override
  String get fastWhiteDays => 'আইয়ামে বীয';

  @override
  String get fastArafah => 'আরাফার দিন';

  @override
  String get fastAshura => 'তাসুআ ও আশুরা';

  @override
  String fastTomorrow(String name) {
    return 'আগামীকাল: $name';
  }

  @override
  String get fastTomorrowBody =>
      'যারা রোজা রাখতে চান তাদের জন্য একটি রিমাইন্ডার। ফজরের আগে সাহরি।';

  @override
  String get suhoorTitle => 'সাহরি';

  @override
  String suhoorBody(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes মিনিট পর ফজর',
      one: '1 মিনিট পর ফজর',
    );
    return '$_temp0';
  }

  @override
  String get fastingReminders => 'রোজা';

  @override
  String get fastReminderTitle => 'নফল রোজা';

  @override
  String get fastReminderBody => 'সুন্নত রোজার আগের সন্ধ্যায়।';

  @override
  String get suhoorReminderTitle => 'রমজানে সাহরি';

  @override
  String get suhoorReminderBody => 'রমজানে, ফজরের আগে।';

  @override
  String get iftarIn => 'ইফতার বাকি';

  @override
  String get suhoorEndsIn => 'সাহরি শেষ হতে বাকি';

  @override
  String ramadanDay(int day) {
    return 'রমজান · $dayতম দিন';
  }

  @override
  String fastToday(String name) {
    return 'আজ: $name';
  }

  @override
  String iftarAt(String time) {
    return 'ইফতার $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'সাহরি $time পর্যন্ত';
  }

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get sourceCode => 'সোর্স কোড (GPL-3.0)';
}
