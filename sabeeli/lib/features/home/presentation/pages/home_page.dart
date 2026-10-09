import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../azkar/presentation/cubit/azkar_cubit.dart';
import '../../../azkar/presentation/widgets/azkar_labels.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/location_chip.dart';
import '../../../prayer_times/presentation/widgets/next_prayer_card.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../../prayer_times/presentation/widgets/set_location_card.dart';
import '../../../quran/domain/entities/quran_entities.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/ayah_number.dart';
import '../../../quran/presentation/widgets/continue_reading_card.dart';
import '../../../quran/presentation/widgets/surah_labels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
    context.read<AzkarCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final hasLocation = context.select(
      (LocationCubit c) => c.state.location != null,
    );
    final wide = context.windowSize != WindowSize.compact;

    final primary = <Widget>[
      if (hasLocation) ...[
        NextPrayerCard(onTap: () => context.go(AppRoutes.prayer)),
        const SizedBox(height: AppSpacing.md),
        const _PrayerStrip(),
      ] else
        const SetLocationCard(),
    ];

    final secondary = <Widget>[
      const _SuggestedAzkar(),
      const SizedBox(height: AppSpacing.md),
      const ContinueReadingCard(),
      SectionHeader(l10n.more),
      const _QuickActions(),
      SectionHeader(l10n.dailyAyah),
      const _DailyAyah(),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            ContentWidth(
              maxWidth: wide ? 1100 : 720,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.salam,
                    style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          context.formatWeekdayDate(DateTime.now()),
                          style: text.bodyMedium?.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                      if (hasLocation) ...[
                        Text(
                          '  ·  ',
                          style: TextStyle(color: colors.textMuted),
                        ),
                        const Flexible(child: LocationChip()),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: secondary,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    ...primary,
                    const SizedBox(height: AppSpacing.md),
                    ...secondary,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Today's five prayers at a glance.
class _PrayerStrip extends StatelessWidget {
  const _PrayerStrip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<PrayerTimesCubit>().state;
    final today = state.today;
    if (today == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final next = state.nextAfter(now)?.prayer;
    final prayers = Prayer.values.where((p) => p.isObligatory);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xs,
      ),
      onTap: () => context.go(AppRoutes.prayer),
      child: Row(
        children: [
          for (final p in prayers)
            Expanded(
              child: Column(
                children: [
                  Icon(
                    prayerIcon(p),
                    size: 18,
                    color: p == next ? colors.accent : colors.textMuted,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.prayerName(p, on: now),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: p == next ? colors.accent : colors.textMuted,
                    ),
                  ),
                  Text(
                    context.formatTime(today.timeOf(p)),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: p == next
                          ? colors.text
                          : colors.text.withValues(alpha: 0.85),
                      fontWeight: p == next ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestedAzkar extends StatelessWidget {
  const _SuggestedAzkar();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final key = suggestedAzkarKey(DateTime.now());
    final category = key == null
        ? null
        : context.select((AzkarCubit c) => c.state.byKey(key));
    if (category == null) return const SizedBox.shrink();
    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.azkarCategoryName,
        pathParameters: {'categoryId': '${category.id}'},
      ),
      child: Row(
        children: [
          IconBadge(azkarIcon(key), color: colors.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.azkarTitle(category),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  context.digits(
                    context.l10n.itemsCount(category.items.length),
                  ),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: colors.textMuted, size: 20),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final actions = [
      (
        Icons.explore_rounded,
        l10n.qibla,
        () => context.pushNamed(AppRoutes.qiblaName),
      ),
      (
        Icons.radio_button_checked_rounded,
        l10n.tasbih,
        () => context.pushNamed(AppRoutes.tasbihName),
      ),
      (
        Icons.calendar_month_rounded,
        l10n.hijriCalendar,
        () => context.pushNamed(AppRoutes.hijriName),
      ),
      (
        Icons.bookmark_rounded,
        l10n.bookmarks,
        () => context.go(AppRoutes.quran),
      ),
    ];
    return Row(
      children: [
        for (final (i, (icon, label, onTap)) in actions.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppCard(
              onTap: onTap,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.xs,
              ),
              child: Column(
                children: [
                  Icon(icon, color: colors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A short, self-contained ayah for each day, chosen from a fixed list by date so
/// everyone sees the same one and it does not change during the day.
class _DailyAyah extends StatelessWidget {
  const _DailyAyah();

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
    final colors = context.colors;
    final data = context.select((QuranCubit c) => c.state.data);
    if (data == null) return const SizedBox(height: 120);
    final now = DateTime.now();
    final day =
        DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/
        86400000;
    final ref = _refs[day % _refs.length];
    final surah = data.surah(ref.surah);
    final quranStyle = TextStyle(
      fontFamily: AppFonts.quran,
      fontSize: 22,
      height: 2.0,
      color: colors.text,
    );

    return AppCard(
      onTap: () => context.pushNamed(
        AppRoutes.quranSurahName,
        pathParameters: {'surah': '${ref.surah}'},
        queryParameters: {'ayah': '${ref.ayah}'},
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: data.text(ref)),
                ayahNumberSpan(
                  context,
                  ayah: ref.ayah,
                  style: quranStyle,
                  color: colors.primary,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: quranStyle,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.digits(
              context.l10n.surahAyah(context.surahName(surah), ref.ayah),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: colors.accent),
          ),
        ],
      ),
    );
  }
}
