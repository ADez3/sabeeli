import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/calculation_method.dart';
import '../../../../core/astronomy/prayer.dart';
import '../../../../core/utils/numerals.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/notification_texts.dart';
import '../../domain/entities/prayer_settings.dart';

extension PrayerLabels on AppLocalizations {
  /// Dhuhr is called Jumu'ah on Fridays.
  String prayerName(Prayer prayer, {DateTime? on}) => switch (prayer) {
    Prayer.fajr => prayerFajr,
    Prayer.sunrise => prayerSunrise,
    Prayer.dhuhr =>
      (on?.weekday == DateTime.friday) ? prayerJumuah : prayerDhuhr,
    Prayer.asr => prayerAsr,
    Prayer.maghrib => prayerMaghrib,
    Prayer.isha => prayerIsha,
  };

  String methodName(CalculationMethod method) => switch (method) {
    CalculationMethod.muslimWorldLeague => methodMuslimWorldLeague,
    CalculationMethod.egyptian => methodEgyptian,
    CalculationMethod.karachi => methodKarachi,
    CalculationMethod.ummAlQura => methodUmmAlQura,
    CalculationMethod.dubai => methodDubai,
    CalculationMethod.qatar => methodQatar,
    CalculationMethod.kuwait => methodKuwait,
    CalculationMethod.northAmerica => methodNorthAmerica,
    CalculationMethod.singapore => methodSingapore,
    CalculationMethod.turkey => methodTurkey,
    CalculationMethod.tehran => methodTehran,
    CalculationMethod.france => methodFrance,
    CalculationMethod.russia => methodRussia,
    CalculationMethod.morocco => methodMorocco,
    CalculationMethod.algeria => methodAlgeria,
    CalculationMethod.tunisia => methodTunisia,
    CalculationMethod.jordan => methodJordan,
    CalculationMethod.indonesia => methodIndonesia,
    CalculationMethod.malaysia => methodMalaysia,
  };

  String alertName(PrayerAlert alert) => switch (alert) {
    PrayerAlert.sound => notificationSound,
    PrayerAlert.silent => notificationSilent,
    PrayerAlert.off => notificationOff,
  };

  String highLatitudeName(HighLatitudeRule rule) => switch (rule) {
    HighLatitudeRule.middleOfTheNight => highLatMiddle,
    HighLatitudeRule.seventhOfTheNight => highLatSeventh,
    HighLatitudeRule.twilightAngle => highLatAngle,
    HighLatitudeRule.none => highLatNone,
  };

  NotificationTexts notificationTexts({
    required int reminderMinutes,
    required Numerals numerals,
  }) => NotificationTexts(
    titles: {
      for (final p in Prayer.values) p: notificationTitle(prayerName(p)),
    },
    bodies: {for (final p in Prayer.values) p: notificationBody(prayerName(p))},
    reminders: {
      for (final p in Prayer.values)
        p: numerals.apply(reminderBody(prayerName(p), reminderMinutes)),
    },
    silentChannel: channelSilent,
    prayerChannel: channelPrayer,
    reminderChannel: channelReminder,
  );
}

IconData prayerIcon(Prayer prayer) => switch (prayer) {
  Prayer.fajr => LucideIcons.moonStar,
  Prayer.sunrise => LucideIcons.sunrise,
  Prayer.dhuhr => LucideIcons.sun,
  Prayer.asr => LucideIcons.cloudSun,
  Prayer.maghrib => LucideIcons.sunset,
  Prayer.isha => LucideIcons.moon,
};

IconData alertIcon(PrayerAlert alert) => switch (alert) {
  PrayerAlert.sound => LucideIcons.bellRing,
  PrayerAlert.silent => LucideIcons.bellMinus,
  PrayerAlert.off => LucideIcons.bellOff,
};
