// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Sabeeli';

  @override
  String get appTagline => 'Ваш путь каждый день';

  @override
  String get navHome => 'Главная';

  @override
  String get navQuran => 'Коран';

  @override
  String get navPrayer => 'Намаз';

  @override
  String get navAzkar => 'Азкары';

  @override
  String get navMore => 'Ещё';

  @override
  String get prayerFajr => 'Фаджр';

  @override
  String get prayerSunrise => 'Восход';

  @override
  String get prayerDhuhr => 'Зухр';

  @override
  String get prayerJumuah => 'Джума';

  @override
  String get prayerAsr => 'Аср';

  @override
  String get prayerMaghrib => 'Магриб';

  @override
  String get prayerIsha => 'Иша';

  @override
  String get midnight => 'Середина ночи';

  @override
  String get lastThird => 'Последняя треть ночи';

  @override
  String get salam => 'Ассаляму алейкум';

  @override
  String get nextPrayer => 'Следующий намаз';

  @override
  String prayerTimeNow(String prayer) {
    return 'Время намаза $prayer';
  }

  @override
  String timeUntil(String duration) {
    return 'через $duration';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get prayerTimes => 'Время намаза';

  @override
  String get diveHint => 'Проведите вверх, чтобы увидеть свой день';

  @override
  String get now => 'Сейчас';

  @override
  String get yourDay => 'Ваш день';

  @override
  String get location => 'Местоположение';

  @override
  String get setLocation => 'Укажите местоположение';

  @override
  String get setLocationHint =>
      'Время намаза и кибла рассчитываются на вашем телефоне по месту, где вы находитесь. В OpenStreetMap отправляется только округлённая позиция, чтобы определить название вашего города.';

  @override
  String get useCurrentLocation => 'Определить моё местоположение';

  @override
  String get searchCity => 'Найти город';

  @override
  String get searchCityHint => 'Название города';

  @override
  String get locating => 'Определяем местоположение…';

  @override
  String get locationDisabled => 'Службы геолокации отключены.';

  @override
  String get locationDenied => 'Доступ к местоположению не предоставлен.';

  @override
  String get locationDeniedForever =>
      'Доступ к местоположению заблокирован. Разрешите его в настройках приложения.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get unknownPlace => 'Текущее местоположение';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get networkError =>
      'Нет соединения. Проверьте интернет и попробуйте снова.';

  @override
  String get genericError => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get retry => 'Повторить';

  @override
  String get calculation => 'Расчёт';

  @override
  String get calculationMethod => 'Метод расчёта';

  @override
  String get asrMethod => 'Время Асра';

  @override
  String get asrStandard =>
      'Стандартное (шафиитский, маликитский, ханбалитский)';

  @override
  String get asrHanafi => 'Ханафитский';

  @override
  String get highLatitudeRule => 'Правило для высоких широт';

  @override
  String get highLatMiddle => 'Середина ночи';

  @override
  String get highLatSeventh => 'Седьмая часть ночи';

  @override
  String get highLatAngle => 'Угол сумерек';

  @override
  String get highLatNone => 'Нет';

  @override
  String get adjustments => 'Ручная корректировка';

  @override
  String get adjustmentsHint =>
      'Добавьте или уберите минуты, чтобы совпадать с вашей мечетью.';

  @override
  String get hourShift => 'Корректировка часа';

  @override
  String get hourShiftHint =>
      'Только если все времена сдвинуты на целые часы: часовой пояс телефона указан неверно (например, остался GMT+1 после смены времени в стране). Лучше установить правильный часовой пояс на телефоне.';

  @override
  String hoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String get methodMuslimWorldLeague => 'Всемирная исламская лига';

  @override
  String get methodEgyptian => 'Египетское управление геодезии';

  @override
  String get methodKarachi => 'Университет исламских наук, Карачи';

  @override
  String get methodUmmAlQura => 'Умм аль-Кура, Мекка';

  @override
  String get methodDubai => 'Дубай';

  @override
  String get methodQatar => 'Катар';

  @override
  String get methodKuwait => 'Кувейт';

  @override
  String get methodNorthAmerica => 'Исламское общество Северной Америки (ISNA)';

  @override
  String get methodSingapore => 'Сингапур (MUIS)';

  @override
  String get methodTurkey => 'Диянет, Турция';

  @override
  String get methodTehran => 'Институт геофизики, Тегеран';

  @override
  String get methodFrance => 'Франция (UOIF, 12°)';

  @override
  String get methodRussia => 'Духовное управление мусульман России';

  @override
  String get methodMorocco => 'Министерство хабусов, Марокко';

  @override
  String get methodAlgeria => 'Министерство по делам религии, Алжир';

  @override
  String get methodTunisia => 'Тунис';

  @override
  String get methodJordan => 'Министерство вакфов, Иордания';

  @override
  String get methodIndonesia => 'Kemenag, Индонезия';

  @override
  String get methodMalaysia => 'JAKIM, Малайзия';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationSound => 'Звук уведомления';

  @override
  String get notificationSilent => 'Без звука';

  @override
  String get notificationOff => 'Выкл.';

  @override
  String get reminderBefore => 'Напоминание заранее';

  @override
  String get reminderOff => 'Без напоминания';

  @override
  String minutesBefore(int minutes) {
    return 'За $minutes мин';
  }

  @override
  String notificationTitle(String prayer) {
    return '$prayer';
  }

  @override
  String notificationBody(String prayer) {
    return 'Наступило время намаза $prayer';
  }

  @override
  String reminderBody(String prayer, int minutes) {
    return '$prayer через $minutes мин';
  }

  @override
  String get notificationsBlocked => 'Уведомления для Sabeeli отключены.';

  @override
  String get exactAlarmsNeeded =>
      'Разрешите «Будильники и напоминания», чтобы уведомления о намазе приходили точно вовремя.';

  @override
  String get allow => 'Разрешить';

  @override
  String get channelSilent => 'Беззвучные уведомления о намазе';

  @override
  String get channelPrayer => 'Время намаза';

  @override
  String get channelReminder => 'Напоминания о намазе';

  @override
  String get qibla => 'Кибла';

  @override
  String get qiblaDirection => 'Направление киблы';

  @override
  String get facingQibla => 'Вы обращены к кибле';

  @override
  String get turnTowards => 'Поворачивайтесь, пока стрелка не укажет вверх';

  @override
  String degreesFromNorth(String degrees) {
    return '$degrees° от севера';
  }

  @override
  String distanceToKaaba(String distance) {
    return '$distance км до Каабы';
  }

  @override
  String get calibrateCompass =>
      'Низкая точность компаса. Поводите телефоном восьмёркой для калибровки.';

  @override
  String get compassUnavailable =>
      'На этом устройстве нет компаса. Используйте азимут ниже с обычным компасом.';

  @override
  String get qiblaNeedsLocation => 'Укажите местоположение, чтобы найти киблу.';

  @override
  String get you => 'Вы';

  @override
  String get makkah => 'Мекка';

  @override
  String get qiblaGreatCircle =>
      'Кибла идёт по кратчайшему пути по поверхности Земли, а не по прямой на плоской карте.';

  @override
  String get globeView => 'Глобус';

  @override
  String get compassView => 'Компас';

  @override
  String get quran => 'Священный Коран';

  @override
  String get surahs => 'Суры';

  @override
  String get juzs => 'Джузы';

  @override
  String get bookmarks => 'Закладки';

  @override
  String juzNumber(int number) {
    return 'Джуз $number';
  }

  @override
  String pageNumber(int number) {
    return 'Страница $number';
  }

  @override
  String ayahCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count аята',
      many: '$count аятов',
      few: '$count аята',
      one: '$count аят',
    );
    return '$_temp0';
  }

  @override
  String surahAyah(String surah, int ayah) {
    return '$surah, аят $ayah';
  }

  @override
  String get meccan => 'Мекканская';

  @override
  String get medinan => 'Мединская';

  @override
  String get continueReading => 'Продолжить чтение';

  @override
  String get startReading => 'Начать чтение';

  @override
  String get lastRead => 'Последнее прочитанное';

  @override
  String get tafsir => 'Тафсир';

  @override
  String get tafsirMuyassar => 'Тафсир аль-Муяссар';

  @override
  String get translation => 'Перевод';

  @override
  String get copy => 'Копировать';

  @override
  String get share => 'Поделиться';

  @override
  String get copied => 'Скопировано';

  @override
  String get bookmark => 'В закладки';

  @override
  String get removeBookmark => 'Удалить закладку';

  @override
  String get bookmarkAdded => 'Закладка добавлена';

  @override
  String get bookmarkRemoved => 'Закладка удалена';

  @override
  String get setAsLastRead => 'Отметить, где я остановился';

  @override
  String get lastReadSaved => 'Место чтения сохранено';

  @override
  String get noBookmarks =>
      'Закладок пока нет. Нажмите на аят во время чтения, чтобы добавить закладку.';

  @override
  String get fontSize => 'Размер шрифта';

  @override
  String get searchSurah => 'Поиск сур';

  @override
  String get sajda => 'Саджда';

  @override
  String get translationUnavailable => 'Этот перевод ещё не загружен.';

  @override
  String get download => 'Загрузить';

  @override
  String get downloading => 'Загрузка…';

  @override
  String get translationLanguage => 'Язык перевода';

  @override
  String get noTranslation => 'Нет';

  @override
  String get readerSettings => 'Настройки чтения';

  @override
  String get dailyAyah => 'Аят дня';

  @override
  String get skyView => 'Небо';

  @override
  String get listView => 'Список';

  @override
  String khatmahProgress(int percent) {
    return 'Прочитано $percent% Корана';
  }

  @override
  String get skyHint =>
      'Каждая звезда — это сура. Она становится ярче, когда вы её читаете.';

  @override
  String revelationOrder(int order) {
    return 'Ниспослана $order-й из 114';
  }

  @override
  String pagesRange(int from, int to) {
    return 'Страницы $from–$to';
  }

  @override
  String surahProgress(int percent) {
    return 'Прочитано $percent%';
  }

  @override
  String get openSurah => 'Открыть';

  @override
  String get azkar => 'Азкары';

  @override
  String get azkarMorning => 'Утренние азкары';

  @override
  String get azkarEvening => 'Вечерние азкары';

  @override
  String get azkarAfterPrayer => 'После намаза';

  @override
  String get azkarSleep => 'Перед сном';

  @override
  String get azkarWaking => 'После пробуждения';

  @override
  String get allCategories => 'Все дуа';

  @override
  String get tapToCount => 'Нажмите, чтобы считать';

  @override
  String repeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count раза',
      many: '$count раз',
      few: '$count раза',
      one: '$count раз',
      two: 'Два раза',
    );
    return '$_temp0';
  }

  @override
  String get completed => 'Завершено';

  @override
  String get azkarDone => 'Да примет Аллах от вас';

  @override
  String get restart => 'Начать заново';

  @override
  String progressOf(int done, int total) {
    return '$done из $total';
  }

  @override
  String get source => 'Источник';

  @override
  String get virtue => 'Достоинство';

  @override
  String get searchAzkar => 'Поиск дуа';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дуа',
      many: '$count дуа',
      few: '$count дуа',
      one: '$count дуа',
    );
    return '$_temp0';
  }

  @override
  String get tasbih => 'Тасбих';

  @override
  String get reset => 'Сбросить';

  @override
  String get target => 'Цель';

  @override
  String get noTarget => 'Без ограничения';

  @override
  String totalCount(int count) {
    return 'Всего: $count';
  }

  @override
  String rounds(int count) {
    return 'Круги: $count';
  }

  @override
  String get vibration => 'Вибрация';

  @override
  String get more => 'Ещё';

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get language => 'Язык';

  @override
  String get systemLanguage => 'Язык системы';

  @override
  String get numerals => 'Цифры';

  @override
  String get numeralsAuto => 'Автоматически (по региону)';

  @override
  String get numeralsWestern => 'Западные';

  @override
  String get numeralsArabic => 'Арабские (восточные)';

  @override
  String get numeralsPersian => 'Персидские / урду';

  @override
  String get hijriCalendar => 'Календарь хиджры';

  @override
  String get hijriCalendarHint =>
      'Страны не всегда сходятся в том, когда начинается месяц. Настройте календарь по объявлению в вашей местности.';

  @override
  String get hijriMethod => 'Календарь';

  @override
  String get hijriUmmAlQura => 'Умм аль-Кура (Саудовская Аравия)';

  @override
  String get hijriTabular => 'Арифметический (кувейтский алгоритм)';

  @override
  String get hijriOffset => 'Сдвинуть все месяцы';

  @override
  String hijriOffsetValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
      zero: 'Без сдвига',
    );
    return '$_temp0';
  }

  @override
  String get hijriThisMonth => 'Этот месяц';

  @override
  String hijriMonthStartedOn(String month) {
    return 'Начало месяца $month';
  }

  @override
  String get hijriAutomatic => 'Автоматически';

  @override
  String get hijriResetAll => 'Сбросить все поправки';

  @override
  String get hijriCorrections => 'Поправки месяцев';

  @override
  String get hijriYearSuffix => 'г. х.';

  @override
  String get hijriMonth1 => 'Мухаррам';

  @override
  String get hijriMonth2 => 'Сафар';

  @override
  String get hijriMonth3 => 'Раби аль-авваль';

  @override
  String get hijriMonth4 => 'Раби ас-сани';

  @override
  String get hijriMonth5 => 'Джумада аль-уля';

  @override
  String get hijriMonth6 => 'Джумада аль-ахира';

  @override
  String get hijriMonth7 => 'Раджаб';

  @override
  String get hijriMonth8 => 'Шабан';

  @override
  String get hijriMonth9 => 'Рамадан';

  @override
  String get hijriMonth10 => 'Шавваль';

  @override
  String get hijriMonth11 => 'Зуль-када';

  @override
  String get hijriMonth12 => 'Зуль-хиджа';

  @override
  String get eidAlFitr => 'Ураза-байрам';

  @override
  String get eidAlAdha => 'Курбан-байрам';

  @override
  String get dayOfArafah => 'День Арафата';

  @override
  String get ashura => 'Ашура';

  @override
  String get islamicNewYear => 'Исламский Новый год';

  @override
  String get whiteDays => 'Белые дни';

  @override
  String get ramadanBegins => 'Начало Рамадана';

  @override
  String get about => 'О приложении';

  @override
  String get aboutText =>
      'Sabeeli — бесплатный помощник в повседневной жизни мусульманина. Работает без интернета, не содержит рекламы и не собирает данные.';

  @override
  String get credits => 'Источники и благодарности';

  @override
  String version(String version) {
    return 'Версия $version';
  }

  @override
  String get afterPrayer => 'После намаза';

  @override
  String afterPrayerOf(String prayer) {
    return 'После намаза $prayer';
  }

  @override
  String get afterPrayerHint => 'Азкары после салама, шаг за шагом';

  @override
  String get showTranslation => 'Перевод';

  @override
  String get turnTheBeads => 'Перебирайте чётки или нажмите';

  @override
  String get doneStep => 'Готово';

  @override
  String get previousStep => 'Назад';

  @override
  String get skipStep => 'Пропустить';

  @override
  String remembrances(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поминания Аллаха',
      many: '$count поминаний Аллаха',
      few: '$count поминания Аллаха',
      one: '$count поминание Аллаха',
    );
    return '$_temp0';
  }

  @override
  String prayerIn(String prayer) {
    return '$prayer через';
  }

  @override
  String atTime(String time) {
    return 'в $time';
  }

  @override
  String get nowLabel => 'Сейчас';

  @override
  String pageAyah(int page, int ayah) {
    return 'Страница $page · Аят $ayah';
  }

  @override
  String get tasbihHint => 'Перебирайте чётки';

  @override
  String get azkarHint => 'Утренние, вечерние и другие';

  @override
  String get ayahOfTheDay => 'Аят дня';

  @override
  String get navToday => 'Сегодня';

  @override
  String get navDhikr => 'Зикр';

  @override
  String get riwayah => 'Риваят';

  @override
  String get riwayahAuto => 'Автоматически, по региону';

  @override
  String get riwayahHafs => 'Хафс от Асыма';

  @override
  String get riwayahWarsh => 'Варш от Нафи';

  @override
  String get riwayahQalun => 'Калун от Нафи';

  @override
  String get riwayahHafsHint =>
      'Распространён в большей части мусульманского мира';

  @override
  String get riwayahWarshHint => 'Марокко, Алжир, Мавритания, Западная Африка';

  @override
  String get riwayahQalunHint => 'Ливия, Тунис';

  @override
  String get riwayahNote =>
      'Каждый риваят показан в собственном мусхафе Комплекса короля Фахда. Тафсир и переводы сопоставлены с ним аят за аятом.';

  @override
  String get general => 'Общие';

  @override
  String get dhikrSubtitle => 'Поминайте Аллаха, и Он помянет вас';

  @override
  String get qiblaSubtitle =>
      'Направление на Каабу от того места, где вы находитесь';

  @override
  String get unitHours => 'ч';

  @override
  String get unitMinutes => 'мин';

  @override
  String get unitSeconds => 'с';

  @override
  String get pageColour => 'Страница';

  @override
  String get pageAuto => 'Авто';

  @override
  String get pageNight => 'Ночь';

  @override
  String get pageSepia => 'Сепия';

  @override
  String get pagePaper => 'Бумага';

  @override
  String get welcomeTagline =>
      'Намаз, Коран и зикр под настоящим небом над вами. Бесплатно, конфиденциально и только для вас.';

  @override
  String get welcomeBegin => 'Начать';

  @override
  String get welcomeNext => 'Далее';

  @override
  String get welcomeStart => 'Начать';

  @override
  String get welcomePlaceTitle => 'Где вы находитесь?';

  @override
  String get welcomeNotifyTitle => 'К каждому намазу';

  @override
  String get welcomeNotifyBody =>
      'Мягкое уведомление со звуком вашего телефона, когда наступает время каждого намаза. Позже это можно настроить для каждого намаза отдельно.';

  @override
  String get welcomeNotifyAllow => 'Разрешить уведомления';

  @override
  String get welcomeNotifyOn => 'Уведомления включены';

  @override
  String get welcomeExactAlarms => 'Пусть приходят минута в минуту';

  @override
  String welcomeRiwayah(String riwayah) {
    return 'Коран откроется в риваяте $riwayah. Это можно изменить в настройках.';
  }

  @override
  String get prepareSoon => 'Скоро';

  @override
  String get prepareHint => 'время для омовения';

  @override
  String get channelDaily => 'Ежедневные напоминания';

  @override
  String get dailyReminders => 'Ежедневные напоминания';

  @override
  String get dailyMorning => 'Утренние азкары';

  @override
  String get dailyMorningBody =>
      'Несколько минут поминания, чтобы начать день.';

  @override
  String get dailyEvening => 'Вечерние азкары';

  @override
  String get dailyEveningBody =>
      'Вечерние азкары, когда день склоняется к закату.';

  @override
  String get dailySleep => 'Азкары перед сном';

  @override
  String get dailySleepBody => 'Завершите день поминанием Аллаха.';

  @override
  String get dailyQuran => 'Ваше ежедневное чтение';

  @override
  String get dailyQuranBody => 'Вас ждёт страница Корана.';

  @override
  String get dailyRemindersIntro =>
      'Напоминания об азкарах и ежедневном чтении в выбранное вами время. Они необязательны: одно и то же уведомление каждый день со временем может превратиться в шум, поэтому включайте только те, что действительно помогают, и отключайте их когда угодно.';

  @override
  String get dailyRemindersOff => 'Выкл.';

  @override
  String dailyRemindersOn(int count) {
    return 'Включено: $count';
  }

  @override
  String get betaBadge => 'Бета';

  @override
  String get betaTitle => 'Sabeeli в бета-версии';

  @override
  String get betaBody =>
      'Приложение ещё молодое. Его тексты, переводы и сведения, которые оно показывает, ещё должны проверить знающие люди. Если вы заметите ошибку, даже мелкую, пожалуйста, сообщите нам: каждое сообщение помогает.';

  @override
  String get betaShakeHint =>
      'Встряхните телефон на любом экране, чтобы сообщить о проблеме со снимком экрана.';

  @override
  String get betaUnderstood => 'Понятно';

  @override
  String get reportTitle => 'Сообщить о проблеме';

  @override
  String get reportHint => 'Что не так? (необязательно)';

  @override
  String get reportSend => 'Отправить по почте';

  @override
  String get reportAttach => 'Приложить снимок экрана';

  @override
  String get reportPrivacy =>
      'Откроется ваше почтовое приложение с готовым сообщением. Ничего не отправится, пока вы сами не нажмёте «Отправить».';

  @override
  String get reportNoMail => 'На этом телефоне нет почтового приложения';

  @override
  String get shakeToReport => 'Встряхнуть, чтобы сообщить о проблеме';

  @override
  String get khatmahPlan => 'План хатма';

  @override
  String get planAKhatmah => 'Запланировать хатм';

  @override
  String khatmahDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String khatmahDayOf(int day, int days) {
    return 'День $day из $days';
  }

  @override
  String khatmahToday(int from, int to) {
    return 'Сегодня: страницы $from–$to';
  }

  @override
  String khatmahLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сегодня осталось $count страницы',
      many: 'Сегодня осталось $count страниц',
      few: 'Сегодня осталось $count страницы',
      one: 'Сегодня осталась $count страница',
    );
    return '$_temp0';
  }

  @override
  String get khatmahDone => 'Сегодняшняя часть прочитана';

  @override
  String khatmahPerDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Около $count страницы в день',
      many: 'Около $count страниц в день',
      few: 'Около $count страниц в день',
      one: 'Около $count страницы в день',
    );
    return '$_temp0';
  }

  @override
  String khatmahEnds(String date) {
    return 'завершится $date';
  }

  @override
  String get khatmahFromStart => 'С начала';

  @override
  String khatmahFromHere(int page) {
    return 'Со страницы $page';
  }

  @override
  String get khatmahStart => 'Начать план';

  @override
  String get khatmahEnd => 'Завершить план';

  @override
  String get khatmahFinished => 'Хатм завершён. Да примет его Аллах.';

  @override
  String readOnDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Чтение в $count из последних 7 дней',
      many: 'Чтение в $count из последних 7 дней',
      few: 'Чтение в $count из последних 7 дней',
      one: 'Чтение в $count из последних 7 дней',
    );
    return '$_temp0';
  }

  @override
  String get fastRamadan => 'Рамадан';

  @override
  String get fastMondayThursday => 'Понедельники и четверги';

  @override
  String get fastWhiteDays => 'Белые дни';

  @override
  String get fastArafah => 'День Арафата';

  @override
  String get fastAshura => 'Тасуа и Ашура';

  @override
  String fastTomorrow(String name) {
    return 'Завтра: $name';
  }

  @override
  String get fastTomorrowBody =>
      'Напоминание для тех, кто хочет поститься. Сухур — до Фаджра.';

  @override
  String get suhoorTitle => 'Сухур';

  @override
  String suhoorBody(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Фаджр через $minutes минуты',
      many: 'Фаджр через $minutes минут',
      few: 'Фаджр через $minutes минуты',
      one: 'Фаджр через $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String get fastingReminders => 'Пост';

  @override
  String get fastReminderTitle => 'Добровольные посты';

  @override
  String get fastReminderBody => 'Вечером накануне поста по сунне.';

  @override
  String get suhoorReminderTitle => 'Сухур в Рамадан';

  @override
  String get suhoorReminderBody => 'Перед Фаджром, во время Рамадана.';

  @override
  String get iftarIn => 'Ифтар через';

  @override
  String get suhoorEndsIn => 'Сухур закончится через';

  @override
  String ramadanDay(int day) {
    return 'Рамадан · день $day';
  }

  @override
  String fastToday(String name) {
    return 'Сегодня: $name';
  }

  @override
  String iftarAt(String time) {
    return 'Ифтар в $time';
  }

  @override
  String suhoorUntil(String time) {
    return 'Сухур до $time';
  }

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get sourceCode => 'Исходный код (GPL-3.0)';
}
