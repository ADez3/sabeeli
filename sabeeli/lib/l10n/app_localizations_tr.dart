// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Her günkü yolunuz';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navQuran => 'Kur\'an';

  @override
  String get navPrayer => 'Namaz';

  @override
  String get navAzkar => 'Zikirler';

  @override
  String get navMore => 'Daha fazla';

  @override
  String get prayerFajr => 'Sabah';

  @override
  String get prayerSunrise => 'Güneş';

  @override
  String get prayerDhuhr => 'Öğle';

  @override
  String get prayerJumuah => 'Cuma';

  @override
  String get prayerAsr => 'İkindi';

  @override
  String get prayerMaghrib => 'Akşam';

  @override
  String get prayerIsha => 'Yatsı';

  @override
  String get midnight => 'Gece yarısı';

  @override
  String get lastThird => 'Gecenin son üçte biri';

  @override
  String get salam => 'Selamün aleyküm';

  @override
  String get nextPrayer => 'Sonraki namaz';

  @override
  String prayerTimeNow(String prayer) {
    return '$prayer vakti girdi';
  }

  @override
  String timeUntil(String duration) {
    return '$duration sonra';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get today => 'Bugün';

  @override
  String get tomorrow => 'Yarın';

  @override
  String get prayerTimes => 'Namaz vakitleri';

  @override
  String get location => 'Konum';

  @override
  String get setLocation => 'Konumunuzu belirleyin';

  @override
  String get setLocationHint =>
      'Namaz vakitleri ve kıble, bulunduğunuz yere göre hesaplanır. Konumunuz cihazınızdan asla çıkmaz.';

  @override
  String get useCurrentLocation => 'Mevcut konumumu kullan';

  @override
  String get searchCity => 'Şehir ara';

  @override
  String get searchCityHint => 'Şehir adı';

  @override
  String get locating => 'Konumunuz bulunuyor…';

  @override
  String get locationDisabled => 'Konum servisleri kapalı.';

  @override
  String get locationDenied => 'Konum izni reddedildi.';

  @override
  String get locationDeniedForever =>
      'Konum izni engellendi. Uygulama ayarlarından izin verin.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get unknownPlace => 'Mevcut konum';

  @override
  String get noResults => 'Sonuç yok';

  @override
  String get networkError =>
      'Bağlantı yok. İnternetinizi kontrol edip tekrar deneyin.';

  @override
  String get genericError => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get calculation => 'Hesaplama';

  @override
  String get calculationMethod => 'Hesaplama yöntemi';

  @override
  String get asrMethod => 'İkindi vakti';

  @override
  String get asrStandard => 'Standart (Şafii, Maliki, Hanbeli)';

  @override
  String get asrHanafi => 'Hanefi';

  @override
  String get highLatitudeRule => 'Yüksek enlem kuralı';

  @override
  String get highLatMiddle => 'Gecenin ortası';

  @override
  String get highLatSeventh => 'Gecenin yedide biri';

  @override
  String get highLatAngle => 'Alacakaranlık açısı';

  @override
  String get highLatNone => 'Yok';

  @override
  String get adjustments => 'Manuel düzeltmeler';

  @override
  String get adjustmentsHint =>
      'Yerel caminize uyması için dakika ekleyin veya çıkarın.';

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String get methodMuslimWorldLeague => 'Müslüman Dünya Birliği';

  @override
  String get methodEgyptian => 'Mısır Genel Harita Kurumu';

  @override
  String get methodKarachi => 'İslami İlimler Üniversitesi, Karaçi';

  @override
  String get methodUmmAlQura => 'Ümmü\'l-Kurâ, Mekke';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodQatar => 'Katar';

  @override
  String get methodKuwait => 'Kuveyt';

  @override
  String get methodNorthAmerica => 'Kuzey Amerika İslam Cemiyeti (ISNA)';

  @override
  String get methodSingapore => 'Singapur (MUIS)';

  @override
  String get methodTurkey => 'Diyanet, Türkiye';

  @override
  String get methodTehran => 'Jeofizik Enstitüsü, Tahran';

  @override
  String get methodFrance => 'Fransa (UOIF, 12°)';

  @override
  String get methodRussia => 'Rusya Müslümanları Dini İdaresi';

  @override
  String get methodMorocco => 'Habous Bakanlığı, Fas';

  @override
  String get methodAlgeria => 'Din İşleri Bakanlığı, Cezayir';

  @override
  String get methodTunisia => 'Tunus';

  @override
  String get methodJordan => 'Evkaf Bakanlığı, Ürdün';

  @override
  String get methodIndonesia => 'Kemenag, Endonezya';

  @override
  String get methodMalaysia => 'JAKIM, Malezya';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationSound => 'Bildirim sesi';

  @override
  String get notificationSilent => 'Sessiz';

  @override
  String get notificationOff => 'Kapalı';

  @override
  String get reminderBefore => 'Önceden hatırlat';

  @override
  String get reminderOff => 'Hatırlatma yok';

  @override
  String minutesBefore(int minutes) {
    return '$minutes dk önce';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return '$prayer namazı vakti girdi';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer vaktine $minutes dakika kaldı';
  }

  @override
  String get notificationsBlocked => 'Sabeeli için bildirimler kapalı.';

  @override
  String get exactAlarmsNeeded =>
      'Namaz bildirimlerinin tam vaktinde gelmesi için \"Alarmlar ve hatırlatıcılar\" iznini verin.';

  @override
  String get allow => 'İzin ver';

  @override
  String get channelSilent => 'Sessiz namaz bildirimleri';

  @override
  String get channelPrayer => 'Namaz vakitleri';

  @override
  String get channelReminder => 'Namaz hatırlatıcıları';

  @override
  String get qibla => 'Kıble';

  @override
  String get qiblaDirection => 'Kıble yönü';

  @override
  String get facingQibla => 'Kıbleye yöneldiniz';

  @override
  String get turnTowards => 'Ok yukarıyı gösterene kadar dönün';

  @override
  String degreesFromNorth(String degrees) {
    return 'Kuzeyden $degrees°';
  }

  @override
  String distanceToKaaba(String distance) {
    return 'Kâbe\'ye $distance km';
  }

  @override
  String get calibrateCompass =>
      'Pusula hassasiyeti düşük. Kalibre etmek için telefonunuzu sekiz çizerek hareket ettirin.';

  @override
  String get compassUnavailable =>
      'Bu cihazda pusula yok. Aşağıdaki açıyı gerçek bir pusulayla kullanın.';

  @override
  String get qiblaNeedsLocation => 'Kıbleyi bulmak için konumunuzu belirleyin.';

  @override
  String get quran => 'Kur\'an-ı Kerim';

  @override
  String get surahs => 'Sureler';

  @override
  String get juzs => 'Cüzler';

  @override
  String get bookmarks => 'Yer imleri';

  @override
  String juzNumber(int number) {
    return '$number. Cüz';
  }

  @override
  String pageNumber(int number) {
    return 'Sayfa $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayet',
      one: '1 ayet',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, $ayah. ayet';
  }

  @override
  String get meccan => 'Mekki';

  @override
  String get medinan => 'Medeni';

  @override
  String get continueReading => 'Okumaya devam et';

  @override
  String get startReading => 'Okumaya başla';

  @override
  String get lastRead => 'Son okunan';

  @override
  String get tafsir => 'Tefsir';

  @override
  String get tafsirMuyassar => 'Tefsir el-Müyesser';

  @override
  String get translation => 'Meal';

  @override
  String get copy => 'Kopyala';

  @override
  String get share => 'Paylaş';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get bookmark => 'Yer imi ekle';

  @override
  String get removeBookmark => 'Yer imini kaldır';

  @override
  String get bookmarkAdded => 'Yer imi eklendi';

  @override
  String get bookmarkRemoved => 'Yer imi kaldırıldı';

  @override
  String get setAsLastRead => 'Kaldığım yer olarak işaretle';

  @override
  String get lastReadSaved => 'Okuma konumu kaydedildi';

  @override
  String get noBookmarks =>
      'Henüz yer imi yok. Okurken bir ayete dokunarak yer imi ekleyin.';

  @override
  String get fontSize => 'Yazı boyutu';

  @override
  String get searchSurah => 'Sure ara';

  @override
  String get sajda => 'Secde';

  @override
  String get translationUnavailable => 'Bu meal henüz indirilmedi.';

  @override
  String get download => 'İndir';

  @override
  String get downloading => 'İndiriliyor…';

  @override
  String get translationLanguage => 'Meal dili';

  @override
  String get noTranslation => 'Yok';

  @override
  String get readerSettings => 'Okuma ayarları';

  @override
  String get dailyAyah => 'Günün ayeti';

  @override
  String get azkar => 'Zikirler';

  @override
  String get azkarMorning => 'Sabah zikirleri';

  @override
  String get azkarEvening => 'Akşam zikirleri';

  @override
  String get azkarAfterPrayer => 'Namazdan sonra';

  @override
  String get azkarSleep => 'Uyumadan önce';

  @override
  String get azkarWaking => 'Uyanınca';

  @override
  String get allCategories => 'Tüm dualar';

  @override
  String get tapToCount => 'Saymak için dokunun';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez',
      two: 'İki kez',
      one: 'Bir kez',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Tamamlandı';

  @override
  String get azkarDone => 'Allah kabul etsin';

  @override
  String get restart => 'Yeniden başla';

  @override
  String progressOf(int done, int total) {
    return '$done / $total';
  }

  @override
  String get source => 'Kaynak';

  @override
  String get virtue => 'Fazileti';

  @override
  String get searchAzkar => 'Dua ara';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dua',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Tesbih';

  @override
  String get reset => 'Sıfırla';

  @override
  String get target => 'Hedef';

  @override
  String get noTarget => 'Sınırsız';

  @override
  String totalCount(int count) {
    return 'Toplam: $count';
  }

  @override
  String rounds(int count) {
    return 'Tur: $count';
  }

  @override
  String get vibration => 'Titreşim';

  @override
  String get more => 'Daha fazla';

  @override
  String get settings => 'Ayarlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get language => 'Dil';

  @override
  String get systemLanguage => 'Sistem dili';

  @override
  String get numerals => 'Rakamlar';

  @override
  String get numeralsAuto => 'Otomatik (bölgeye göre)';

  @override
  String get numeralsWestern => 'Batı';

  @override
  String get numeralsArabic => 'Arap (Doğu)';

  @override
  String get numeralsPersian => 'Farsça / Urduca';

  @override
  String get hijriCalendar => 'Hicri takvim';

  @override
  String get hijriCalendarHint =>
      'Ülkeler bir ayın ne zaman başladığı konusunda her zaman hemfikir değildir. Takvimi yerel ilana göre ayarlayın.';

  @override
  String get hijriMethod => 'Takvim';

  @override
  String get hijriUmmAlQura => 'Ümmü\'l-Kurâ (Suudi Arabistan)';

  @override
  String get hijriTabular => 'Aritmetik (Kuveyt algoritması)';

  @override
  String get hijriOffset => 'Tüm ayları kaydır';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
      one: '1 gün',
      zero: 'Kaydırma yok',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'Bu ay';

  @override
  String hijriMonthStartedOn(String month) {
    return '$month ayının başlangıcı';
  }

  @override
  String get hijriAutomatic => 'Otomatik';

  @override
  String get hijriResetAll => 'Tüm düzeltmeleri sıfırla';

  @override
  String get hijriCorrections => 'Ay düzeltmeleri';

  @override
  String get hijriYearSuffix => 'H';

  @override
  String get hijriMonth1 => 'Muharrem';

  @override
  String get hijriMonth2 => 'Safer';

  @override
  String get hijriMonth3 => 'Rebiülevvel';

  @override
  String get hijriMonth4 => 'Rebiülahir';

  @override
  String get hijriMonth5 => 'Cemaziyelevvel';

  @override
  String get hijriMonth6 => 'Cemaziyelahir';

  @override
  String get hijriMonth7 => 'Recep';

  @override
  String get hijriMonth8 => 'Şaban';

  @override
  String get hijriMonth9 => 'Ramazan';

  @override
  String get hijriMonth10 => 'Şevval';

  @override
  String get hijriMonth11 => 'Zilkade';

  @override
  String get hijriMonth12 => 'Zilhicce';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutText =>
      'Sabeeli, bir Müslümanın günlük hayatı için ücretsiz bir yol arkadaşıdır. Çevrimdışı çalışır, reklam içermez ve hiçbir veri toplamaz.';

  @override
  String get credits => 'Kaynaklar ve teşekkürler';

  @override
  String version(String version) {
    return 'Sürüm $version';
  }
}
