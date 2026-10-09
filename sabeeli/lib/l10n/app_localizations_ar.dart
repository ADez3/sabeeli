// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سبيلي';

  @override
  String get appTagline => 'طريقك كل يوم';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navQuran => 'القرآن';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navAzkar => 'الأذكار';

  @override
  String get navMore => 'المزيد';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerJumuah => 'الجمعة';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get midnight => 'منتصف الليل';

  @override
  String get lastThird => 'الثلث الأخير من الليل';

  @override
  String get salam => 'السلام عليكم';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String prayerTimeNow(String prayer) {
    return 'حان الآن وقت $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'بعد $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غدًا';

  @override
  String get prayerTimes => 'مواقيت الصلاة';

  @override
  String get location => 'الموقع';

  @override
  String get setLocation => 'حدّد موقعك';

  @override
  String get setLocationHint =>
      'تُحسب مواقيت الصلاة واتجاه القبلة بناءً على مكانك. لا يغادر موقعك جهازك أبدًا.';

  @override
  String get useCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get searchCity => 'ابحث عن مدينة';

  @override
  String get searchCityHint => 'اسم المدينة';

  @override
  String get locating => 'جارٍ تحديد موقعك…';

  @override
  String get locationDisabled => 'خدمات الموقع متوقفة.';

  @override
  String get locationDenied => 'تم رفض إذن الوصول إلى الموقع.';

  @override
  String get locationDeniedForever =>
      'إذن الموقع محظور. اسمح به من إعدادات التطبيق.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get unknownPlace => 'الموقع الحالي';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get networkError => 'لا يوجد اتصال. تحقق من الإنترنت وحاول مرة أخرى.';

  @override
  String get genericError => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get calculation => 'الحساب';

  @override
  String get calculationMethod => 'طريقة الحساب';

  @override
  String get asrMethod => 'وقت العصر';

  @override
  String get asrStandard => 'الجمهور (الشافعي، المالكي، الحنبلي)';

  @override
  String get asrHanafi => 'الحنفي';

  @override
  String get highLatitudeRule => 'قاعدة خطوط العرض العليا';

  @override
  String get highLatMiddle => 'منتصف الليل';

  @override
  String get highLatSeventh => 'سُبع الليل';

  @override
  String get highLatAngle => 'زاوية الشفق';

  @override
  String get highLatNone => 'بدون';

  @override
  String get adjustments => 'تعديلات يدوية';

  @override
  String get adjustmentsHint => 'أضف دقائق أو أنقصها لتوافق مسجدك المحلي.';

  @override
  String minutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String get methodMuslimWorldLeague => 'رابطة العالم الإسلامي';

  @override
  String get methodEgyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get methodKarachi => 'جامعة العلوم الإسلامية، كراتشي';

  @override
  String get methodUmmAlQura => 'أم القرى، مكة المكرمة';

  @override
  String get methodDubai => 'دبي';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodKuwait => 'الكويت';

  @override
  String get methodNorthAmerica => 'الجمعية الإسلامية لأمريكا الشمالية (ISNA)';

  @override
  String get methodSingapore => 'سنغافورة (MUIS)';

  @override
  String get methodTurkey => 'رئاسة الشؤون الدينية، تركيا';

  @override
  String get methodTehran => 'معهد الجيوفيزياء، طهران';

  @override
  String get methodFrance => 'فرنسا (UOIF، 12°)';

  @override
  String get methodRussia => 'الإدارة الدينية لمسلمي روسيا';

  @override
  String get methodMorocco => 'وزارة الأوقاف والشؤون الإسلامية، المغرب';

  @override
  String get methodAlgeria => 'وزارة الشؤون الدينية والأوقاف، الجزائر';

  @override
  String get methodTunisia => 'تونس';

  @override
  String get methodJordan =>
      'وزارة الأوقاف والشؤون والمقدسات الإسلامية، الأردن';

  @override
  String get methodIndonesia => 'وزارة الشؤون الدينية، إندونيسيا';

  @override
  String get methodMalaysia => 'إدارة التنمية الإسلامية (JAKIM)، ماليزيا';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationSound => 'صوت الإشعار';

  @override
  String get notificationSilent => 'صامت';

  @override
  String get notificationOff => 'إيقاف';

  @override
  String get reminderBefore => 'التذكير قبل';

  @override
  String get reminderOff => 'بدون تذكير';

  @override
  String minutesBefore(int minutes) {
    return 'قبل $minutes د';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'حان الآن وقت صلاة $prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer بعد $minutes دقيقة';
  }

  @override
  String get notificationsBlocked => 'الإشعارات متوقفة لتطبيق سبيلي.';

  @override
  String get exactAlarmsNeeded =>
      'اسمح بـ«المنبّهات والتذكيرات» لتصل تنبيهات الصلاة في وقتها تمامًا.';

  @override
  String get allow => 'سماح';

  @override
  String get channelSilent => 'تنبيهات الصلاة الصامتة';

  @override
  String get channelPrayer => 'مواقيت الصلاة';

  @override
  String get channelReminder => 'تذكيرات الصلاة';

  @override
  String get qibla => 'القبلة';

  @override
  String get qiblaDirection => 'اتجاه القبلة';

  @override
  String get facingQibla => 'أنت تتجه نحو القبلة';

  @override
  String get turnTowards => 'استدر حتى يشير السهم إلى الأعلى';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance كم إلى الكعبة';
  }

  @override
  String get calibrateCompass =>
      'دقة البوصلة منخفضة. حرّك هاتفك على شكل الرقم 8 لمعايرتها.';

  @override
  String get compassUnavailable =>
      'هذا الجهاز لا يحتوي على بوصلة. استخدم الاتجاه أدناه مع بوصلة حقيقية.';

  @override
  String get qiblaNeedsLocation => 'حدّد موقعك لمعرفة اتجاه القبلة.';

  @override
  String get quran => 'القرآن الكريم';

  @override
  String get surahs => 'السور';

  @override
  String get juzs => 'الأجزاء';

  @override
  String get bookmarks => 'العلامات';

  @override
  String juzNumber(int number) {
    return 'الجزء $number';
  }

  @override
  String pageNumber(int number) {
    return 'صفحة $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آية',
      many: '$count آية',
      few: '$count آيات',
      two: 'آيتان',
      one: 'آية واحدة',
      zero: 'لا آيات',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah، الآية $ayah';
  }

  @override
  String get meccan => 'مكية';

  @override
  String get medinan => 'مدنية';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get startReading => 'ابدأ القراءة';

  @override
  String get lastRead => 'آخر قراءة';

  @override
  String get tafsir => 'التفسير';

  @override
  String get tafsirMuyassar => 'التفسير الميسر';

  @override
  String get translation => 'الترجمة';

  @override
  String get copy => 'نسخ';

  @override
  String get share => 'مشاركة';

  @override
  String get copied => 'تم النسخ';

  @override
  String get bookmark => 'إضافة علامة';

  @override
  String get removeBookmark => 'إزالة العلامة';

  @override
  String get bookmarkAdded => 'تمت إضافة العلامة';

  @override
  String get bookmarkRemoved => 'تمت إزالة العلامة';

  @override
  String get setAsLastRead => 'تعيين كموضع توقفي';

  @override
  String get lastReadSaved => 'تم حفظ موضع القراءة';

  @override
  String get noBookmarks =>
      'لا توجد علامات بعد. اضغط على آية أثناء القراءة لإضافة علامة.';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get searchSurah => 'ابحث في السور';

  @override
  String get sajda => 'سجدة';

  @override
  String get translationUnavailable => 'لم يتم تنزيل هذه الترجمة بعد.';

  @override
  String get download => 'تنزيل';

  @override
  String get downloading => 'جارٍ التنزيل…';

  @override
  String get translationLanguage => 'لغة الترجمة';

  @override
  String get noTranslation => 'بدون';

  @override
  String get readerSettings => 'إعدادات القراءة';

  @override
  String get dailyAyah => 'آية اليوم';

  @override
  String get azkar => 'الأذكار';

  @override
  String get azkarMorning => 'أذكار الصباح';

  @override
  String get azkarEvening => 'أذكار المساء';

  @override
  String get azkarAfterPrayer => 'أذكار بعد الصلاة';

  @override
  String get azkarSleep => 'أذكار النوم';

  @override
  String get azkarWaking => 'أذكار الاستيقاظ';

  @override
  String get allCategories => 'جميع الأدعية';

  @override
  String get tapToCount => 'اضغط للعدّ';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      many: '$count مرة',
      few: '$count مرات',
      two: 'مرتان',
      one: 'مرة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'اكتمل';

  @override
  String get azkarDone => 'تقبّل الله منك';

  @override
  String get restart => 'البدء من جديد';

  @override
  String progressOf(int done, int total) {
    return '$done من $total';
  }

  @override
  String get source => 'المصدر';

  @override
  String get virtue => 'الفضل';

  @override
  String get searchAzkar => 'ابحث في الأدعية';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعاء',
      many: '$count دعاءً',
      few: '$count أدعية',
      two: 'دعاءان',
      one: 'دعاء واحد',
      zero: 'لا أدعية',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'التسبيح';

  @override
  String get reset => 'تصفير';

  @override
  String get target => 'الهدف';

  @override
  String get noTarget => 'بلا حد';

  @override
  String totalCount(int count) {
    return 'المجموع: $count';
  }

  @override
  String rounds(int count) {
    return 'الدورات: $count';
  }

  @override
  String get vibration => 'الاهتزاز';

  @override
  String get more => 'المزيد';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

  @override
  String get numerals => 'الأرقام';

  @override
  String get numeralsAuto => 'تلقائي (حسب المنطقة)';

  @override
  String get numeralsWestern => 'غربية (مغاربية)';

  @override
  String get numeralsArabic => 'عربية مشرقية';

  @override
  String get numeralsPersian => 'فارسية / أردية';

  @override
  String get hijriCalendar => 'التقويم الهجري';

  @override
  String get hijriCalendarHint =>
      'لا تتفق الدول دائمًا على بداية الشهر. عدّل التقويم ليتوافق مع الإعلان الرسمي في بلدك.';

  @override
  String get hijriMethod => 'التقويم';

  @override
  String get hijriUmmAlQura => 'أم القرى (السعودية)';

  @override
  String get hijriTabular => 'حسابي (الخوارزمية الكويتية)';

  @override
  String get hijriOffset => 'إزاحة جميع الأشهر';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: 'بدون إزاحة',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'هذا الشهر';

  @override
  String hijriMonthStartedOn(String month) {
    return 'بداية شهر $month';
  }

  @override
  String get hijriAutomatic => 'تلقائي';

  @override
  String get hijriResetAll => 'إعادة ضبط جميع التصحيحات';

  @override
  String get hijriCorrections => 'تصحيحات الأشهر';

  @override
  String get hijriYearSuffix => 'هـ';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربيع الأول';

  @override
  String get hijriMonth4 => 'ربيع الآخر';

  @override
  String get hijriMonth5 => 'جمادى الأولى';

  @override
  String get hijriMonth6 => 'جمادى الآخرة';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذو القعدة';

  @override
  String get hijriMonth12 => 'ذو الحجة';

  @override
  String get about => 'حول التطبيق';

  @override
  String get aboutText =>
      'سبيلي رفيق مجاني لحياة المسلم اليومية. يعمل دون اتصال بالإنترنت، بلا إعلانات، ولا يجمع أي بيانات.';

  @override
  String get credits => 'المصادر والشكر';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }
}
