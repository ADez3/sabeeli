// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Jalanmu setiap hari';

  @override
  String get navHome => 'Beranda';

  @override
  String get navQuran => 'Al-Qur\'an';

  @override
  String get navPrayer => 'Salat';

  @override
  String get navAzkar => 'Zikir';

  @override
  String get navMore => 'Lainnya';

  @override
  String get prayerFajr => 'Subuh';

  @override
  String get prayerSunrise => 'Terbit';

  @override
  String get prayerDhuhr => 'Zuhur';

  @override
  String get prayerJumuah => 'Jumat';

  @override
  String get prayerAsr => 'Asar';

  @override
  String get prayerMaghrib => 'Magrib';

  @override
  String get prayerIsha => 'Isya';

  @override
  String get midnight => 'Tengah malam';

  @override
  String get lastThird => 'Sepertiga malam terakhir';

  @override
  String get salam => 'Assalamualaikum';

  @override
  String get nextPrayer => 'Salat berikutnya';

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
    return '$hours j $minutes mnt';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get tomorrow => 'Besok';

  @override
  String get prayerTimes => 'Jadwal salat';

  @override
  String get diveHint => 'Geser ke atas untuk harimu';

  @override
  String get now => 'Sekarang';

  @override
  String get yourDay => 'Harimu';

  @override
  String get location => 'Lokasi';

  @override
  String get setLocation => 'Atur lokasi Anda';

  @override
  String get setLocationHint =>
      'Waktu salat dan kiblat dihitung di ponsel Anda dari lokasi Anda. Hanya posisi yang dibulatkan yang dikirim ke OpenStreetMap, untuk menampilkan nama kota Anda.';

  @override
  String get useCurrentLocation => 'Gunakan lokasi saya saat ini';

  @override
  String get searchCity => 'Cari kota';

  @override
  String get searchCityHint => 'Nama kota';

  @override
  String get locating => 'Mencari lokasi Anda…';

  @override
  String get locationDisabled => 'Layanan lokasi dinonaktifkan.';

  @override
  String get locationDenied => 'Izin lokasi ditolak.';

  @override
  String get locationDeniedForever =>
      'Izin lokasi diblokir. Izinkan melalui pengaturan aplikasi.';

  @override
  String get openSettings => 'Buka pengaturan';

  @override
  String get unknownPlace => 'Lokasi saat ini';

  @override
  String get noResults => 'Tidak ada hasil';

  @override
  String get networkError =>
      'Tidak ada koneksi. Periksa internet Anda dan coba lagi.';

  @override
  String get genericError => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get retry => 'Coba lagi';

  @override
  String get calculation => 'Perhitungan';

  @override
  String get calculationMethod => 'Metode perhitungan';

  @override
  String get asrMethod => 'Waktu Asar';

  @override
  String get asrStandard => 'Standar (Syafi\'i, Maliki, Hanbali)';

  @override
  String get asrHanafi => 'Hanafi';

  @override
  String get highLatitudeRule => 'Aturan lintang tinggi';

  @override
  String get highLatMiddle => 'Tengah malam';

  @override
  String get highLatSeventh => 'Sepertujuh malam';

  @override
  String get highLatAngle => 'Sudut senja';

  @override
  String get highLatNone => 'Tidak ada';

  @override
  String get adjustments => 'Penyesuaian manual';

  @override
  String get adjustmentsHint =>
      'Tambah atau kurangi menit agar sesuai dengan masjid setempat.';

  @override
  String minutesShort(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get methodMuslimWorldLeague => 'Liga Muslim Dunia';

  @override
  String get methodEgyptian => 'Otoritas Survei Umum Mesir';

  @override
  String get methodKarachi => 'Universitas Ilmu Islam, Karachi';

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
  String get methodTehran => 'Institut Geofisika, Teheran';

  @override
  String get methodFrance => 'Prancis (UOIF, 12°)';

  @override
  String get methodRussia => 'Dewan Spiritual Muslim Rusia';

  @override
  String get methodMorocco => 'Kementerian Habous, Maroko';

  @override
  String get methodAlgeria => 'Kementerian Urusan Agama, Aljazair';

  @override
  String get methodTunisia => 'Tunisia';

  @override
  String get methodJordan => 'Kementerian Wakaf, Yordania';

  @override
  String get methodIndonesia => 'Kemenag, Indonesia';

  @override
  String get methodMalaysia => 'JAKIM, Malaysia';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get notificationSound => 'Suara notifikasi';

  @override
  String get notificationSilent => 'Senyap';

  @override
  String get notificationOff => 'Mati';

  @override
  String get reminderBefore => 'Pengingat sebelum';

  @override
  String get reminderOff => 'Tanpa pengingat';

  @override
  String minutesBefore(int minutes) {
    return '$minutes mnt sebelumnya';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'Telah masuk waktu salat $prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer dalam $minutes menit';
  }

  @override
  String get notificationsBlocked => 'Notifikasi untuk Sabeeli dinonaktifkan.';

  @override
  String get exactAlarmsNeeded =>
      'Izinkan \"Alarm & pengingat\" agar notifikasi salat tiba tepat waktu.';

  @override
  String get allow => 'Izinkan';

  @override
  String get channelSilent => 'Notifikasi salat senyap';

  @override
  String get channelPrayer => 'Jadwal salat';

  @override
  String get channelReminder => 'Pengingat salat';

  @override
  String get qibla => 'Kiblat';

  @override
  String get qiblaDirection => 'Arah kiblat';

  @override
  String get facingQibla => 'Anda menghadap kiblat';

  @override
  String get turnTowards => 'Putar hingga panah menunjuk ke atas';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° dari utara';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance km ke Ka\'bah';
  }

  @override
  String get calibrateCompass =>
      'Akurasi kompas rendah. Gerakkan ponsel membentuk angka delapan untuk kalibrasi.';

  @override
  String get compassUnavailable =>
      'Perangkat ini tidak memiliki kompas. Gunakan arah di bawah dengan kompas fisik.';

  @override
  String get qiblaNeedsLocation =>
      'Atur lokasi Anda untuk menemukan arah kiblat.';

  @override
  String get you => 'Anda';

  @override
  String get makkah => 'Makkah';

  @override
  String get qiblaGreatCircle =>
      'Kiblat mengikuti jalur terpendek di atas Bumi, bukan garis lurus pada peta datar.';

  @override
  String get globeView => 'Bola dunia';

  @override
  String get compassView => 'Kompas';

  @override
  String get quran => 'Al-Qur\'an Al-Karim';

  @override
  String get surahs => 'Surah';

  @override
  String get juzs => 'Juz';

  @override
  String get bookmarks => 'Penanda';

  @override
  String juzNumber(int number) {
    return 'Juz $number';
  }

  @override
  String pageNumber(int number) {
    return 'Halaman $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ayat',
      one: '1 ayat',
    );
    return '$_temp0';
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
  String get continueReading => 'Lanjutkan membaca';

  @override
  String get startReading => 'Mulai membaca';

  @override
  String get lastRead => 'Terakhir dibaca';

  @override
  String get tafsir => 'Tafsir';

  @override
  String get tafsirMuyassar => 'Tafsir al-Muyassar';

  @override
  String get translation => 'Terjemahan';

  @override
  String get copy => 'Salin';

  @override
  String get share => 'Bagikan';

  @override
  String get copied => 'Disalin';

  @override
  String get bookmark => 'Tandai';

  @override
  String get removeBookmark => 'Hapus penanda';

  @override
  String get bookmarkAdded => 'Penanda ditambahkan';

  @override
  String get bookmarkRemoved => 'Penanda dihapus';

  @override
  String get setAsLastRead => 'Tandai sebagai tempat berhenti';

  @override
  String get lastReadSaved => 'Posisi bacaan disimpan';

  @override
  String get noBookmarks =>
      'Belum ada penanda. Ketuk sebuah ayat saat membaca untuk menandainya.';

  @override
  String get fontSize => 'Ukuran huruf';

  @override
  String get searchSurah => 'Cari surah';

  @override
  String get sajda => 'Sajdah';

  @override
  String get translationUnavailable => 'Terjemahan ini belum diunduh.';

  @override
  String get download => 'Unduh';

  @override
  String get downloading => 'Mengunduh…';

  @override
  String get translationLanguage => 'Bahasa terjemahan';

  @override
  String get noTranslation => 'Tidak ada';

  @override
  String get readerSettings => 'Pengaturan bacaan';

  @override
  String get dailyAyah => 'Ayat hari ini';

  @override
  String get skyView => 'Langit';

  @override
  String get listView => 'Daftar';

  @override
  String khatmahProgress(int percent) {
    return '$percent% Al-Qur\'an telah dibaca';
  }

  @override
  String get skyHint =>
      'Setiap bintang adalah satu surah. Ia makin terang saat kamu membacanya.';

  @override
  String revelationOrder(int order) {
    return 'Turun ke-$order dari 114';
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
  String get azkarAfterPrayer => 'Setelah salat';

  @override
  String get azkarSleep => 'Sebelum tidur';

  @override
  String get azkarWaking => 'Saat bangun tidur';

  @override
  String get allCategories => 'Semua doa';

  @override
  String get tapToCount => 'Ketuk untuk menghitung';

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
  String get azkarDone => 'Semoga Allah menerima amal Anda';

  @override
  String get restart => 'Mulai lagi';

  @override
  String progressOf(int done, int total) {
    return '$done dari $total';
  }

  @override
  String get source => 'Sumber';

  @override
  String get virtue => 'Keutamaan';

  @override
  String get searchAzkar => 'Cari doa';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doa',
      one: '1 doa',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Tasbih';

  @override
  String get reset => 'Atur ulang';

  @override
  String get target => 'Target';

  @override
  String get noTarget => 'Tanpa batas';

  @override
  String totalCount(int count) {
    return 'Total: $count';
  }

  @override
  String rounds(int count) {
    return 'Putaran: $count';
  }

  @override
  String get vibration => 'Getaran';

  @override
  String get more => 'Lainnya';

  @override
  String get settings => 'Pengaturan';

  @override
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Terang';

  @override
  String get language => 'Bahasa';

  @override
  String get systemLanguage => 'Bahasa sistem';

  @override
  String get numerals => 'Angka';

  @override
  String get numeralsAuto => 'Otomatis (sesuai wilayah)';

  @override
  String get numeralsWestern => 'Barat';

  @override
  String get numeralsArabic => 'Arab (Timur)';

  @override
  String get numeralsPersian => 'Persia / Urdu';

  @override
  String get hijriCalendar => 'Kalender Hijriah';

  @override
  String get hijriCalendarHint =>
      'Negara-negara tidak selalu sepakat kapan sebuah bulan dimulai. Sesuaikan kalender agar mengikuti pengumuman setempat.';

  @override
  String get hijriMethod => 'Kalender';

  @override
  String get hijriUmmAlQura => 'Umm al-Qura (Arab Saudi)';

  @override
  String get hijriTabular => 'Aritmetika (algoritma Kuwait)';

  @override
  String get hijriOffset => 'Geser semua bulan';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: '1 hari',
      zero: 'Tanpa pergeseran',
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
  String get hijriAutomatic => 'Otomatis';

  @override
  String get hijriResetAll => 'Atur ulang semua koreksi';

  @override
  String get hijriCorrections => 'Koreksi bulan';

  @override
  String get hijriYearSuffix => 'H';

  @override
  String get hijriMonth1 => 'Muharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabiulawal';

  @override
  String get hijriMonth4 => 'Rabiulakhir';

  @override
  String get hijriMonth5 => 'Jumadilawal';

  @override
  String get hijriMonth6 => 'Jumadilakhir';

  @override
  String get hijriMonth7 => 'Rajab';

  @override
  String get hijriMonth8 => 'Syakban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Syawal';

  @override
  String get hijriMonth11 => 'Zulkaidah';

  @override
  String get hijriMonth12 => 'Zulhijah';

  @override
  String get eidAlFitr => 'Idulfitri';

  @override
  String get eidAlAdha => 'Iduladha';

  @override
  String get dayOfArafah => 'Hari Arafah';

  @override
  String get ashura => 'Asyura';

  @override
  String get islamicNewYear => 'Tahun Baru Islam';

  @override
  String get whiteDays => 'Ayyamul Bidh';

  @override
  String get ramadanBegins => 'Awal Ramadan';

  @override
  String get about => 'Tentang';

  @override
  String get aboutText =>
      'Sabeeli adalah pendamping gratis untuk kehidupan sehari-hari seorang Muslim. Bekerja tanpa internet, tanpa iklan, dan tidak mengumpulkan data apa pun.';

  @override
  String get credits => 'Sumber & penghargaan';

  @override
  String version(String version) {
    return 'Versi $version';
  }

  @override
  String get afterPrayer => 'Setelah salat';

  @override
  String afterPrayerOf(String prayer) {
    return 'Setelah $prayer';
  }

  @override
  String get afterPrayerHint => 'Zikir setelah salam, langkah demi langkah';

  @override
  String get showTranslation => 'Terjemahan';

  @override
  String get turnTheBeads => 'Putar butiran tasbih, atau ketuk';

  @override
  String get doneStep => 'Selesai';

  @override
  String get previousStep => 'Sebelumnya';

  @override
  String get skipStep => 'Lewati';

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
    return 'pukul $time';
  }

  @override
  String get nowLabel => 'Sekarang';

  @override
  String pageAyah(int page, int ayah) {
    return 'Halaman $page · Ayat $ayah';
  }

  @override
  String get tasbihHint => 'Putar butiran tasbih';

  @override
  String get azkarHint => 'Pagi, petang, dan lainnya';

  @override
  String get ayahOfTheDay => 'Ayat hari ini';

  @override
  String get navToday => 'Hari ini';

  @override
  String get navDhikr => 'Zikir';

  @override
  String get riwayah => 'Riwayat';

  @override
  String get riwayahAuto => 'Otomatis, sesuai wilayah';

  @override
  String get riwayahHafs => 'Hafs dari ʿAsim';

  @override
  String get riwayahWarsh => 'Warsy dari Nafiʿ';

  @override
  String get riwayahQalun => 'Qalun dari Nafiʿ';

  @override
  String get riwayahHafsHint => 'Dibaca di sebagian besar dunia Islam';

  @override
  String get riwayahWarshHint => 'Maroko, Aljazair, Mauritania, Afrika Barat';

  @override
  String get riwayahQalunHint => 'Libya, Tunisia';

  @override
  String get riwayahNote =>
      'Setiap riwayat ditampilkan dalam mushafnya sendiri dari Kompleks Raja Fahd. Tafsir dan terjemahan dicocokkan ayat demi ayat.';

  @override
  String get general => 'Umum';

  @override
  String get dhikrSubtitle => 'Ingatlah Allah, niscaya Dia mengingatmu';

  @override
  String get qiblaSubtitle => 'Arah Ka’bah dari tempat Anda';

  @override
  String get unitHours => 'j';

  @override
  String get unitMinutes => 'mnt';

  @override
  String get unitSeconds => 'dtk';

  @override
  String get pageColour => 'Halaman';

  @override
  String get pageAuto => 'Otomatis';

  @override
  String get pageNight => 'Malam';

  @override
  String get pageSepia => 'Sepia';

  @override
  String get pagePaper => 'Kertas';

  @override
  String get welcomeTagline =>
      'Salat, Al-Qur’an, dan zikir, di bawah langit nyata di atas Anda. Gratis, privat, dan milik Anda.';

  @override
  String get welcomeBegin => 'Mulai';

  @override
  String get welcomeNext => 'Lanjut';

  @override
  String get welcomeStart => 'Ayo mulai';

  @override
  String get welcomePlaceTitle => 'Di mana Anda?';

  @override
  String get welcomeNotifyTitle => 'Di setiap salat';

  @override
  String get welcomeNotifyBody =>
      'Notifikasi lembut dengan suara ponsel Anda saat waktu salat tiba. Atur per salat nanti.';

  @override
  String get welcomeNotifyAllow => 'Izinkan notifikasi';

  @override
  String get welcomeNotifyOn => 'Notifikasi aktif';

  @override
  String get welcomeExactAlarms => 'Terima tepat pada menitnya';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'Al-Qur’an dibuka dengan riwayat $riwayah. Bisa diubah di Pengaturan.';
  }

  @override
  String get prepareSoon => 'Segera';

  @override
  String get prepareHint => 'waktunya berwudu';

  @override
  String get channelDaily => 'Pengingat harian';

  @override
  String get dailyReminders => 'Pengingat harian';

  @override
  String get dailyMorning => 'Zikir pagi';

  @override
  String get dailyMorningBody => 'Beberapa menit zikir untuk memulai hari.';

  @override
  String get dailyEvening => 'Zikir petang';

  @override
  String get dailyEveningBody => 'Zikir petang saat hari berganti.';

  @override
  String get dailySleep => 'Zikir sebelum tidur';

  @override
  String get dailySleepBody => 'Akhiri hari dengan zikir.';

  @override
  String get dailyQuran => 'Bacaan harianmu';

  @override
  String get dailyQuranBody => 'Satu halaman Al-Qur’an menantimu.';

  @override
  String get dailyRemindersIntro =>
      'Pengingat untuk zikir dan bacaan harian, pada waktu pilihanmu. Semuanya opsional: notifikasi yang sama setiap hari bisa terasa mengganggu lama-lama, jadi aktifkan hanya yang benar-benar membantu, dan matikan kapan saja.';

  @override
  String get dailyRemindersOff => 'Mati';

  @override
  String dailyRemindersOn(int count) {
    return '$count aktif';
  }

  @override
  String get betaBadge => 'Beta';

  @override
  String get betaTitle => 'Sabeeli masih beta';

  @override
  String get betaBody =>
      'Aplikasi ini masih muda. Teks, terjemahan, dan informasinya masih perlu ditinjau oleh para ahli ilmu. Jika menemukan kesalahan, sekecil apa pun, beri tahu kami: setiap laporan membantu.';

  @override
  String get betaShakeHint =>
      'Goyangkan ponsel di layar mana pun untuk melaporkan masalah, beserta tangkapan layar.';

  @override
  String get betaUnderstood => 'Saya mengerti';

  @override
  String get reportTitle => 'Laporkan masalah';

  @override
  String get reportHint => 'Apa yang salah? (opsional)';

  @override
  String get reportSend => 'Kirim lewat email';

  @override
  String get reportAttach => 'Lampirkan tangkapan layar';

  @override
  String get reportPrivacy =>
      'Aplikasi email terbuka dengan laporan siap. Tidak ada yang terkirim sampai Anda menekan kirim di sana.';

  @override
  String get reportNoMail => 'Tidak ada aplikasi email di ponsel ini';

  @override
  String get shakeToReport => 'Goyangkan untuk melaporkan masalah';

  @override
  String get khatmahPlan => 'Rencana khatam';

  @override
  String get planAKhatmah => 'Rencanakan khatam';

  @override
  String khatmahDays(int days) {
    return '$days hari';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'Hari $day dari $days';
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
  String get khatmahDone => 'Bagian hari ini selesai';

  @override
  String khatmahPerDay(int count) {
    return 'Sekitar $count halaman sehari';
  }

  @override
  String khatmahEnds(String date) {
    return 'selesai $date';
  }

  @override
  String get khatmahFromStart => 'Dari awal';

  @override
  String khatmahFromHere(int page) {
    return 'Dari halaman $page';
  }

  @override
  String get khatmahStart => 'Mulai rencana';

  @override
  String get khatmahEnd => 'Akhiri rencana';

  @override
  String get khatmahFinished => 'Khatam selesai. Semoga Allah menerimanya.';

  @override
  String readOnDays(int count) {
    return 'Membaca $count dari 7 hari terakhir';
  }

  @override
  String get fastRamadan => 'Ramadan';

  @override
  String get fastMondayThursday => 'Puasa Senin dan Kamis';

  @override
  String get fastWhiteDays => 'Ayyamul bidh';

  @override
  String get fastArafah => 'Hari Arafah';

  @override
  String get fastAshura => 'Tasu‘a dan ‘Asyura';

  @override
  String fastTomorrow(String name) {
    return 'Besok: $name';
  }

  @override
  String get fastTomorrowBody =>
      'Pengingat bagi yang ingin berpuasa. Sahur sebelum Subuh.';

  @override
  String get suhoorTitle => 'Sahur';

  @override
  String suhoorBody(int minutes) {
    return 'Subuh dalam $minutes menit';
  }

  @override
  String get fastingReminders => 'Puasa';

  @override
  String get fastReminderTitle => 'Puasa sunah';

  @override
  String get fastReminderBody => 'Malam sebelum puasa sunah.';

  @override
  String get suhoorReminderTitle => 'Sahur di bulan Ramadan';

  @override
  String get suhoorReminderBody => 'Sebelum Subuh, selama Ramadan.';

  @override
  String get iftarIn => 'Berbuka dalam';

  @override
  String get suhoorEndsIn => 'Sahur berakhir dalam';

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
    return 'Sahur sampai $time';
  }

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get sourceCode => 'Kode sumber (GPL-3.0)';
}
