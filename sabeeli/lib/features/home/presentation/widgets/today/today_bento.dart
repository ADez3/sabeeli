import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/astronomy/qibla.dart';
import '../../../../../core/astronomy/solar.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/hijri/fasting.dart';
import '../../../../../core/layout/breakpoints.dart';
import '../../../../../core/platform/live_state.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_icons.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/bento_tile.dart';
import '../../../../../core/widgets/moon_phase.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../azkar/presentation/cubit/azkar_cubit.dart';
import '../../../../azkar/presentation/widgets/azkar_labels.dart';
import '../../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../../hijri/presentation/widgets/hijri_labels.dart';
import '../../../../location/presentation/cubit/location_cubit.dart';
import '../../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../../qibla/domain/usecases/watch_compass_usecase.dart';
import '../../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../../../quran/domain/entities/quran_entities.dart';
import '../../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../../quran/presentation/widgets/ayah_number.dart';
import '../../../../quran/presentation/widgets/khatmah_sheet.dart';
import '../../../../quran/presentation/widgets/surah_labels.dart';
import '../../../../quran/presentation/widgets/quran_font.dart';

/// The live tiles under the sky: what to do now, where the reading stopped,
/// the moon, the Qibla, the misbaha and an ayah for the day. Each tile shows
/// real data and opens its full screen.
class TodayBento extends StatelessWidget {
  const TodayBento({super.key});

  static const _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _NowTile(),
      _FastingTile(),
      SizedBox(height: _gap),
      _ContinueReadingTile(),
      SizedBox(height: _gap),
      _Pair(left: _MoonTile(), right: _QiblaTile()),
      SizedBox(height: _gap),
      _Pair(left: _TasbihTile(), right: _DhikrTile()),
      SizedBox(height: _gap),
      _AyahTile(),
    ],
  );
}

class _Pair extends StatelessWidget {
  const _Pair({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 172,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: left),
        const SizedBox(width: TodayBento._gap),
        Expanded(child: right),
      ],
    ),
  );
}

/// A small caption above a tile's content.
class _Caption extends StatelessWidget {
  const _Caption(this.icon, this.text, {this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.textMuted;
    return Row(
      children: [
        Icon(icon, size: 15, color: c),
        const SizedBox(width: AppSpacing.xs + 2),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c),
          ),
        ),
      ],
    );
  }
}

/// The one thing that fits this moment: getting ready in the last minutes
/// before a prayer, the adhkar after the prayer just prayed, or the morning or
/// evening adhkar.
class _NowTile extends StatefulWidget {
  const _NowTile();

  @override
  State<_NowTile> createState() => _NowTileState();
}

class _NowTileState extends State<_NowTile> with LiveStateMixin {
  /// How long after a prayer's time its adhkar are suggested first.
  static const _afterPrayerWindow = Duration(minutes: 50);

  /// How long before a prayer the tile turns to getting ready.
  static const _prepareWindow = Duration(minutes: 15);

  Timer? _minute;

  @override
  void onLiveChanged(bool live) {
    _minute?.cancel();
    _minute = null;
    if (!live) return;
    void tick() {
      if (!mounted) return;
      setState(() {});
      final now = DateTime.now();
      _minute = Timer(
        Duration(seconds: 60 - now.second, milliseconds: -now.millisecond),
        tick,
      );
    }

    tick();
  }

  @override
  void dispose() {
    _minute?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final prayers = context.watch<PrayerTimesCubit>().state;
    final last = prayers.lastPrayerAt(now);
    final lastTime = prayers.today?.timeOf(last);
    final justPrayed =
        lastTime != null &&
        !lastTime.isAfter(now) &&
        now.difference(lastTime) < _afterPrayerWindow;
    final next = prayers.nextAfter(now);
    final soon =
        next != null &&
        next.prayer.isObligatory &&
        next.time.difference(now) <= _prepareWindow;
    final azkarKey = suggestedAzkarKey(now);
    final category = context.select(
      (AzkarCubit c) => azkarKey == null ? null : c.state.byKey(azkarKey),
    );

    final (icon, caption, title, subtitle, onTap) = soon
        ? (
            LucideIcons.droplet,
            l10n.prepareSoon,
            l10n.prayerIn(l10n.prayerName(next.prayer, on: now)),
            '${context.formatDuration(next.time.difference(now))} · '
                '${l10n.prepareHint}',
            () => context.pushNamed(AppRoutes.prayerName),
          )
        : justPrayed || category == null
        ? (
            LucideIcons.handHeart,
            l10n.afterPrayer,
            l10n.afterPrayerOf(l10n.prayerName(last, on: now)),
            l10n.afterPrayerHint,
            () => context.pushNamed(
              AppRoutes.afterPrayerName,
              queryParameters: {'prayer': last.name},
            ),
          )
        : (
            azkarIcon(azkarKey),
            l10n.nowLabel,
            context.azkarTitle(category),
            context.digits(l10n.itemsCount(category.items.length)),
            () => context.pushNamed(
              AppRoutes.azkarCategoryName,
              pathParameters: {'categoryId': '${category.id}'},
            ),
          );

    return BentoTile(
      glow: colors.accent,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xl - 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Caption(icon, caption, color: colors.accent),
                const SizedBox(height: AppSpacing.md),
                Text(title, style: text.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: text.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accent.withValues(alpha: 0.16),
            ),
            child: Icon(context.forwardArrow, color: colors.accent, size: 20),
          ),
        ],
      ),
    );
  }
}

/// Fasting, when it matters today: the day of Ramadan with iftar and suhoor,
/// a sunnah fast today, or one tomorrow. Nothing the rest of the time.
class _FastingTile extends StatelessWidget {
  const _FastingTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final calendar = context.select((HijriCubit c) => c.state.calendar);
    final prayers = context.watch<PrayerTimesCubit>().state;
    final today = prayers.today;
    final tomorrowTimes = prayers.tomorrow;
    if (today == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final kindsToday = Fasting.on(calendar, date);
    final kindsTomorrow = Fasting.on(
      calendar,
      date.add(const Duration(days: 1)),
    );

    final String title;
    final String detail;
    if (kindsToday.contains(FastKind.ramadan)) {
      title = l10n.ramadanDay(calendar.fromGregorian(date).day);
      // Before iftar: today's iftar; after it: tomorrow's suhoor.
      detail = now.isBefore(today.maghrib)
          ? l10n.iftarAt(context.formatTime(today.maghrib))
          : l10n.suhoorUntil(
              context.formatTime(tomorrowTimes?.fajr ?? today.fajr),
            );
    } else if (kindsToday.isNotEmpty && now.isBefore(today.maghrib)) {
      title = l10n.fastToday(l10n.fastName(kindsToday.first));
      detail = l10n.iftarAt(context.formatTime(today.maghrib));
    } else if (kindsTomorrow.isNotEmpty &&
        !kindsTomorrow.contains(FastKind.ramadan)) {
      title = l10n.fastTomorrow(l10n.fastName(kindsTomorrow.first));
      detail = l10n.suhoorUntil(
        context.formatTime(tomorrowTimes?.fajr ?? today.fajr),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: TodayBento._gap),
      child: BentoTile(
        glow: colors.secondary,
        onTap: () => context.pushNamed(AppRoutes.remindersName),
        child: Row(
          children: [
            Icon(LucideIcons.moonStar, color: colors.secondary),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.digits(title), style: text.titleMedium),
                  Text(context.digits(detail), style: text.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueReadingTile extends StatelessWidget {
  const _ContinueReadingTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final quran = context.watch<QuranCubit>().state;
    final data = quran.data;
    final position = quran.position;
    final surah = data?.surah(position?.ref.surah ?? 1);
    final progress = data == null || surah == null
        ? 0.0
        : data.surahProgress(surah.number, quran.readPages);

    return BentoTile(
      glow: colors.primary,
      onTap: () => position == null
          ? context.go(AppRoutes.quran)
          : context.pushNamed(
              AppRoutes.quranPageName,
              pathParameters: {'page': '${position.page}'},
            ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Caption(
                  LucideIcons.bookOpenText,
                  position == null ? l10n.startReading : l10n.continueReading,
                  color: colors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                if (surah != null)
                  Text(
                    context.surahName(surah),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleLarge,
                  ),
                if (quran.plan != null)
                  Text(
                    context.digits(
                      quran.pagesLeftToday(DateTime.now()) == 0
                          ? l10n.khatmahDone
                          : l10n.khatmahToday(
                              quran.plan!.portion(DateTime.now()).$1,
                              quran.plan!.portion(DateTime.now()).$2,
                            ),
                    ),
                    style: text.bodySmall,
                  )
                else if (position != null)
                  Text(
                    context.digits(
                      l10n.pageAyah(position.page, position.ref.ayah),
                    ),
                    style: text.bodySmall,
                  ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: colors.text.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
          if (surah != null) ...[
            const SizedBox(width: AppSpacing.lg),
            Text(
              surah.nameArabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: 30,
                color: colors.text,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MoonTile extends StatelessWidget {
  const _MoonTile();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final hijri = context.select((HijriCubit c) => c.state.today);
    return BentoTile(
      onTap: () => context.pushNamed(AppRoutes.hijriName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              // A faint rim keeps the disc visible around the new moon.
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.text.withValues(alpha: 0.18),
                  ),
                ),
                child: MoonPhaseIcon(
                  age: Solar.moonAge(DateTime.now()),
                  size: 64,
                  lit: const Color(0xFFF5F1E4),
                  dark: colors.text.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          if (hijri != null) ...[
            Text(
              context.digits('${hijri.day}'),
              style: text.headlineMedium?.copyWith(height: 1),
            ),
            Text(
              context.digits(
                '${context.l10n.hijriMonthName(hijri.month)} ${hijri.year}',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

/// A small compass: the dial turns with the phone while the tile is on
/// screen (the sensor is off the rest of the time), and the amber needle shows
/// the Qibla.
class _QiblaTile extends StatefulWidget {
  const _QiblaTile();

  @override
  State<_QiblaTile> createState() => _QiblaTileState();
}

class _QiblaTileState extends State<_QiblaTile> with LiveStateMixin {
  ScrollPosition? _scroll;
  StreamSubscription<void>? _compass;
  double? _heading;
  bool _onScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scroll = Scrollable.maybeOf(context)?.position;
    if (scroll != _scroll) {
      _scroll?.removeListener(_checkOnScreen);
      _scroll = scroll?..addListener(_checkOnScreen);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnScreen());
  }

  @override
  void onLiveChanged(bool live) => _checkOnScreen();

  /// The compass runs only while the tile is visible in the viewport.
  void _checkOnScreen() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    var visible = false;
    if (isLive && box != null && box.hasSize && box.attached) {
      final top = box.localToGlobal(Offset.zero).dy;
      final screen = MediaQuery.sizeOf(context).height;
      // At least half of the tile, above the navigation bar.
      final middle = top + box.size.height / 2;
      visible = middle > 0 && middle < screen - context.navBarClearance;
    }
    if (visible == _onScreen) return;
    _onScreen = visible;
    _compass?.cancel();
    _compass = null;
    final where = context.read<LocationCubit>().state.location?.coordinates;
    if (visible && where != null) {
      _compass = getIt<WatchCompassUseCase>()(where).listen(
        (r) => r.fold((_) {}, (reading) {
          if (mounted) setState(() => _heading = reading.heading);
        }),
      );
    } else if (_heading != null) {
      setState(() => _heading = null);
    }
  }

  @override
  void dispose() {
    _scroll?.removeListener(_checkOnScreen);
    _compass?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final where = context.select(
      (LocationCubit c) => c.state.location?.coordinates,
    );
    final bearing = where == null ? null : Qibla.bearingFrom(where);
    final heading = _heading;
    final facing =
        bearing != null &&
        heading != null &&
        (((bearing - heading + 540) % 360) - 180).abs() < 4;
    return BentoTile(
      glow: facing ? colors.accent : null,
      onTap: () => context.go(AppRoutes.qibla),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: SizedBox.square(
                dimension: 72,
                child: TweenAnimationBuilder<double>(
                  // The dial eases towards each reading rather than jumping.
                  tween: Tween(end: -(heading ?? 0)),
                  duration: const Duration(milliseconds: 200),
                  builder: (_, rotation, _) => CustomPaint(
                    painter: _MiniCompassPainter(
                      bearing: bearing,
                      rotation: rotation,
                      ring: colors.text.withValues(alpha: 0.14),
                      north: colors.textMuted,
                      needle: colors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(l10n.qibla, style: text.titleMedium),
          Text(
            bearing == null
                ? l10n.setLocation
                : l10n.degreesFromNorth(
                    context.formatNumber(bearing, decimals: 0),
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// A dial with north at the top and the Qibla as an amber needle.
class _MiniCompassPainter extends CustomPainter {
  const _MiniCompassPainter({
    required this.bearing,
    this.rotation = 0,
    required this.ring,
    required this.north,
    required this.needle,
  });

  final double? bearing;

  /// Degrees the dial is turned by (minus the phone's heading).
  final double rotation;
  final Color ring;
  final Color north;
  final Color needle;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rotation * math.pi / 180);
    canvas.translate(-c.dx, -c.dy);
    final tick = Paint()
      ..color = ring
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 36; i++) {
      final a = i * math.pi / 18;
      final len = i % 9 == 0 ? 7.0 : 3.5;
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(c + dir * (r - len), c + dir * r, tick);
    }
    canvas.drawCircle(
      c + const Offset(0, -1) * (r - 13),
      2.5,
      Paint()..color = north,
    );
    final b = bearing;
    if (b == null) return;
    final a = b * math.pi / 180;
    final dir = Offset(math.sin(a), -math.cos(a));
    canvas.drawLine(
      c - dir * 8,
      c + dir * (r - 14),
      Paint()
        ..color = needle
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(c, 3.5, Paint()..color = needle);
    final kaaba = c + dir * (r - 14);
    canvas.drawRect(
      Rect.fromCenter(center: kaaba, width: 8, height: 8),
      Paint()..color = const Color(0xFF151515),
    );
    canvas.drawRect(
      Rect.fromLTWH(kaaba.dx - 4, kaaba.dy - 2, 8, 1.6),
      Paint()..color = needle,
    );
  }

  @override
  bool shouldRepaint(_MiniCompassPainter old) =>
      old.bearing != bearing ||
      old.rotation != rotation ||
      old.needle != needle ||
      old.ring != ring;
}

class _TasbihTile extends StatelessWidget {
  const _TasbihTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BentoTile(
      onTap: () => context.pushNamed(AppRoutes.tasbihName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Center(
              child: SizedBox.square(
                dimension: 72,
                child: CustomPaint(painter: _MiniBeadsPainter()),
              ),
            ),
          ),
          Text(l10n.tasbih, style: text.titleMedium),
          Text(
            l10n.tasbihHint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// A small string of amber beads.
class _MiniBeadsPainter extends CustomPainter {
  const _MiniBeadsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 6;
    const n = 15;
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + (i + 0.5) * 2 * math.pi / n;
      final p = c + Offset.fromDirection(a, r);
      canvas.drawCircle(
        p,
        5.2,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.4),
            colors: const [
              Color(0xFFFFF0D6),
              Color(0xFFF6CC8E),
              Color(0xFF8E4F1E),
            ],
            stops: const [0, 0.35, 1],
          ).createShader(Rect.fromCircle(center: p, radius: 5.2)),
      );
    }
  }

  @override
  bool shouldRepaint(_MiniBeadsPainter old) => false;
}

class _DhikrTile extends StatelessWidget {
  const _DhikrTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return BentoTile(
      glow: colors.secondary,
      onTap: () => context.go(AppRoutes.azkar),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Icon(
                LucideIcons.handHeart,
                size: 44,
                color: colors.secondary,
              ),
            ),
          ),
          Text(l10n.azkar, style: text.titleMedium),
          Text(
            l10n.azkarHint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// An ayah for the day, the same for everyone on a given date.
class _AyahTile extends StatelessWidget {
  const _AyahTile();

  static const _refs = [
    AyahRef(2, 152),
    AyahRef(2, 186),
    AyahRef(2, 286),
    AyahRef(3, 139),
    AyahRef(3, 173),
    AyahRef(3, 200),
    AyahRef(9, 51),
    AyahRef(13, 28),
    AyahRef(14, 7),
    AyahRef(16, 128),
    AyahRef(20, 114),
    AyahRef(29, 69),
    AyahRef(39, 53),
    AyahRef(40, 60),
    AyahRef(65, 3),
    AyahRef(94, 5),
    AyahRef(94, 6),
    AyahRef(2, 153),
    AyahRef(2, 201),
    AyahRef(3, 8),
    AyahRef(25, 74),
    AyahRef(17, 80),
    AyahRef(21, 87),
    AyahRef(28, 24),
    AyahRef(33, 41),
    AyahRef(42, 19),
    AyahRef(50, 16),
    AyahRef(57, 4),
    AyahRef(64, 11),
    AyahRef(93, 5),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final data = context.select((QuranCubit c) => c.state.data);
    if (data == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final day =
        DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/
        86400000;
    final ref = _refs[day % _refs.length];
    final style = TextStyle(
      fontFamily: context.quranFont,
      fontSize: 21,
      height: 2,
      color: colors.text,
    );
    return BentoTile(
      onTap: () => context.pushNamed(
        AppRoutes.quranSurahName,
        pathParameters: {'surah': '${ref.surah}'},
        queryParameters: {'ayah': '${ref.ayah}'},
      ),
      padding: const EdgeInsets.all(AppSpacing.xl - 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Caption(LucideIcons.sunrise, l10n.ayahOfTheDay),
          const SizedBox(height: AppSpacing.md),
          Text.rich(
            TextSpan(
              children: [
                for (final r in data.fromHafsRange(ref, ref)) ...[
                  TextSpan(text: data.text(r)),
                  ayahNumberSpan(
                    context,
                    ayah: r.ayah,
                    style: style,
                    color: colors.primary,
                  ),
                ],
              ],
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: style,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.digits(
              l10n.surahAyah(
                context.surahName(data.surah(ref.surah)),
                data.fromHafs(ref).ayah,
              ),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
