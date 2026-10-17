// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Jalanmu setiap hari';

  @override
  String get navHome => 'Utama';

  @override
  String get navQuran => 'Al-Quran';

  @override
  String get navPrayer => 'Solat';

  @override
  String get navAzkar => 'Zikir';

  @override
  String get navMore => 'Lagi';

  @override
  String get prayerFajr => 'Subuh';

  @override
  String get prayerSunrise => 'Syuruk';

  @override
  String get prayerDhuhr => 'Zohor';

  @override
  String get prayerJumuah => 'Jumaat';

  @override
  String get prayerAsr => 'Asar';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isyak';

  @override
  String get midnight => 'Tengah malam';

  @override
  String get lastThird => 'Sepertiga malam terakhir';

  @override
  String get salam => 'Assalamualaikum';

  @override
  String get nextPrayer => 'Solat seterusnya';

  @override
  String prayerTimeNow(String prayer) {
    return 'Telah masuk waktu $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'dalam $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours j $minutes min';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get tomorrow => 'Esok';

  @override
  String get prayerTimes => 'Waktu solat';

  @override
  String get diveHint => 'Leret ke atas untuk harimu';

  @override
  String get now => 'Sekarang';

  @override
  String get yourDay => 'Harimu';

  @override
  String get location => 'Lokasi';

  @override
  String get setLocation => 'Tetapkan lokasi anda';

  @override
  String get setLocationHint =>
      'Waktu solat dan kiblat dikira dalam telefon anda berdasarkan lokasi anda. Hanya kedudukan yang dibundarkan dihantar ke OpenStreetMap, untuk menamakan bandar anda.';

  @override
  String get useCurrentLocation => 'Guna lokasi semasa saya';

  @override
  String get searchCity => 'Cari bandar';

  @override
  String get searchCityHint => 'Nama bandar';

  @override
  String get locating => 'Mencari lokasi anda…';

  @override
  String get locationDisabled => 'Perkhidmatan lokasi dimatikan.';

  @override
  String get locationDenied => 'Kebenaran lokasi ditolak.';

  @override
  String get locationDeniedForever =>
      'Kebenaran lokasi disekat. Benarkan melalui tetapan aplikasi.';

  @override
  String get openSettings => 'Buka tetapan';

  @override
  String get unknownPlace => 'Lokasi semasa';

  @override
  String get noResults => 'Tiada hasil';

  @override
  String get networkError =>
      'Tiada sambungan. Semak internet anda dan cuba lagi.';

  @override
  String get genericError => 'Berlaku ralat. Sila cuba lagi.';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get calculation => 'Pengiraan';

  @override
  String get calculationMethod => 'Kaedah pengiraan';

  @override
  String get asrMethod => 'Waktu Asar';

  @override
  String get asrStandard => 'Standard (Syafie, Maliki, Hanbali)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get highLatitudeRule => 'Peraturan latitud tinggi';

  @override
  String get highLatMiddle => 'Tengah malam';

  @override
  String get highLatSeventh => 'Satu pertujuh malam';

  @override
  String get highLatAngle => 'Sudut senja';

  @override
  String get highLatNone => 'Tiada';

  @override
  String get adjustments => 'Pelarasan manual';

  @override
  String get adjustmentsHint =>
      'Tambah atau kurangkan minit supaya sepadan dengan masjid tempatan anda.';

  @override
  String get hourShift => 'Pembetulan jam';

  @override
  String get hourShiftHint =>
      'Hanya jika semua waktu tersasar beberapa jam penuh: zon waktu telefon anda salah (contohnya masih GMT+1 selepas negara menukar waktunya). Lebih baik tetapkan zon waktu yang betul pada telefon.';

  @override
  String hoursShort(int hours) {
    return '$hours j';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get methodMuslimWorldLeague => 'Liga Muslim Sedunia';

  @override
  String get methodEgyptian => 'Pihak Berkuasa Ukur Am Mesir';

  @override
  String get methodKarachi => 'Universiti Sains Islam, Karachi';

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
  String get methodSingapore => 'Singapura (MUIS)';

  @override
  String get methodTurkey => 'Diyanet, Turki';

  @override
  String get methodTehran => 'Institut Geofizik, Tehran';

  @override
  String get methodFrance => 'Perancis (UOIF, 12°)';

  @override
  String get methodRussia => 'Pentadbiran Rohani Muslim Rusia';

  @override
  String get methodMorocco => 'Kementerian Habous, Maghribi';

  @override
  String get methodAlgeria => 'Kementerian Hal Ehwal Agama, Algeria';

  @override
  String get methodTunisia => 'Tunisia';

  @override
  String get methodJordan => 'Kementerian Wakaf, Jordan';

  @override
  String get methodIndonesia => 'Kemenag, Indonesia';

  @override
  String get methodMalaysia => 'JAKIM, Malaysia';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get notificationSound => 'Bunyi pemberitahuan';

  @override
  String get notificationSilent => 'Senyap';

  @override
  String get notificationOff => 'Mati';

  @override
  String get reminderBefore => 'Peringatan sebelum';

  @override
  String get reminderOff => 'Tiada peringatan';

  @override
  String minutesBefore(int minutes) {
    return '$minutes min sebelum';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'Telah masuk waktu solat $prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer dalam $minutes minit';
  }

  @override
  String get notificationsBlocked => 'Pemberitahuan dimatikan untuk Sabeeli.';

  @override
  String get exactAlarmsNeeded =>
      'Benarkan \"Penggera & peringatan\" supaya pemberitahuan solat tiba tepat pada waktunya.';

  @override
  String get allow => 'Benarkan';

  @override
  String get channelSilent => 'Pemberitahuan solat senyap';

  @override
  String get channelPrayer => 'Waktu solat';

  @override
  String get channelReminder => 'Peringatan solat';

  @override
  String get qibla => 'Kiblat';

  @override
  String get qiblaDirection => 'Arah kiblat';

  @override
  String get facingQibla => 'Anda sedang menghadap kiblat';

  @override
  String get turnTowards => 'Pusing sehingga anak panah menghala ke atas';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° dari utara';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance km ke Kaabah';
  }

  @override
  String get calibrateCompass =>
      'Ketepatan kompas rendah. Gerakkan telefon membentuk angka lapan untuk menentukur.';

  @override
  String get compassUnavailable =>
      'Peranti ini tiada kompas. Gunakan arah di bawah dengan kompas fizikal.';

  @override
  String get qiblaNeedsLocation =>
      'Tetapkan lokasi anda untuk mencari arah kiblat.';

  @override
  String get you => 'Anda';

  @override
  String get makkah => 'Makkah';

  @override
  String get qiblaGreatCircle =>
      'Kiblat mengikut laluan terpendek di atas Bumi, bukan garis lurus pada peta rata.';

  @override
  String get globeView => 'Glob';

  @override
  String get compassView => 'Kompas';

  @override
  String get quran => 'Al-Quran Al-Karim';

  @override
  String get surahs => 'Surah';

  @override
  String get juzs => 'Juzuk';

  @override
  String get bookmarks => 'Penanda';

  @override
  String juzNumber(int number) {
    return 'Juzuk $number';
  }

  @override
  String pageNumber(int number) {
    return 'Halaman $number';
  }

  @override
  String ayahCount(int count) {
    return '$count ayat';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, ayat $ayah';
  }

  @override
  String get meccan => 'Makkiyah';

  @override
  String get medinan => 'Madaniyah';

  @override
  String get continueReading => 'Sambung membaca';

  @override
  String get startReading => 'Mula membaca';

  @override
  String get lastRead => 'Bacaan terakhir';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get tafsirMuyassar => 'Tafsir al-Muyassar';

  @override
  String get translation => 'Terjemahan';

  @override
  String get copy => 'Salin';

  @override
  String get share => 'Kongsi';

  @override
  String get copied => 'Disalin';

  @override
  String get bookmark => 'Tanda';

  @override
  String get removeBookmark => 'Buang penanda';

  @override
  String get bookmarkAdded => 'Penanda ditambah';

  @override
  String get bookmarkRemoved => 'Penanda dibuang';

  @override
  String get setAsLastRead => 'Tanda sebagai tempat saya berhenti';

  @override
  String get lastReadSaved => 'Kedudukan bacaan disimpan';

  @override
  String get noBookmarks =>
      'Belum ada penanda. Ketik satu ayat semasa membaca untuk menandanya.';

  @override
  String get fontSize => 'Saiz fon';

  @override
  String get searchSurah => 'Cari surah';

  @override
  String get sajda => 'Sajdah';

  @override
  String get translationUnavailable => 'Terjemahan ini belum dimuat turun.';

  @override
  String get download => 'Muat turun';

  @override
  String get downloading => 'Memuat turun…';

  @override
  String get translationLanguage => 'Bahasa terjemahan';

  @override
  String get noTranslation => 'Tiada';

  @override
  String get readerSettings => 'Tetapan bacaan';

  @override
  String get dailyAyah => 'Ayat hari ini';

  @override
  String get skyView => 'Langit';

  @override
  String get listView => 'Senarai';

  @override
  String khatmahProgress(int percent) {
    return '$percent% al-Quran telah dibaca';
  }

  @override
  String get skyHint =>
      'Setiap bintang ialah satu surah. Ia semakin terang apabila anda membacanya.';

  @override
  String revelationOrder(int order) {
    return 'Turun ke-$order daripada 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'Halaman $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return '$percent% dibaca';
  }

  @override
  String get openSurah => 'Buka';

  @override
  String get azkar => 'Zikir';

  @override
  String get azkarMorning => 'Zikir pagi';

  @override
  String get azkarEvening => 'Zikir petang';

  @override
  String get azkarAfterPrayer => 'Selepas solat';

  @override
  String get azkarSleep => 'Sebelum tidur';

  @override
  String get azkarWaking => 'Ketika bangun tidur';

  @override
  String get allCategories => 'Semua doa';

  @override
  String get tapToCount => 'Ketik untuk mengira';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali',
      two: 'Dua kali',
      one: 'Sekali',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Selesai';

  @override
  String get azkarDone => 'Semoga Allah menerima amalan anda';

  @override
  String get restart => 'Mula semula';

  @override
  String progressOf(int done, int total) {
    return '$done daripada $total';
  }

  @override
  String get source => 'Sumber';

  @override
  String get virtue => 'Kelebihan';

  @override
  String get searchAzkar => 'Cari doa';

  @override
  String itemsCount(int count) {
    return '$count doa';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Set semula';

  @override
  String get target => 'Sasaran';

  @override
  String get noTarget => 'Tiada had';

  @override
  String totalCount(int count) {
    return 'Jumlah: $count';
  }

  @override
  String rounds(int count) {
    return 'Pusingan: $count';
  }

  @override
  String get vibration => 'Getaran';

  @override
  String get more => 'Lagi';

  @override
  String get settings => 'Tetapan';

  @override
  String get appearance => 'Paparan';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Cerah';

  @override
  String get language => 'Bahasa';

  @override
  String get systemLanguage => 'Bahasa sistem';

  @override
  String get numerals => 'Angka';

  @override
  String get numeralsAuto => 'Automatik (ikut wilayah)';

  @override
  String get numeralsWestern => 'Barat';

  @override
  String get numeralsArabic => 'Arab (Timur)';

  @override
  String get numeralsPersian => 'Parsi / Urdu';

  @override
  String get hijriCalendar => 'Kalendar Hijrah';

  @override
  String get hijriCalendarHint =>
      'Negara-negara tidak selalu sepakat bila sesuatu bulan bermula. Laraskan kalendar mengikut pengumuman tempatan anda.';

  @override
  String get hijriMethod => 'Kalendar';

  @override
  String get hijriUmmAlQura => 'Umm al-Qura (Arab Saudi)';

  @override
  String get hijriTabular => 'Aritmetik (algoritma Kuwait)';

  @override
  String get hijriOffset => 'Anjak semua bulan';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      zero: 'Tiada anjakan',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'Bulan ini';

  @override
  String hijriMonthStartedOn(String month) {
    return 'Awal $month';
  }

  @override
  String get hijriAutomatic => 'Automatik';

  @override
  String get hijriResetAll => 'Set semula semua pembetulan';

  @override
  String get hijriCorrections => 'Pembetulan bulan';

  @override
  String get hijriYearSuffix => 'H';

  @override
  String get hijriMonth1 => 'Muharam';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabiulawal';

  @override
  String get hijriMonth4 => 'Rabiulakhir';

  @override
  String get hijriMonth5 => 'Jamadilawal';

  @override
  String get hijriMonth6 => 'Jamadilakhir';

  @override
  String get hijriMonth7 => 'Rejab';

  @override
  String get hijriMonth8 => 'Syaaban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Syawal';

  @override
  String get hijriMonth11 => 'Zulkaedah';

  @override
  String get hijriMonth12 => 'Zulhijjah';

  @override
  String get eidAlFitr => 'Aidilfitri';

  @override
  String get eidAlAdha => 'Aidiladha';

  @override
  String get dayOfArafah => 'Hari Arafah';

  @override
  String get ashura => 'Asyura';

  @override
  String get islamicNewYear => 'Awal Muharam';

  @override
  String get whiteDays => 'Hari-hari putih';

  @override
  String get ramadanBegins => 'Awal Ramadan';

  @override
  String get about => 'Perihal';

  @override
  String get aboutText =>
      'Sabeeli ialah peneman percuma untuk kehidupan harian seorang Muslim. Ia berfungsi di luar talian, tiada iklan dan tidak mengumpul sebarang data.';

  @override
  String get credits => 'Sumber & penghargaan';

  @override
  String version(String version) {
    return 'Versi $version';
  }

  @override
  String get afterPrayer => 'Selepas solat';

  @override
  String afterPrayerOf(String prayer) {
    return 'Selepas $prayer';
  }

  @override
  String get afterPrayerHint => 'Wirid selepas salam, langkah demi langkah';

  @override
  String get showTranslation => 'Terjemahan';

  @override
  String get turnTheBeads => 'Putar biji tasbih, atau ketik';

  @override
  String get doneStep => 'Selesai';

  @override
  String get previousStep => 'Sebelumnya';

  @override
  String get skipStep => 'Langkau';

  @override
  String remembrances(int count) {
    return '$count zikir kepada Allah';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer dalam';
  }

  @override
  String atTime(String time) {
    return 'pada $time';
  }

  @override
  String get nowLabel => 'Sekarang';

  @override
  String pageAyah(int page, int ayah) {
    return 'Halaman $page · Ayat $ayah';
  }

  @override
  String get tasbihHint => 'Putar biji tasbih';

  @override
  String get azkarHint => 'Pagi, petang dan lain-lain';

  @override
  String get ayahOfTheDay => 'Ayat hari ini';

  @override
  String get navToday => 'Hari ini';

  @override
  String get navDhikr => 'Zikir';

  @override
  String get riwayah => 'Riwayat';

  @override
  String get riwayahAuto => 'Automatik, ikut wilayah';

  @override
  String get riwayahHafs => 'Hafs daripada ʿAsim';

  @override
  String get riwayahWarsh => 'Warsy daripada Nafiʿ';

  @override
  String get riwayahQalun => 'Qalun daripada Nafiʿ';

  @override
  String get riwayahHafsHint => 'Dibaca di kebanyakan dunia Islam';

  @override
  String get riwayahWarshHint => 'Maghribi, Algeria, Mauritania, Afrika Barat';

  @override
  String get riwayahQalunHint => 'Libya, Tunisia';

  @override
  String get riwayahNote =>
      'Setiap riwayat dipaparkan dalam mushafnya sendiri daripada Kompleks Raja Fahd. Tafsir dan terjemahan dipadankan dengannya ayat demi ayat.';

  @override
  String get general => 'Umum';

  @override
  String get dhikrSubtitle => 'Ingatlah Allah, nescaya Dia mengingatimu';

  @override
  String get qiblaSubtitle => 'Arah Kaabah dari tempat anda';

  @override
  String get unitHours => 'j';

  @override
  String get unitMinutes => 'min';

  @override
  String get unitSeconds => 's';

  @override
  String get pageColour => 'Halaman';

  @override
  String get pageAuto => 'Auto';

  @override
  String get pageNight => 'Malam';

  @override
  String get pageSepia => 'Sepia';

  @override
  String get pagePaper => 'Kertas';

  @override
  String get welcomeTagline =>
      'Solat, al-Quran dan zikir, di bawah langit sebenar di atas anda. Percuma, peribadi dan milik anda.';

  @override
  String get welcomeBegin => 'Mula';

  @override
  String get welcomeNext => 'Seterusnya';

  @override
  String get welcomeStart => 'Mulakan';

  @override
  String get welcomePlaceTitle => 'Di manakah anda?';

  @override
  String get welcomeNotifyTitle => 'Pada setiap solat';

  @override
  String get welcomeNotifyBody =>
      'Pemberitahuan lembut dengan bunyi telefon anda sendiri apabila tiba waktu solat. Pilih untuk setiap solat kemudian.';

  @override
  String get welcomeNotifyAllow => 'Benarkan pemberitahuan';

  @override
  String get welcomeNotifyOn => 'Pemberitahuan dihidupkan';

  @override
  String get welcomeExactAlarms => 'Terima tepat pada minitnya';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'Al-Quran dibuka dengan riwayat $riwayah. Anda boleh menukarnya dalam Tetapan.';
  }

  @override
  String get prepareSoon => 'Tidak lama lagi';

  @override
  String get prepareHint => 'masa untuk berwuduk';

  @override
  String get channelDaily => 'Peringatan harian';

  @override
  String get dailyReminders => 'Peringatan harian';

  @override
  String get dailyMorning => 'Zikir pagi';

  @override
  String get dailyMorningBody =>
      'Beberapa minit berzikir untuk memulakan hari.';

  @override
  String get dailyEvening => 'Zikir petang';

  @override
  String get dailyEveningBody => 'Zikir petang, ketika hari berganti.';

  @override
  String get dailySleep => 'Zikir sebelum tidur';

  @override
  String get dailySleepBody => 'Akhiri hari dengan zikir.';

  @override
  String get dailyQuran => 'Bacaan harian anda';

  @override
  String get dailyQuranBody => 'Satu halaman al-Quran sedang menanti anda.';

  @override
  String get dailyRemindersIntro =>
      'Peringatan untuk zikir dan bacaan harian anda, pada waktu pilihan anda. Semuanya pilihan: pemberitahuan yang sama setiap hari boleh menjadi gangguan lama-kelamaan, jadi hidupkan hanya yang benar-benar membantu, dan matikan bila-bila masa.';

  @override
  String get dailyRemindersOff => 'Mati';

  @override
  String dailyRemindersOn(int count) {
    return '$count hidup';
  }

  @override
  String get betaBadge => 'Beta';

  @override
  String get betaTitle => 'Sabeeli masih beta';

  @override
  String get betaBody =>
      'Aplikasi ini masih baharu. Teks, terjemahan dan maklumat yang dipaparkan masih perlu disemak oleh ahli ilmu. Jika anda menemui sebarang kesilapan, walaupun kecil, sila beritahu kami: setiap laporan membantu.';

  @override
  String get betaShakeHint =>
      'Goncang telefon anda di mana-mana skrin untuk melaporkan masalah, berserta tangkapan skrin.';

  @override
  String get betaUnderstood => 'Saya faham';

  @override
  String get reportTitle => 'Laporkan masalah';

  @override
  String get reportHint => 'Apakah yang salah? (pilihan)';

  @override
  String get reportSend => 'Hantar melalui e-mel';

  @override
  String get reportAttach => 'Lampirkan tangkapan skrin';

  @override
  String get reportPrivacy =>
      'Aplikasi e-mel anda dibuka dengan laporan yang sedia. Tiada apa-apa dihantar sehingga anda menekan hantar di sana.';

  @override
  String get reportNoMail => 'Tiada aplikasi e-mel ditemui pada telefon ini';

  @override
  String get shakeToReport => 'Goncang untuk melaporkan masalah';

  @override
  String get khatmahPlan => 'Rancangan khatam';

  @override
  String get planAKhatmah => 'Rancang khatam';

  @override
  String khatmahDays(int days) {
    return '$days hari';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'Hari $day daripada $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'Hari ini: halaman $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    return '$count halaman lagi hari ini';
  }

  @override
  String get khatmahDone => 'Bahagian hari ini selesai';

  @override
  String khatmahPerDay(int count) {
    return 'Kira-kira $count halaman sehari';
  }

  @override
  String khatmahEnds(String date) {
    return 'tamat pada $date';
  }

  @override
  String get khatmahFromStart => 'Dari awal';

  @override
  String khatmahFromHere(int page) {
    return 'Dari halaman $page';
  }

  @override
  String get khatmahStart => 'Mulakan rancangan';

  @override
  String get khatmahEnd => 'Tamatkan rancangan';

  @override
  String get khatmahFinished => 'Khatam selesai. Semoga Allah menerimanya.';

  @override
  String readOnDays(int count) {
    return 'Membaca pada $count daripada 7 hari lepas';
  }

  @override
  String get fastRamadan => 'Ramadan';

  @override
  String get fastMondayThursday => 'Isnin dan Khamis';

  @override
  String get fastWhiteDays => 'Hari-hari putih';

  @override
  String get fastArafah => 'Hari Arafah';

  @override
  String get fastAshura => 'Tasu‘a dan ‘Asyura';

  @override
  String fastTomorrow(String name) {
    return 'Esok: $name';
  }

  @override
  String get fastTomorrowBody =>
      'Peringatan bagi yang ingin berpuasa. Bersahur sebelum Subuh.';

  @override
  String get suhoorTitle => 'Sahur';

  @override
  String suhoorBody(int minutes) {
    return 'Subuh dalam $minutes minit';
  }

  @override
  String get fastingReminders => 'Puasa';

  @override
  String get fastReminderTitle => 'Puasa sunat';

  @override
  String get fastReminderBody => 'Petang sebelum puasa sunat.';

  @override
  String get suhoorReminderTitle => 'Sahur pada bulan Ramadan';

  @override
  String get suhoorReminderBody => 'Sebelum Subuh, sepanjang Ramadan.';

  @override
  String get iftarIn => 'Berbuka dalam';

  @override
  String get suhoorEndsIn => 'Sahur tamat dalam';

  @override
  String ramadanDay(int day) {
    return 'Ramadan · hari ke-$day';
  }

  @override
  String fastToday(String name) {
    return 'Hari ini: $name';
  }

  @override
  String iftarAt(String time) {
    return 'Berbuka $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'Sahur hingga $time';
  }

  @override
  String get privacyPolicy => 'Dasar privasi';

  @override
  String get sourceCode => 'Kod sumber (GPL-3.0)';
}
