import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
import '../../../prayer_times/presentation/widgets/location_chip.dart';
import '../../../prayer_times/presentation/widgets/set_location_card.dart';
import '../../../prayer_times/presentation/widgets/sky_hero_card.dart';
import '../../../quran/domain/entities/quran_entities.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/ayah_number.dart';
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
      if (hasLocation)
        SkyHeroCard(onTap: () => context.go(AppRoutes.prayer))
      else
        const SetLocationCard(),
    ];

    final secondary = <Widget>[
      const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _ReadingTile()),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _AzkarTile()),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
      const _QuickActions(),
      const SizedBox(height: AppSpacing.xl),
      const _DailyAyah(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            context.navBarClearance,
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
                    const SizedBox(height: AppSpacing.lg),
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

/// A compact square tile: icon, title, one line of detail.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colors.primary),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: text.titleSmall, maxLines: 2),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  const _ReadingTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<QuranCubit>().state;
    final position = state.position;
    final surah = state.data?.surah(position?.ref.surah ?? 1);
    return _Tile(
      icon: LucideIcons.bookOpenText,
      title: position == null ? l10n.startReading : l10n.continueReading,
      subtitle: position == null || surah == null
          ? null
          : context.digits(
              l10n.surahAyah(context.surahName(surah), position.ref.ayah),
            ),
      trailing: surah == null
          ? null
          : Text(
              surah.nameArabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFonts.display,
                fontSize: 17,
                color: colors.accent,
              ),
            ),
      onTap: () => context.pushNamed(
        AppRoutes.quranPageName,
        pathParameters: {'page': '${position?.page ?? 1}'},
      ),
    );
  }
}

class _AzkarTile extends StatelessWidget {
  const _AzkarTile();

  @override
  Widget build(BuildContext context) {
    final key = suggestedAzkarKey(DateTime.now()) ?? 'after_prayer';
    final category = context.select((AzkarCubit c) => c.state.byKey(key));
    if (category == null) return const SizedBox.shrink();
    return _Tile(
      icon: azkarIcon(key),
      title: context.azkarTitle(category),
      subtitle: context.digits(context.l10n.itemsCount(category.items.length)),
      onTap: () => context.pushNamed(
        AppRoutes.azkarCategoryName,
        pathParameters: {'categoryId': '${category.id}'},
      ),
    );
  }
}

/// Round shortcuts without cards: the quieter the home screen, the better.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final actions = [
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
      children: [
        for (final (icon, label, onTap) in actions)
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surfaceHigh,
                        border: Border.all(color: colors.outline),
                      ),
                      child: Icon(icon, size: 22, color: colors.text),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final text = Theme.of(context).textTheme;
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

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () => context.pushNamed(
        AppRoutes.quranSurahName,
        pathParameters: {'surah': '${ref.surah}'},
        queryParameters: {'ayah': '${ref.ayah}'},
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.dailyAyah.toUpperCase(),
              textAlign: TextAlign.center,
              style: text.labelSmall?.copyWith(
                color: colors.textMuted,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.digits(
                context.l10n.surahAyah(context.surahName(surah), ref.ayah),
              ),
              textAlign: TextAlign.center,
              style: text.labelMedium?.copyWith(color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
