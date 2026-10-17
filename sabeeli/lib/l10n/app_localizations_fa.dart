// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'راه هر روز تو';

  @override
  String get navHome => 'خانه';

  @override
  String get navQuran => 'قرآن';

  @override
  String get navPrayer => 'نماز';

  @override
  String get navAzkar => 'اذکار';

  @override
  String get navMore => 'بیشتر';

  @override
  String get prayerFajr => 'صبح';

  @override
  String get prayerSunrise => 'طلوع آفتاب';

  @override
  String get prayerDhuhr => 'ظهر';

  @override
  String get prayerJumuah => 'جمعه';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشا';

  @override
  String get midnight => 'نیمه‌شب';

  @override
  String get lastThird => 'ثلث آخر شب';

  @override
  String get salam => 'السلام علیکم';

  @override
  String get nextPrayer => 'نماز بعدی';

  @override
  String prayerTimeNow(String prayer) {
    return 'وقت $prayer است';
  }

  @override
  String timeUntil(String duration) {
    return 'تا $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ساعت و $minutes دقیقه';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String get today => 'امروز';

  @override
  String get tomorrow => 'فردا';

  @override
  String get prayerTimes => 'اوقات نماز';

  @override
  String get diveHint => 'برای روزت به بالا بکش';

  @override
  String get now => 'اکنون';

  @override
  String get yourDay => 'روز تو';

  @override
  String get location => 'مکان';

  @override
  String get setLocation => 'مکان خود را تعیین کنید';

  @override
  String get setLocationHint =>
      'اوقات نماز و قبله روی گوشی شما و بر اساس مکانتان محاسبه می‌شود. فقط موقعیتی تقریبی به OpenStreetMap فرستاده می‌شود تا نام شهرتان پیدا شود.';

  @override
  String get useCurrentLocation => 'استفاده از مکان فعلی من';

  @override
  String get searchCity => 'جست‌وجوی شهر';

  @override
  String get searchCityHint => 'نام شهر';

  @override
  String get locating => 'در حال یافتن مکان شما…';

  @override
  String get locationDisabled => 'خدمات مکان خاموش است.';

  @override
  String get locationDenied => 'اجازهٔ دسترسی به مکان داده نشد.';

  @override
  String get locationDeniedForever =>
      'دسترسی به مکان مسدود است. آن را از تنظیمات برنامه مجاز کنید.';

  @override
  String get openSettings => 'باز کردن تنظیمات';

  @override
  String get unknownPlace => 'مکان فعلی';

  @override
  String get noResults => 'نتیجه‌ای یافت نشد';

  @override
  String get networkError =>
      'اتصال برقرار نیست. اینترنت خود را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get genericError => 'مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get calculation => 'محاسبه';

  @override
  String get calculationMethod => 'روش محاسبه';

  @override
  String get asrMethod => 'وقت عصر';

  @override
  String get asrStandard => 'معمول (شافعی، مالکی، حنبلی)';

  @override
  String get asrHanafi => 'حنفی';

  @override
  String get highLatitudeRule => 'قاعدهٔ عرض‌های بالا';

  @override
  String get highLatMiddle => 'نیمهٔ شب';

  @override
  String get highLatSeventh => 'یک‌هفتم شب';

  @override
  String get highLatAngle => 'زاویهٔ شفق';

  @override
  String get highLatNone => 'هیچ';

  @override
  String get adjustments => 'تنظیم دستی';

  @override
  String get adjustmentsHint =>
      'دقیقه‌هایی کم یا زیاد کنید تا با مسجد محلتان هماهنگ شود.';

  @override
  String get hourShift => 'اصلاح ساعت';

  @override
  String get hourShiftHint =>
      'فقط اگر همهٔ اوقات چند ساعتِ کامل اختلاف دارند: منطقهٔ زمانی گوشی شما اشتباه است (مثلاً پس از تغییر ساعت رسمی کشور هنوز روی GMT+1 مانده است). بهتر است منطقهٔ زمانی درست را در گوشی تنظیم کنید.';

  @override
  String hoursShort(int hours) {
    return '$hours ساعت';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String get methodMuslimWorldLeague => 'رابطهٔ جهان اسلام';

  @override
  String get methodEgyptian => 'سازمان عمومی نقشه‌برداری مصر';

  @override
  String get methodKarachi => 'دانشگاه علوم اسلامی کراچی';

  @override
  String get methodUmmAlQura => 'ام‌القری، مکه';

  @override
  String get methodDubai => 'دبی';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodKuwait => 'کویت';

  @override
  String get methodNorthAmerica => 'انجمن اسلامی آمریکای شمالی (ISNA)';

  @override
  String get methodSingapore => 'سنگاپور (MUIS)';

  @override
  String get methodTurkey => 'دیانت، ترکیه';

  @override
  String get methodTehran => 'مؤسسهٔ ژئوفیزیک تهران';

  @override
  String get methodFrance => 'فرانسه (UOIF، 12°)';

  @override
  String get methodRussia => 'ادارهٔ دینی مسلمانان روسیه';

  @override
  String get methodMorocco => 'وزارت اوقاف مراکش';

  @override
  String get methodAlgeria => 'وزارت امور دینی الجزایر';

  @override
  String get methodTunisia => 'تونس';

  @override
  String get methodJordan => 'وزارت اوقاف اردن';

  @override
  String get methodIndonesia => 'وزارت دین اندونزی (Kemenag)';

  @override
  String get methodMalaysia => 'JAKIM، مالزی';

  @override
  String get notifications => 'اعلان‌ها';

  @override
  String get notificationSound => 'صدای اعلان';

  @override
  String get notificationSilent => 'بی‌صدا';

  @override
  String get notificationOff => 'خاموش';

  @override
  String get reminderBefore => 'یادآوری پیش از وقت';

  @override
  String get reminderOff => 'بدون یادآوری';

  @override
  String minutesBefore(int minutes) {
    return '$minutes دقیقه پیش از وقت';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'وقت نماز $prayer است';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer تا $minutes دقیقهٔ دیگر';
  }

  @override
  String get notificationsBlocked => 'اعلان‌های Sabeeli خاموش است.';

  @override
  String get exactAlarmsNeeded =>
      '«هشدارها و یادآوری‌ها» را مجاز کنید تا اعلان‌های نماز دقیقاً سر وقت برسند.';

  @override
  String get allow => 'اجازه دادن';

  @override
  String get channelSilent => 'اعلان‌های بی‌صدای نماز';

  @override
  String get channelPrayer => 'اوقات نماز';

  @override
  String get channelReminder => 'یادآوری‌های نماز';

  @override
  String get qibla => 'قبله';

  @override
  String get qiblaDirection => 'جهت قبله';

  @override
  String get facingQibla => 'رو به قبله هستید';

  @override
  String get turnTowards => 'بچرخید تا پیکان رو به بالا باشد';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° از شمال';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance کیلومتر تا کعبه';
  }

  @override
  String get calibrateCompass =>
      'دقت قطب‌نما کم است. برای تنظیم، گوشی را به شکل عدد هشت لاتین حرکت دهید.';

  @override
  String get compassUnavailable =>
      'این دستگاه قطب‌نما ندارد. از زاویهٔ زیر با یک قطب‌نمای واقعی استفاده کنید.';

  @override
  String get qiblaNeedsLocation => 'برای یافتن قبله، مکان خود را تعیین کنید.';

  @override
  String get you => 'شما';

  @override
  String get makkah => 'مکه';

  @override
  String get qiblaGreatCircle =>
      'قبله کوتاه‌ترین مسیر روی کرهٔ زمین را دنبال می‌کند، نه خطی راست روی نقشهٔ مسطح.';

  @override
  String get globeView => 'کره';

  @override
  String get compassView => 'قطب‌نما';

  @override
  String get quran => 'قرآن کریم';

  @override
  String get surahs => 'سوره‌ها';

  @override
  String get juzs => 'جزء';

  @override
  String get bookmarks => 'نشانک‌ها';

  @override
  String juzNumber(int number) {
    return 'جزء $number';
  }

  @override
  String pageNumber(int number) {
    return 'صفحهٔ $number';
  }

  @override
  String ayahCount(int count) {
    return '$count آیه';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah، آیهٔ $ayah';
  }

  @override
  String get meccan => 'مکی';

  @override
  String get medinan => 'مدنی';

  @override
  String get continueReading => 'ادامهٔ تلاوت';

  @override
  String get startReading => 'شروع تلاوت';

  @override
  String get lastRead => 'آخرین تلاوت';

  @override
  String get tafsir => 'تفسیر';

  @override
  String get tafsirMuyassar => 'تفسیر المیسر';

  @override
  String get translation => 'ترجمه';

  @override
  String get copy => 'کپی';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get copied => 'کپی شد';

  @override
  String get bookmark => 'نشانک';

  @override
  String get removeBookmark => 'حذف نشانک';

  @override
  String get bookmarkAdded => 'نشانک افزوده شد';

  @override
  String get bookmarkRemoved => 'نشانک حذف شد';

  @override
  String get setAsLastRead => 'اینجا را جای توقفم بگذار';

  @override
  String get lastReadSaved => 'جای تلاوت ذخیره شد';

  @override
  String get noBookmarks =>
      'هنوز نشانکی ندارید. هنگام تلاوت روی یک آیه بزنید تا نشانک شود.';

  @override
  String get fontSize => 'اندازهٔ قلم';

  @override
  String get searchSurah => 'جست‌وجوی سوره‌ها';

  @override
  String get sajda => 'سجده';

  @override
  String get translationUnavailable => 'این ترجمه هنوز بارگیری نشده است.';

  @override
  String get download => 'بارگیری';

  @override
  String get downloading => 'در حال بارگیری…';

  @override
  String get translationLanguage => 'زبان ترجمه';

  @override
  String get noTranslation => 'هیچ';

  @override
  String get readerSettings => 'تنظیمات تلاوت';

  @override
  String get dailyAyah => 'آیهٔ روز';

  @override
  String get skyView => 'آسمان';

  @override
  String get listView => 'فهرست';

  @override
  String khatmahProgress(int percent) {
    return '$percent٪ از قرآن خوانده شده';
  }

  @override
  String get skyHint => 'هر ستاره یک سوره است و با خواندنش روشن‌تر می‌شود.';

  @override
  String revelationOrder(int order) {
    return '$orderمین سوره در ترتیب نزول';
  }

  @override
  String pagesRange(int from, int to) {
    return 'صفحه‌های $from تا $to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent٪ خوانده شده';
  }

  @override
  String get openSurah => 'باز کردن';

  @override
  String get azkar => 'اذکار';

  @override
  String get azkarMorning => 'اذکار صبح';

  @override
  String get azkarEvening => 'اذکار شام';

  @override
  String get azkarAfterPrayer => 'پس از نماز';

  @override
  String get azkarSleep => 'پیش از خواب';

  @override
  String get azkarWaking => 'هنگام بیداری';

  @override
  String get allCategories => 'همهٔ دعاها';

  @override
  String get tapToCount => 'برای شمردن بزنید';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار',
      two: 'دو بار',
      one: 'یک بار',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'تمام شد';

  @override
  String get azkarDone => 'الله از شما بپذیرد';

  @override
  String get restart => 'شروع دوباره';

  @override
  String progressOf(int done, int total) {
    return '$done از $total';
  }

  @override
  String get source => 'منبع';

  @override
  String get virtue => 'فضیلت';

  @override
  String get searchAzkar => 'جست‌وجوی دعاها';

  @override
  String itemsCount(int count) {
    return '$count دعا';
  }

  @override
  String get tasbih => 'تسبیح';

  @override
  String get reset => 'صفر کردن';

  @override
  String get target => 'هدف';

  @override
  String get noTarget => 'بی‌حد';

  @override
  String totalCount(int count) {
    return 'مجموع: $count';
  }

  @override
  String rounds(int count) {
    return 'دورها: $count';
  }

  @override
  String get vibration => 'لرزش';

  @override
  String get more => 'بیشتر';

  @override
  String get settings => 'تنظیمات';

  @override
  String get appearance => 'ظاهر';

  @override
  String get theme => 'پوسته';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeDark => 'تیره';

  @override
  String get themeLight => 'روشن';

  @override
  String get language => 'زبان';

  @override
  String get systemLanguage => 'زبان سیستم';

  @override
  String get numerals => 'اعداد';

  @override
  String get numeralsAuto => 'خودکار (بر اساس منطقه)';

  @override
  String get numeralsWestern => 'لاتین';

  @override
  String get numeralsArabic => 'عربی (شرقی)';

  @override
  String get numeralsPersian => 'فارسی / اردو';

  @override
  String get hijriCalendar => 'تقویم هجری قمری';

  @override
  String get hijriCalendarHint =>
      'کشورها همیشه دربارهٔ آغاز ماه هم‌نظر نیستند. تقویم را مطابق اعلام محلی خود تنظیم کنید.';

  @override
  String get hijriMethod => 'تقویم';

  @override
  String get hijriUmmAlQura => 'ام‌القری (عربستان سعودی)';

  @override
  String get hijriTabular => 'محاسباتی (الگوریتم کویتی)';

  @override
  String get hijriOffset => 'جابه‌جایی همهٔ ماه‌ها';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      zero: 'بدون جابه‌جایی',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'این ماه';

  @override
  String hijriMonthStartedOn(String month) {
    return 'آغاز $month';
  }

  @override
  String get hijriAutomatic => 'خودکار';

  @override
  String get hijriResetAll => 'بازنشانی همهٔ اصلاح‌ها';

  @override
  String get hijriCorrections => 'اصلاح ماه‌ها';

  @override
  String get hijriYearSuffix => 'ق';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربیع‌الاول';

  @override
  String get hijriMonth4 => 'ربیع‌الثانی';

  @override
  String get hijriMonth5 => 'جمادی‌الاول';

  @override
  String get hijriMonth6 => 'جمادی‌الثانی';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذی‌القعده';

  @override
  String get hijriMonth12 => 'ذی‌الحجه';

  @override
  String get eidAlFitr => 'عید فطر';

  @override
  String get eidAlAdha => 'عید قربان';

  @override
  String get dayOfArafah => 'روز عرفه';

  @override
  String get ashura => 'عاشورا';

  @override
  String get islamicNewYear => 'سال نو هجری';

  @override
  String get whiteDays => 'ایام البیض';

  @override
  String get ramadanBegins => 'آغاز رمضان';

  @override
  String get about => 'درباره';

  @override
  String get aboutText =>
      'Sabeeli همراهی رایگان برای زندگی روزانهٔ یک مسلمان است. بدون اینترنت کار می‌کند، تبلیغ ندارد و هیچ داده‌ای جمع نمی‌کند.';

  @override
  String get credits => 'منابع و قدردانی';

  @override
  String version(String version) {
    return 'نسخهٔ $version';
  }

  @override
  String get afterPrayer => 'پس از نماز';

  @override
  String afterPrayerOf(String prayer) {
    return 'پس از $prayer';
  }

  @override
  String get afterPrayerHint => 'اذکار پس از سلام نماز، گام به گام';

  @override
  String get showTranslation => 'ترجمه';

  @override
  String get turnTheBeads => 'دانه‌ها را بچرخانید یا بزنید';

  @override
  String get doneStep => 'انجام شد';

  @override
  String get previousStep => 'قبلی';

  @override
  String get skipStep => 'رد شدن';

  @override
  String remembrances(int count) {
    return '$count بار ذکر الله';
  }

  @override
  String prayerIn(String prayer) {
    return 'تا $prayer';
  }

  @override
  String atTime(String time) {
    return 'ساعت $time';
  }

  @override
  String get nowLabel => 'اکنون';

  @override
  String pageAyah(int page, int ayah) {
    return 'صفحهٔ $page · آیهٔ $ayah';
  }

  @override
  String get tasbihHint => 'دانه‌ها را بچرخانید';

  @override
  String get azkarHint => 'صبح، شام و بیشتر';

  @override
  String get ayahOfTheDay => 'آیهٔ روز';

  @override
  String get navToday => 'امروز';

  @override
  String get navDhikr => 'ذکر';

  @override
  String get riwayah => 'روایت';

  @override
  String get riwayahAuto => 'خودکار، بر اساس منطقه';

  @override
  String get riwayahHafs => 'حفص از عاصم';

  @override
  String get riwayahWarsh => 'ورش از نافع';

  @override
  String get riwayahQalun => 'قالون از نافع';

  @override
  String get riwayahHafsHint => 'رایج در بیشتر جهان اسلام';

  @override
  String get riwayahWarshHint => 'مراکش، الجزایر، موریتانی، غرب آفریقا';

  @override
  String get riwayahQalunHint => 'لیبی، تونس';

  @override
  String get riwayahNote =>
      'هر روایت در مصحف خودش از مجمع ملک فهد نمایش داده می‌شود. تفسیر و ترجمه‌ها آیه به آیه با آن تطبیق داده شده‌اند.';

  @override
  String get general => 'عمومی';

  @override
  String get dhikrSubtitle => 'الله را یاد کنید تا شما را یاد کند';

  @override
  String get qiblaSubtitle => 'جهت کعبه از جایی که هستید';

  @override
  String get unitHours => 'ساعت';

  @override
  String get unitMinutes => 'دقیقه';

  @override
  String get unitSeconds => 'ثانیه';

  @override
  String get pageColour => 'صفحه';

  @override
  String get pageAuto => 'خودکار';

  @override
  String get pageNight => 'شب';

  @override
  String get pageSepia => 'قهوه‌ای';

  @override
  String get pagePaper => 'کاغذی';

  @override
  String get welcomeTagline =>
      'نماز، قرآن و ذکر، زیر آسمان واقعی بالای سرتان. رایگان، خصوصی و از آنِ شما.';

  @override
  String get welcomeBegin => 'آغاز';

  @override
  String get welcomeNext => 'بعدی';

  @override
  String get welcomeStart => 'شروع';

  @override
  String get welcomePlaceTitle => 'کجا هستید؟';

  @override
  String get welcomeNotifyTitle => 'در وقت هر نماز';

  @override
  String get welcomeNotifyBody =>
      'اعلانی آرام با صدای خود گوشی، هنگام فرا رسیدن وقت هر نماز. بعداً می‌توانید آن را برای هر نماز جداگانه تنظیم کنید.';

  @override
  String get welcomeNotifyAllow => 'اجازهٔ اعلان‌ها';

  @override
  String get welcomeNotifyOn => 'اعلان‌ها روشن است';

  @override
  String get welcomeExactAlarms => 'سر دقیقه برسند';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'قرآن به روایت $riwayah باز می‌شود. می‌توانید آن را در تنظیمات تغییر دهید.';
  }

  @override
  String get prepareSoon => 'به‌زودی';

  @override
  String get prepareHint => 'وقت وضو';

  @override
  String get channelDaily => 'یادآوری‌های روزانه';

  @override
  String get dailyReminders => 'یادآوری‌های روزانه';

  @override
  String get dailyMorning => 'اذکار صبح';

  @override
  String get dailyMorningBody => 'چند دقیقه ذکر برای آغاز روز.';

  @override
  String get dailyEvening => 'اذکار شام';

  @override
  String get dailyEveningBody => 'اذکار شام، هنگام پایان روز.';

  @override
  String get dailySleep => 'اذکار پیش از خواب';

  @override
  String get dailySleepBody => 'روز را با ذکر به پایان ببرید.';

  @override
  String get dailyQuran => 'تلاوت روزانهٔ شما';

  @override
  String get dailyQuranBody => 'صفحه‌ای از قرآن منتظر شماست.';

  @override
  String get dailyRemindersIntro =>
      'یادآوری برای اذکار و تلاوت روزانه، در ساعتی که خودتان انتخاب می‌کنید. این یادآوری‌ها اختیاری‌اند: اعلانی تکراری هر روز ممکن است پس از مدتی آزاردهنده شود؛ پس فقط آن‌هایی را روشن کنید که واقعاً کمکتان می‌کنند و هر وقت خواستید خاموششان کنید.';

  @override
  String get dailyRemindersOff => 'خاموش';

  @override
  String dailyRemindersOn(int count) {
    return '$count روشن';
  }

  @override
  String get betaBadge => 'بتا';

  @override
  String get betaTitle => 'Sabeeli در مرحلهٔ بتاست';

  @override
  String get betaBody =>
      'این برنامه هنوز نوپاست. متن‌ها، ترجمه‌ها و اطلاعاتی که نشان می‌دهد هنوز باید به دست اهل علم بازبینی شود. اگر هر اشتباهی دیدید، حتی جزئی، لطفاً به ما بگویید: هر گزارشی کمک می‌کند.';

  @override
  String get betaShakeHint =>
      'در هر صفحه‌ای گوشی را تکان دهید تا مشکلی را همراه با تصویر صفحه گزارش کنید.';

  @override
  String get betaUnderstood => 'متوجه شدم';

  @override
  String get reportTitle => 'گزارش مشکل';

  @override
  String get reportHint => 'چه چیزی اشتباه است؟ (اختیاری)';

  @override
  String get reportSend => 'ارسال با ایمیل';

  @override
  String get reportAttach => 'پیوست تصویر صفحه';

  @override
  String get reportPrivacy =>
      'برنامهٔ ایمیل شما با گزارش آماده باز می‌شود. تا آنجا دکمهٔ ارسال را نزنید، چیزی فرستاده نمی‌شود.';

  @override
  String get reportNoMail => 'هیچ برنامهٔ ایمیلی روی این گوشی پیدا نشد';

  @override
  String get shakeToReport => 'تکان دادن برای گزارش مشکل';

  @override
  String get khatmahPlan => 'برنامهٔ ختم قرآن';

  @override
  String get planAKhatmah => 'برنامه‌ریزی ختم قرآن';

  @override
  String khatmahDays(int days) {
    return '$days روز';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'روز $day از $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'امروز: صفحه‌های $from تا $to';
  }

  @override
  String khatmahLeft(int count) {
    return '$count صفحه برای امروز مانده';
  }

  @override
  String get khatmahDone => 'سهم امروز تمام شد';

  @override
  String khatmahPerDay(int count) {
    return 'حدود $count صفحه در روز';
  }

  @override
  String khatmahEnds(String date) {
    return 'پایان در $date';
  }

  @override
  String get khatmahFromStart => 'از ابتدا';

  @override
  String khatmahFromHere(int page) {
    return 'از صفحهٔ $page';
  }

  @override
  String get khatmahStart => 'شروع برنامه';

  @override
  String get khatmahEnd => 'پایان برنامه';

  @override
  String get khatmahFinished => 'ختم قرآن کامل شد. الله آن را بپذیرد.';

  @override
  String readOnDays(int count) {
    return '$count روز از هفتهٔ گذشته تلاوت کرده‌اید';
  }

  @override
  String get fastRamadan => 'رمضان';

  @override
  String get fastMondayThursday => 'دوشنبه‌ها و پنجشنبه‌ها';

  @override
  String get fastWhiteDays => 'ایام البیض';

  @override
  String get fastArafah => 'روز عرفه';

  @override
  String get fastAshura => 'تاسوعا و عاشورا';

  @override
  String fastTomorrow(String name) {
    return 'فردا: $name';
  }

  @override
  String get fastTomorrowBody =>
      'یادآوری برای کسانی که می‌خواهند روزه بگیرند. سحری پیش از صبح.';

  @override
  String get suhoorTitle => 'سحری';

  @override
  String suhoorBody(int minutes) {
    return '$minutes دقیقه تا اذان صبح';
  }

  @override
  String get fastingReminders => 'روزه';

  @override
  String get fastReminderTitle => 'روزه‌های مستحب';

  @override
  String get fastReminderBody => 'شب پیش از یک روزهٔ سنت.';

  @override
  String get suhoorReminderTitle => 'سحری در رمضان';

  @override
  String get suhoorReminderBody => 'پیش از صبح، در ماه رمضان.';

  @override
  String get iftarIn => 'تا افطار';

  @override
  String get suhoorEndsIn => 'تا پایان سحری';

  @override
  String ramadanDay(int day) {
    return 'رمضان · روز $day';
  }

  @override
  String fastToday(String name) {
    return 'امروز: $name';
  }

  @override
  String iftarAt(String time) {
    return 'افطار $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'سحری تا $time';
  }

  @override
  String get privacyPolicy => 'سیاست حفظ حریم خصوصی';

  @override
  String get sourceCode => 'کد منبع (GPL-3.0)';
}
