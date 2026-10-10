import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../l10n/l10n.dart';
import '../../../azkar/presentation/cubit/azkar_cubit.dart';
import '../../../azkar/presentation/widgets/azkar_labels.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../hijri/presentation/widgets/hijri_labels.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../../quran/domain/entities/quran_entities.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/ayah_number.dart';
import '../../../quran/presentation/widgets/surah_labels.dart';
import '../widgets/living_sky/living_sky.dart';

/// Home is a place rather than a page: the living sky above the user, with the
/// next prayer written across it. Swiping up dives into the day.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  /// 0 at rest, 1 when the dive into the day completes.
  late final AnimationController _dive = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  bool _passedThreshold = false;

  /// Where the sky is drawn from before the user has set a location.
  static const _defaultSky = Coordinates(latitude: 21.4225, longitude: 39.8262);
  static const _threshold = 0.32;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
    context.read<AzkarCubit>().load();
  }

  @override
  void dispose() {
    _dive.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _dive.value = (_dive.value - d.primaryDelta! / 320).clamp(0.0, 1.0);
    final passed = _dive.value > _threshold;
    if (passed != _passedThreshold) {
      _passedThreshold = passed;
      if (passed) HapticFeedback.lightImpact();
    }
  }

  Future<void> _onDragEnd(DragEndDetails d) async {
    final velocity = d.primaryVelocity ?? 0;
    if (_dive.value > _threshold || velocity < -900) {
      await _diveIn();
    } else {
      _passedThreshold = false;
      await _dive.animateBack(0, curve: Curves.easeOutCubic);
    }
  }

  Future<void> _diveIn() async {
    HapticFeedback.mediumImpact();
    await _dive.animateTo(1, curve: Curves.easeInCubic);
    if (!mounted) return;
    // A fresh value each time lets the day screen replay its arrival.
    context.goNamed(
      AppRoutes.prayerName,
      queryParameters: {'dive': '${DateTime.now().millisecondsSinceEpoch}'},
    );
    _passedThreshold = false;
    // Home stays alive in the background tab; reset it out of sight.
    WidgetsBinding.instance.addPostFrameCallback((_) => _dive.value = 0);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.select((LocationCubit c) => c.state.location);
    final where = location?.coordinates ?? _defaultSky;
    final tall = MediaQuery.sizeOf(context).height > 700;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onVerticalDragUpdate: location == null ? null : _onDragUpdate,
          onVerticalDragEnd: location == null ? null : _onDragEnd,
          child: AnimatedBuilder(
            animation: _dive,
            builder: (context, _) {
              final v = Curves.easeIn.transform(_dive.value);
              return Stack(
                fit: StackFit.expand,
                children: [
                  // The scene zooms towards the horizon as the user dives.
                  Transform.scale(
                    scale: 1 + v * 0.45,
                    alignment: const Alignment(0, 0.2),
                    child: LivingSky(coordinates: where),
                  ),
                  // A veil at the top keeps the status bar and text legible.
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0, -0.2),
                          colors: [Color(0x66000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: (1 - v * 1.8).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, -80 * v),
                      child: SafeArea(
                        bottom: false,
                        child: ContentWidth(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.xl,
                              AppSpacing.lg,
                              AppSpacing.xl,
                              context.navBarClearance - AppSpacing.md,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _TopBar(),
                                const SizedBox(height: AppSpacing.xxl),
                                if (location == null)
                                  const _SetLocationPrompt()
                                else
                                  const _NextPrayer(),
                                // The ayah hangs in the open sky, well above the horizon.
                                const Spacer(flex: 2),
                                if (tall) const _FloatingAyah(),
                                const Spacer(flex: 3),
                                const _Tiles(),
                                const SizedBox(height: AppSpacing.lg),
                                const _Shortcuts(),
                                if (location != null) ...[
                                  const SizedBox(height: AppSpacing.md),
                                  _DiveHint(onTap: _diveIn),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

const _onSky = Colors.white;
final _onSkyMuted = Colors.white.withValues(alpha: 0.72);

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final location = context.select((LocationCubit c) => c.state.location);
    final hijri = context.select((HijriCubit c) => c.state.today);
    return Row(
      children: [
        if (location != null)
          Flexible(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: () => context.pushNamed(AppRoutes.locationName),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.mapPin, size: 15, color: _onSkyMuted),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        location.name ?? context.l10n.unknownPlace,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelLarge?.copyWith(color: _onSkyMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const Spacer(),
        if (hijri != null)
          Text(
            context.formatHijri(hijri),
            style: text.labelLarge?.copyWith(color: _onSkyMuted),
          ),
      ],
    );
  }
}

/// The next prayer, large, with a live countdown.
class _NextPrayer extends StatefulWidget {
  const _NextPrayer();

  @override
  State<_NextPrayer> createState() => _NextPrayerState();
}

class _NextPrayerState extends State<_NextPrayer> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() => _now = now);
      final today = context.read<PrayerTimesCubit>().state.today?.date;
      if (today != null && (today.day != now.day || today.month != now.month)) {
        context.read<PrayerTimesCubit>().refresh();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final next = context.watch<PrayerTimesCubit>().state.nextAfter(_now);
    if (next == null) return const SizedBox(height: 140);
    final remaining = next.time.difference(_now);
    final shadow = [
      Shadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 24),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nextPrayer.toUpperCase(),
          style: text.labelMedium?.copyWith(
            color: _onSkyMuted,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.prayerName(next.prayer, on: next.time.toLocal()),
          style: text.displayMedium?.copyWith(
            color: _onSky,
            fontWeight: FontWeight.w300,
            height: 1.05,
            shadows: shadow,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              context.formatTime(next.time),
              style: text.headlineSmall?.copyWith(
                color: _onSky,
                fontWeight: FontWeight.w600,
                shadows: shadow,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                l10n.timeUntil(
                  context.formatDuration(
                    remaining.isNegative ? Duration.zero : remaining,
                  ),
                ),
                style: text.titleSmall?.copyWith(
                  color: _onSkyMuted,
                  shadows: shadow,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SetLocationPrompt extends StatelessWidget {
  const _SetLocationPrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final busy = context.select(
      (LocationCubit c) => c.state.status == LocationStatus.locating,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.setLocation,
          style: text.headlineMedium?.copyWith(
            color: _onSky,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.setLocationHint,
          style: text.bodyMedium?.copyWith(color: _onSkyMuted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            GlassPanel(
              radius: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              onTap: busy
                  ? null
                  : () => context.read<LocationCubit>().locate(
                      context.languageCode,
                    ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.locateFixed, size: 18, color: _onSky),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    busy ? l10n.locating : l10n.useCurrentLocation,
                    style: const TextStyle(color: _onSky),
                  ),
                ],
              ),
            ),
            GlassPanel(
              radius: 24,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              onTap: () => context.pushNamed(AppRoutes.locationName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.search, size: 18, color: _onSky),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.searchCity, style: const TextStyle(color: _onSky)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The ayah of the day, hanging in the sky above the horizon.
class _FloatingAyah extends StatelessWidget {
  const _FloatingAyah();

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
    final data = context.select((QuranCubit c) => c.state.data);
    if (data == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final day =
        DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/
        86400000;
    final ref = _refs[day % _refs.length];
    final style = TextStyle(
      fontFamily: AppFonts.quran,
      fontSize: 20,
      height: 1.9,
      color: _onSky.withValues(alpha: 0.92),
      shadows: [
        Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 18),
      ],
    );

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.quranSurahName,
        pathParameters: {'surah': '${ref.surah}'},
        queryParameters: {'ayah': '${ref.ayah}'},
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: data.text(ref)),
                ayahNumberSpan(
                  context,
                  ayah: ref.ayah,
                  style: style,
                  color: _onSkyMuted,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: style,
          ),
          Text(
            context.digits(
              context.l10n.surahAyah(
                context.surahName(data.surah(ref.surah)),
                ref.ayah,
              ),
            ),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: _onSkyMuted, letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}

class _Tiles extends StatelessWidget {
  const _Tiles();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quran = context.watch<QuranCubit>().state;
    final position = quran.position;
    final surah = quran.data?.surah(position?.ref.surah ?? 1);
    final azkarKey = suggestedAzkarKey(DateTime.now()) ?? 'after_prayer';
    final azkar = context.select((AzkarCubit c) => c.state.byKey(azkarKey));

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _GlassTile(
              icon: LucideIcons.bookOpenText,
              title: position == null
                  ? l10n.startReading
                  : l10n.continueReading,
              subtitle: position == null || surah == null
                  ? null
                  : context.digits(
                      l10n.surahAyah(
                        context.surahName(surah),
                        position.ref.ayah,
                      ),
                    ),
              onTap: () => context.pushNamed(
                AppRoutes.quranPageName,
                pathParameters: {'page': '${position?.page ?? 1}'},
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _GlassTile(
              icon: azkarIcon(azkarKey),
              title: azkar == null ? l10n.azkar : context.azkarTitle(azkar),
              subtitle: azkar == null
                  ? null
                  : context.digits(l10n.itemsCount(azkar.items.length)),
              onTap: azkar == null
                  ? () => context.go(AppRoutes.azkar)
                  : () => context.pushNamed(
                      AppRoutes.azkarCategoryName,
                      pathParameters: {'categoryId': '${azkar.id}'},
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  const _GlassTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return GlassPanel(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: _onSky),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            maxLines: 2,
            style: text.titleSmall?.copyWith(color: _onSky),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: _onSkyMuted),
            ),
        ],
      ),
    );
  }
}

class _Shortcuts extends StatelessWidget {
  const _Shortcuts();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (
        LucideIcons.compass,
        l10n.qibla,
        () => context.pushNamed(AppRoutes.qiblaName),
      ),
      (
        LucideIcons.circleDot,
        l10n.tasbih,
        () => context.pushNamed(AppRoutes.tasbihName),
      ),
      (
        LucideIcons.calendarDays,
        l10n.hijriCalendar,
        () => context.pushNamed(AppRoutes.hijriName),
      ),
      (LucideIcons.bookmark, l10n.bookmarks, () => context.go(AppRoutes.quran)),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (icon, label, onTap) in items)
          Tooltip(
            message: label,
            child: Semantics(
              button: true,
              label: label,
              child: GlassPanel(
                shape: BoxShape.circle,
                padding: const EdgeInsets.all(16),
                onTap: onTap,
                child: Icon(icon, size: 22, color: _onSky),
              ),
            ),
          ),
      ],
    );
  }
}

/// "Swipe up for your day", with a chevron that breathes upwards.
class _DiveHint extends StatefulWidget {
  const _DiveHint({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_DiveHint> createState() => _DiveHintState();
}

class _DiveHintState extends State<_DiveHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _bob,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                0,
                still ? 0 : -4 * Curves.easeInOut.transform(_bob.value),
              ),
              child: child,
            ),
            child: Icon(LucideIcons.chevronUp, color: _onSkyMuted, size: 20),
          ),
          Text(
            context.l10n.diveHint,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: _onSkyMuted, letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}
