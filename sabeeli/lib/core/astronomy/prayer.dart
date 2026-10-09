/// The five daily prayers plus sunrise, which ends the Fajr window and is shown with them.
enum Prayer {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  /// Sunrise is a time, not a prayer: it gets no notification by default.
  bool get isObligatory => this != Prayer.sunrise;
}
