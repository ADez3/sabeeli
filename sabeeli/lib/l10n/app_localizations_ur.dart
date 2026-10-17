// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'سبیلی';

  @override
  String get appTagline => 'آپ کا روزانہ کا راستہ';

  @override
  String get navHome => 'ہوم';

  @override
  String get navQuran => 'قرآن';

  @override
  String get navPrayer => 'نماز';

  @override
  String get navAzkar => 'اذکار';

  @override
  String get navMore => 'مزید';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerSunrise => 'طلوع آفتاب';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerJumuah => 'جمعہ';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get midnight => 'نصف شب';

  @override
  String get lastThird => 'رات کا آخری تہائی حصہ';

  @override
  String get salam => 'السلام علیکم';

  @override
  String get nextPrayer => 'اگلی نماز';

  @override
  String prayerTimeNow(String prayer) {
    return '$prayer کا وقت ہو گیا ہے';
  }

  @override
  String timeUntil(String duration) {
    return '$duration میں';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get today => 'آج';

  @override
  String get tomorrow => 'کل';

  @override
  String get prayerTimes => 'اوقاتِ نماز';

  @override
  String get diveHint => 'اپنے دن کے لیے اوپر سوائپ کریں';

  @override
  String get now => 'ابھی';

  @override
  String get yourDay => 'آپ کا دن';

  @override
  String get location => 'مقام';

  @override
  String get setLocation => 'اپنا مقام منتخب کریں';

  @override
  String get setLocationHint =>
      'نماز کے اوقات اور قبلہ آپ کے فون پر آپ کے مقام سے حساب کیے جاتے ہیں۔ صرف ایک تقریبی مقام OpenStreetMap کو بھیجا جاتا ہے تاکہ آپ کے شہر کا نام دکھایا جا سکے۔';

  @override
  String get useCurrentLocation => 'میرا موجودہ مقام استعمال کریں';

  @override
  String get searchCity => 'شہر تلاش کریں';

  @override
  String get searchCityHint => 'شہر کا نام';

  @override
  String get locating => 'آپ کا مقام معلوم کیا جا رہا ہے…';

  @override
  String get locationDisabled => 'لوکیشن سروسز بند ہیں۔';

  @override
  String get locationDenied => 'مقام کی اجازت مسترد کر دی گئی۔';

  @override
  String get locationDeniedForever =>
      'مقام کی اجازت بلاک ہے۔ ایپ کی ترتیبات سے اجازت دیں۔';

  @override
  String get openSettings => 'ترتیبات کھولیں';

  @override
  String get unknownPlace => 'موجودہ مقام';

  @override
  String get noResults => 'کوئی نتیجہ نہیں';

  @override
  String get networkError =>
      'کنکشن نہیں ہے۔ اپنا انٹرنیٹ چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get genericError => 'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get calculation => 'حساب';

  @override
  String get calculationMethod => 'حساب کا طریقہ';

  @override
  String get asrMethod => 'عصر کا وقت';

  @override
  String get asrStandard => 'جمہور (شافعی، مالکی، حنبلی)';

  @override
  String get asrHanafi => 'حنفی';

  @override
  String get highLatitudeRule => 'بلند عرض البلد کا قاعدہ';

  @override
  String get highLatMiddle => 'نصف شب';

  @override
  String get highLatSeventh => 'رات کا ساتواں حصہ';

  @override
  String get highLatAngle => 'شفق کا زاویہ';

  @override
  String get highLatNone => 'کوئی نہیں';

  @override
  String get adjustments => 'دستی ترامیم';

  @override
  String get adjustmentsHint =>
      'اپنی مقامی مسجد کے مطابق منٹ بڑھائیں یا کم کریں۔';

  @override
  String get hourShift => 'گھنٹے کی درستی';

  @override
  String get hourShiftHint =>
      'صرف اگر تمام اوقات پورے گھنٹوں سے ہٹے ہوں: آپ کے فون کا ٹائم زون غلط ہے (مثلاً ملک کے وقت بدلنے کے بعد بھی GMT+1)۔ بہتر ہے فون میں درست ٹائم زون منتخب کریں۔';

  @override
  String hoursShort(int hours) {
    return '$hours گھنٹے';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get methodMuslimWorldLeague => 'رابطہ عالم اسلامی';

  @override
  String get methodEgyptian => 'مصری جنرل اتھارٹی برائے سروے';

  @override
  String get methodKarachi => 'جامعۃ العلوم الاسلامیہ، کراچی';

  @override
  String get methodUmmAlQura => 'ام القریٰ، مکہ مکرمہ';

  @override
  String get methodDubai => 'دبئی';

  @override
  String get methodQatar => 'قطر';

  @override
  String get methodKuwait => 'کویت';

  @override
  String get methodNorthAmerica => 'اسلامک سوسائٹی آف نارتھ امریکا (ISNA)';

  @override
  String get methodSingapore => 'سنگاپور (MUIS)';

  @override
  String get methodTurkey => 'دیانت، ترکی';

  @override
  String get methodTehran => 'انسٹی ٹیوٹ آف جیو فزکس، تہران';

  @override
  String get methodFrance => 'فرانس (UOIF، 12°)';

  @override
  String get methodRussia => 'روس کے مسلمانوں کی روحانی انتظامیہ';

  @override
  String get methodMorocco => 'وزارتِ اوقاف و امور اسلامیہ، مراکش';

  @override
  String get methodAlgeria => 'وزارتِ مذہبی امور، الجزائر';

  @override
  String get methodTunisia => 'تیونس';

  @override
  String get methodJordan => 'وزارتِ اوقاف، اردن';

  @override
  String get methodIndonesia => 'وزارتِ مذہبی امور (Kemenag)، انڈونیشیا';

  @override
  String get methodMalaysia => 'JAKIM، ملائیشیا';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get notificationSound => 'اطلاع کی آواز';

  @override
  String get notificationSilent => 'خاموش';

  @override
  String get notificationOff => 'بند';

  @override
  String get reminderBefore => 'پہلے یاد دہانی';

  @override
  String get reminderOff => 'کوئی یاد دہانی نہیں';

  @override
  String minutesBefore(int minutes) {
    return '$minutes منٹ پہلے';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'نمازِ $prayer کا وقت ہو گیا ہے';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer میں $minutes منٹ باقی';
  }

  @override
  String get notificationsBlocked => 'سبیلی کے لیے اطلاعات بند ہیں۔';

  @override
  String get exactAlarmsNeeded =>
      '\"الارمز اور یاد دہانیاں\" کی اجازت دیں تاکہ نماز کی اطلاعات بالکل وقت پر آئیں۔';

  @override
  String get allow => 'اجازت دیں';

  @override
  String get channelSilent => 'خاموش نماز اطلاعات';

  @override
  String get channelPrayer => 'اوقاتِ نماز';

  @override
  String get channelReminder => 'نماز کی یاد دہانیاں';

  @override
  String get qibla => 'قبلہ';

  @override
  String get qiblaDirection => 'قبلہ کی سمت';

  @override
  String get facingQibla => 'آپ کا رخ قبلہ کی طرف ہے';

  @override
  String get turnTowards => 'گھومیں یہاں تک کہ تیر اوپر کی طرف اشارہ کرے';

  @override
  String degreesFromNorth(String degrees) {
    return 'شمال سے $degrees°';
  }

  @override
  String distanceToKaaba(String distance) {
    return 'کعبہ تک $distance کلومیٹر';
  }

  @override
  String get calibrateCompass =>
      'قطب نما کی درستگی کم ہے۔ کیلیبریٹ کرنے کے لیے فون کو 8 کی شکل میں گھمائیں۔';

  @override
  String get compassUnavailable =>
      'اس آلے میں قطب نما نہیں ہے۔ نیچے دی گئی سمت کو حقیقی قطب نما کے ساتھ استعمال کریں۔';

  @override
  String get qiblaNeedsLocation =>
      'قبلہ معلوم کرنے کے لیے اپنا مقام منتخب کریں۔';

  @override
  String get you => 'آپ';

  @override
  String get makkah => 'مکہ مکرمہ';

  @override
  String get qiblaGreatCircle =>
      'قبلہ زمین پر سب سے چھوٹے راستے کی سمت ہے، سیدھے نقشے کی لکیر کی نہیں۔';

  @override
  String get globeView => 'گلوب';

  @override
  String get compassView => 'قطب نما';

  @override
  String get quran => 'قرآن مجید';

  @override
  String get surahs => 'سورتیں';

  @override
  String get juzs => 'پارے';

  @override
  String get bookmarks => 'بُک مارکس';

  @override
  String juzNumber(int number) {
    return 'پارہ $number';
  }

  @override
  String pageNumber(int number) {
    return 'صفحہ $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آیات',
      one: '1 آیت',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah، آیت $ayah';
  }

  @override
  String get meccan => 'مکی';

  @override
  String get medinan => 'مدنی';

  @override
  String get continueReading => 'تلاوت جاری رکھیں';

  @override
  String get startReading => 'تلاوت شروع کریں';

  @override
  String get lastRead => 'آخری تلاوت';

  @override
  String get tafsir => 'تفسیر';

  @override
  String get tafsirMuyassar => 'تفسیر المیسر';

  @override
  String get translation => 'ترجمہ';

  @override
  String get copy => 'کاپی کریں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get copied => 'کاپی ہو گیا';

  @override
  String get bookmark => 'بُک مارک کریں';

  @override
  String get removeBookmark => 'بُک مارک ہٹائیں';

  @override
  String get bookmarkAdded => 'بُک مارک شامل ہو گیا';

  @override
  String get bookmarkRemoved => 'بُک مارک ہٹا دیا گیا';

  @override
  String get setAsLastRead => 'یہاں رکنے کا نشان لگائیں';

  @override
  String get lastReadSaved => 'تلاوت کا مقام محفوظ ہو گیا';

  @override
  String get noBookmarks =>
      'ابھی کوئی بُک مارک نہیں۔ تلاوت کے دوران کسی آیت پر ٹیپ کر کے بُک مارک کریں۔';

  @override
  String get fontSize => 'فونٹ کا سائز';

  @override
  String get searchSurah => 'سورت تلاش کریں';

  @override
  String get sajda => 'سجدہ';

  @override
  String get translationUnavailable => 'یہ ترجمہ ابھی ڈاؤن لوڈ نہیں ہوا۔';

  @override
  String get download => 'ڈاؤن لوڈ کریں';

  @override
  String get downloading => 'ڈاؤن لوڈ ہو رہا ہے…';

  @override
  String get translationLanguage => 'ترجمے کی زبان';

  @override
  String get noTranslation => 'کوئی نہیں';

  @override
  String get readerSettings => 'تلاوت کی ترتیبات';

  @override
  String get dailyAyah => 'آج کی آیت';

  @override
  String get skyView => 'آسمان';

  @override
  String get listView => 'فہرست';

  @override
  String khatmahProgress(int percent) {
    return 'قرآن کا $percent٪ پڑھا گیا';
  }

  @override
  String get skyHint => 'ہر ستارہ ایک سورت ہے، جتنا پڑھیں اتنا روشن ہوتا ہے۔';

  @override
  String revelationOrder(int order) {
    return 'نزول کی ترتیب $order از 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'صفحات $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent٪ پڑھا';
  }

  @override
  String get openSurah => 'کھولیں';

  @override
  String get azkar => 'اذکار';

  @override
  String get azkarMorning => 'صبح کے اذکار';

  @override
  String get azkarEvening => 'شام کے اذکار';

  @override
  String get azkarAfterPrayer => 'نماز کے بعد';

  @override
  String get azkarSleep => 'سونے سے پہلے';

  @override
  String get azkarWaking => 'جاگنے پر';

  @override
  String get allCategories => 'تمام دعائیں';

  @override
  String get tapToCount => 'گننے کے لیے ٹیپ کریں';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بار',
      two: 'دو بار',
      one: 'ایک بار',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'مکمل';

  @override
  String get azkarDone => 'اللہ آپ سے قبول فرمائے';

  @override
  String get restart => 'دوبارہ شروع کریں';

  @override
  String progressOf(int done, int total) {
    return '$total میں سے $done';
  }

  @override
  String get source => 'حوالہ';

  @override
  String get virtue => 'فضیلت';

  @override
  String get searchAzkar => 'دعائیں تلاش کریں';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعائیں',
      one: '1 دعا',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'تسبیح';

  @override
  String get reset => 'ری سیٹ';

  @override
  String get target => 'ہدف';

  @override
  String get noTarget => 'کوئی حد نہیں';

  @override
  String totalCount(int count) {
    return 'کل: $count';
  }

  @override
  String rounds(int count) {
    return 'چکر: $count';
  }

  @override
  String get vibration => 'وائبریشن';

  @override
  String get more => 'مزید';

  @override
  String get settings => 'ترتیبات';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get theme => 'تھیم';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeDark => 'گہرا';

  @override
  String get themeLight => 'ہلکا';

  @override
  String get language => 'زبان';

  @override
  String get systemLanguage => 'سسٹم کی زبان';

  @override
  String get numerals => 'اعداد';

  @override
  String get numeralsAuto => 'خودکار (علاقے کے مطابق)';

  @override
  String get numeralsWestern => 'مغربی';

  @override
  String get numeralsArabic => 'عربی (مشرقی)';

  @override
  String get numeralsPersian => 'فارسی / اردو';

  @override
  String get hijriCalendar => 'ہجری کیلنڈر';

  @override
  String get hijriCalendarHint =>
      'ممالک ہمیشہ مہینے کے آغاز پر متفق نہیں ہوتے۔ کیلنڈر کو اپنے مقامی اعلان کے مطابق کر لیں۔';

  @override
  String get hijriMethod => 'کیلنڈر';

  @override
  String get hijriUmmAlQura => 'ام القریٰ (سعودی عرب)';

  @override
  String get hijriTabular => 'حسابی (کویتی الگورتھم)';

  @override
  String get hijriOffset => 'تمام مہینے آگے پیچھے کریں';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days دن',
      one: '1 دن',
      zero: 'کوئی فرق نہیں',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'یہ مہینہ';

  @override
  String hijriMonthStartedOn(String month) {
    return '$month کا آغاز';
  }

  @override
  String get hijriAutomatic => 'خودکار';

  @override
  String get hijriResetAll => 'تمام تصحیحات ری سیٹ کریں';

  @override
  String get hijriCorrections => 'مہینوں کی تصحیحات';

  @override
  String get hijriYearSuffix => 'ھ';

  @override
  String get hijriMonth1 => 'محرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربیع الاول';

  @override
  String get hijriMonth4 => 'ربیع الثانی';

  @override
  String get hijriMonth5 => 'جمادی الاول';

  @override
  String get hijriMonth6 => 'جمادی الثانی';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذوالقعدہ';

  @override
  String get hijriMonth12 => 'ذوالحجہ';

  @override
  String get eidAlFitr => 'عید الفطر';

  @override
  String get eidAlAdha => 'عید الاضحیٰ';

  @override
  String get dayOfArafah => 'یومِ عرفہ';

  @override
  String get ashura => 'عاشورا';

  @override
  String get islamicNewYear => 'اسلامی نیا سال';

  @override
  String get whiteDays => 'ایامِ بیض';

  @override
  String get ramadanBegins => 'رمضان کا آغاز';

  @override
  String get about => 'تعارف';

  @override
  String get aboutText =>
      'سبیلی ایک مسلمان کی روزمرہ زندگی کا مفت ساتھی ہے۔ یہ آف لائن کام کرتی ہے، اس میں کوئی اشتہار نہیں، اور یہ کوئی ڈیٹا جمع نہیں کرتی۔';

  @override
  String get credits => 'ماخذ اور اعتراف';

  @override
  String version(String version) {
    return 'ورژن $version';
  }

  @override
  String get afterPrayer => 'نماز کے بعد';

  @override
  String afterPrayerOf(String prayer) {
    return '$prayer کے بعد';
  }

  @override
  String get afterPrayerHint => 'سلام کے بعد کے اذکار، قدم بہ قدم';

  @override
  String get showTranslation => 'ترجمہ';

  @override
  String get turnTheBeads => 'دانے گھمائیں یا تھپتھپائیں';

  @override
  String get doneStep => 'مکمل';

  @override
  String get previousStep => 'پچھلا';

  @override
  String get skipStep => 'چھوڑیں';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اللہ کے $count اذکار',
      one: 'اللہ کا 1 ذکر',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer میں باقی';
  }

  @override
  String atTime(String time) {
    return '$time پر';
  }

  @override
  String get nowLabel => 'ابھی';

  @override
  String pageAyah(int page, int ayah) {
    return 'صفحہ $page · آیت $ayah';
  }

  @override
  String get tasbihHint => 'دانے گھمائیں';

  @override
  String get azkarHint => 'صبح، شام اور مزید';

  @override
  String get ayahOfTheDay => 'آج کی آیت';

  @override
  String get navToday => 'آج';

  @override
  String get navDhikr => 'ذکر';

  @override
  String get riwayah => 'روایت';

  @override
  String get riwayahAuto => 'خودکار، علاقے کے مطابق';

  @override
  String get riwayahHafs => 'حفص عن عاصم';

  @override
  String get riwayahWarsh => 'ورش عن نافع';

  @override
  String get riwayahQalun => 'قالون عن نافع';

  @override
  String get riwayahHafsHint => 'اکثر مسلم دنیا میں پڑھی جاتی ہے';

  @override
  String get riwayahWarshHint => 'مراکش، الجزائر، موریتانیہ، مغربی افریقہ';

  @override
  String get riwayahQalunHint => 'لیبیا، تیونس';

  @override
  String get riwayahNote =>
      'ہر روایت شاہ فہد کمپلیکس کے اپنے مصحف میں دکھائی جاتی ہے۔ تفسیر اور تراجم آیت بہ آیت اس سے ملائے جاتے ہیں۔';

  @override
  String get general => 'عمومی';

  @override
  String get dhikrSubtitle => 'اللہ کو یاد کرو، وہ تمہیں یاد کرے گا';

  @override
  String get qiblaSubtitle => 'آپ کی جگہ سے کعبہ کی سمت';

  @override
  String get unitHours => 'گھنٹے';

  @override
  String get unitMinutes => 'منٹ';

  @override
  String get unitSeconds => 'سیکنڈ';

  @override
  String get pageColour => 'صفحہ';

  @override
  String get pageAuto => 'خودکار';

  @override
  String get pageNight => 'رات';

  @override
  String get pageSepia => 'سیپیا';

  @override
  String get pagePaper => 'کاغذ';

  @override
  String get welcomeTagline =>
      'نماز، قرآن اور ذکر، اپنے اوپر کے حقیقی آسمان تلے۔ مفت، نجی، اور آپ کا اپنا۔';

  @override
  String get welcomeBegin => 'شروع کریں';

  @override
  String get welcomeNext => 'اگلا';

  @override
  String get welcomeStart => 'آغاز';

  @override
  String get welcomePlaceTitle => 'آپ کہاں ہیں؟';

  @override
  String get welcomeNotifyTitle => 'ہر نماز پر';

  @override
  String get welcomeNotifyBody =>
      'ہر نماز کے وقت آپ کے فون کی آواز کے ساتھ ایک ہلکی اطلاع۔ بعد میں ہر نماز کے لیے الگ ترتیب دیں۔';

  @override
  String get welcomeNotifyAllow => 'اطلاعات کی اجازت دیں';

  @override
  String get welcomeNotifyOn => 'اطلاعات آن ہیں';

  @override
  String get welcomeExactAlarms => 'انہیں عین وقت پر آنے دیں';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'قرآن $riwayah میں کھلتا ہے۔ ترتیبات میں بدل سکتے ہیں۔';
  }

  @override
  String get prepareSoon => 'جلد';

  @override
  String get prepareHint => 'وضو کا وقت';

  @override
  String get channelDaily => 'روزانہ یاد دہانیاں';

  @override
  String get dailyReminders => 'روزانہ یاد دہانیاں';

  @override
  String get dailyMorning => 'صبح کے اذکار';

  @override
  String get dailyMorningBody => 'دن کا آغاز چند منٹ کے ذکر سے کریں۔';

  @override
  String get dailyEvening => 'شام کے اذکار';

  @override
  String get dailyEveningBody => 'دن ڈھلنے پر شام کے اذکار۔';

  @override
  String get dailySleep => 'سونے کے اذکار';

  @override
  String get dailySleepBody => 'دن کا اختتام ذکر سے کریں۔';

  @override
  String get dailyQuran => 'روزانہ تلاوت';

  @override
  String get dailyQuranBody => 'قرآن کا ایک صفحہ آپ کا منتظر ہے۔';

  @override
  String get dailyRemindersIntro =>
      'اذکار اور روزانہ تلاوت کی یاد دہانیاں، آپ کے منتخب وقت پر۔ یہ اختیاری ہیں: ہر روز ایک ہی اطلاع وقت کے ساتھ بوجھ بن سکتی ہے، اس لیے صرف وہی آن کریں جو واقعی مددگار ہوں، اور جب چاہیں بند کر دیں۔';

  @override
  String get dailyRemindersOff => 'بند';

  @override
  String dailyRemindersOn(int count) {
    return '$count آن';
  }

  @override
  String get betaBadge => 'بیٹا';

  @override
  String get betaTitle => 'سبیلی ابھی بیٹا میں ہے';

  @override
  String get betaBody =>
      'ایپ ابھی نئی ہے۔ اس کے متن، تراجم اور معلومات کو ابھی اہلِ علم کی نظرِ ثانی کی ضرورت ہے۔ اگر آپ کو کوئی غلطی نظر آئے، چاہے چھوٹی ہی ہو، تو ہمیں بتائیں: ہر اطلاع مددگار ہے۔';

  @override
  String get betaShakeHint =>
      'کسی بھی اسکرین پر فون ہلائیں تاکہ اسکرین شاٹ کے ساتھ مسئلہ رپورٹ ہو۔';

  @override
  String get betaUnderstood => 'سمجھ گیا';

  @override
  String get reportTitle => 'مسئلہ رپورٹ کریں';

  @override
  String get reportHint => 'کیا غلط ہے؟ (اختیاری)';

  @override
  String get reportSend => 'ای میل سے بھیجیں';

  @override
  String get reportAttach => 'اسکرین شاٹ منسلک کریں';

  @override
  String get reportPrivacy =>
      'آپ کی ای میل ایپ رپورٹ کے ساتھ کھلتی ہے۔ جب تک آپ وہاں بھیجیں نہ دبائیں، کچھ نہیں جاتا۔';

  @override
  String get reportNoMail => 'اس فون پر کوئی ای میل ایپ نہیں ملی';

  @override
  String get shakeToReport => 'مسئلہ رپورٹ کرنے کے لیے ہلائیں';

  @override
  String get khatmahPlan => 'ختم کا منصوبہ';

  @override
  String get planAKhatmah => 'ختم کا منصوبہ بنائیں';

  @override
  String khatmahDays(int days) {
    return '$days دن';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'دن $day از $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'آج: صفحات $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آج $count صفحات باقی',
      one: 'آج 1 صفحہ باقی',
    );
    return '$_temp0';
  }

  @override
  String get khatmahDone => 'آج کا حصہ مکمل';

  @override
  String khatmahPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'روزانہ تقریباً $count صفحات',
      one: 'روزانہ تقریباً 1 صفحہ',
    );
    return '$_temp0';
  }

  @override
  String khatmahEnds(String date) {
    return '$date کو مکمل';
  }

  @override
  String get khatmahFromStart => 'شروع سے';

  @override
  String khatmahFromHere(int page) {
    return 'صفحہ $page سے';
  }

  @override
  String get khatmahStart => 'منصوبہ شروع کریں';

  @override
  String get khatmahEnd => 'منصوبہ ختم کریں';

  @override
  String get khatmahFinished => 'ختم مکمل ہوا۔ اللہ قبول فرمائے۔';

  @override
  String readOnDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'پچھلے 7 میں سے $count دن پڑھا',
      one: 'پچھلے 7 میں سے 1 دن پڑھا',
    );
    return '$_temp0';
  }

  @override
  String get fastRamadan => 'رمضان';

  @override
  String get fastMondayThursday => 'پیر اور جمعرات کا روزہ';

  @override
  String get fastWhiteDays => 'ایامِ بیض';

  @override
  String get fastArafah => 'یومِ عرفہ';

  @override
  String get fastAshura => 'تاسوعا و عاشورا';

  @override
  String fastTomorrow(String name) {
    return 'کل: $name';
  }

  @override
  String get fastTomorrowBody =>
      'روزہ رکھنے کے خواہش مند کے لیے یاد دہانی۔ سحری فجر سے پہلے۔';

  @override
  String get suhoorTitle => 'سحری';

  @override
  String suhoorBody(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'فجر میں $minutes منٹ',
      one: 'فجر میں 1 منٹ',
    );
    return '$_temp0';
  }

  @override
  String get fastingReminders => 'روزہ';

  @override
  String get fastReminderTitle => 'نفلی روزے';

  @override
  String get fastReminderBody => 'سنت روزے سے پہلی شام۔';

  @override
  String get suhoorReminderTitle => 'رمضان میں سحری';

  @override
  String get suhoorReminderBody => 'رمضان میں فجر سے پہلے۔';

  @override
  String get iftarIn => 'افطار میں';

  @override
  String get suhoorEndsIn => 'سحری ختم ہونے میں';

  @override
  String ramadanDay(int day) {
    return 'رمضان · دن $day';
  }

  @override
  String fastToday(String name) {
    return 'آج: $name';
  }

  @override
  String iftarAt(String time) {
    return 'افطار $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'سحری $time تک';
  }

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get sourceCode => 'سورس کوڈ (GPL-3.0)';
}
