import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/bento_tile.dart';
import '../../../../core/widgets/hub_header.dart';
import '../../../../l10n/l10n.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../domain/entities/azkar_entities.dart';
import '../cubit/azkar_cubit.dart';
import '../widgets/azkar_labels.dart';

/// The Dhikr tab: the adhkar after the prayer just prayed and the misbaha
/// first, then the adhkar of the day, then every supplication of Hisn
/// al-Muslim, searchable.
class DhikrPage extends StatefulWidget {
  const DhikrPage({super.key});

  @override
  State<DhikrPage> createState() => _DhikrPageState();
}

class _DhikrPageState extends State<DhikrPage> {
  String _query = '';

  /// The after-prayer adhkar have their own guided session above.
  static const _featured = ['morning', 'evening', 'sleep', 'waking'];

  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<AzkarCubit>().state;
    final featured = [for (final key in _featured) ?state.byKey(key)];
    final q = _query.trim().toLowerCase();
    final others = state.categories
        .where((c) => !_featured.contains(c.key))
        .where(
          (c) =>
              q.isEmpty ||
              c.titleArabic.contains(q) ||
              c.titleEnglish.toLowerCase().contains(q) ||
              context.azkarTitle(c).toLowerCase().contains(q),
        )
        .toList();
    final columns = context.windowSize == WindowSize.compact ? 2 : 4;

    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: ContentWidth(
            maxWidth: 900,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HubHeader(
                    title: l10n.navDhikr,
                    subtitle: l10n.dhikrSubtitle,
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverToBoxAdapter(child: _AfterPrayerHero()),
                ),
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(child: _MisbahaTile()),
                ),
                if (featured.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      0,
                    ),
                    sliver: SliverGrid.count(
                      crossAxisCount: columns,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.15,
                      children: [
                        for (final c in featured) _FeaturedTile(category: c),
                      ],
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.sm,
                            right: AppSpacing.sm,
                            bottom: AppSpacing.md,
                          ),
                          child: Text(
                            l10n.allCategories,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        _SearchField(
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.status != AzkarStatus.ready)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  sliver: SliverList.builder(
                    itemCount: others.length,
                    itemBuilder: (context, i) => _CategoryRow(others[i]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: context.navBarClearance + AppSpacing.xxl,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _open(BuildContext context, AzkarCategory c) => context.pushNamed(
  AppRoutes.azkarCategoryName,
  pathParameters: {'categoryId': '${c.id}'},
);

/// The adhkar after the prayer whose time came last, as a guided session.
class _AfterPrayerHero extends StatelessWidget {
  const _AfterPrayerHero();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final prayer = context.select(
      (PrayerTimesCubit c) => c.state.lastPrayerAt(DateTime.now()),
    );
    return BentoTile(
      glow: colors.accent,
      padding: const EdgeInsets.all(AppSpacing.xl),
      onTap: () => context.pushNamed(
        AppRoutes.afterPrayerName,
        queryParameters: {'prayer': prayer.name},
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.sparkles, size: 15, color: colors.accent),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Text(
                      l10n.afterPrayer,
                      style: text.labelMedium?.copyWith(color: colors.accent),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.afterPrayerOf(
                    l10n.prayerName(prayer, on: DateTime.now()),
                  ),
                  style: text.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.afterPrayerHint, style: text.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accent,
            ),
            child: Icon(
              context.forwardArrow,
              color: colors.background,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _MisbahaTile extends StatelessWidget {
  const _MisbahaTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return BentoTile(
      onTap: () => context.pushNamed(AppRoutes.tasbihName),
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 76,
            child: CustomPaint(painter: _BeadArcPainter()),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tasbih, style: text.titleLarge),
                Text(l10n.tasbihHint, style: text.bodySmall),
              ],
            ),
          ),
          Icon(context.forwardChevron, color: context.colors.textFaint),
        ],
      ),
    );
  }
}

/// A ring of amber beads with the imam bead at the top.
class _BeadArcPainter extends CustomPainter {
  const _BeadArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 6;
    const n = 17;
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + (i + 1) * 2 * math.pi / (n + 1);
      _bead(canvas, c + Offset.fromDirection(a, r), 5.4);
    }
    // The imam bead, elongated along the radius.
    final top = c + Offset(0, -r);
    final rect = Rect.fromCenter(center: top, width: 9, height: 15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4.5)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFF6CC8E), Color(0xFF8E4F1E)],
        ).createShader(rect),
    );
  }

  static void _bead(Canvas canvas, Offset p, double radius) =>
      canvas.drawCircle(
        p,
        radius,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.35, -0.4),
            colors: [Color(0xFFFFF0D6), Color(0xFFF6CC8E), Color(0xFF8E4F1E)],
            stops: [0, 0.35, 1],
          ).createShader(Rect.fromCircle(center: p, radius: radius)),
      );

  @override
  bool shouldRepaint(_BeadArcPainter old) => false;
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.category});
  final AzkarCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final night = category.key == 'evening' || category.key == 'sleep';
    final tint = night ? colors.secondary : colors.primary;
    return BentoTile(
      glow: tint,
      onTap: () => _open(context, category),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(azkarIcon(category.key), color: tint, size: 26),
          const Spacer(),
          Text(
            context.azkarTitle(category),
            maxLines: 2,
            style: text.titleMedium,
          ),
          Text(
            context.digits(context.l10n.itemsCount(category.items.length)),
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: colors.hairline),
    );
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: context.l10n.searchAzkar,
        prefixIcon: const Icon(LucideIcons.search, size: 20),
        filled: true,
        fillColor: colors.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.category);

  final AzkarCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: Icon(azkarIcon(category.key), size: 20),
      title: Text(context.azkarTitle(category)),
      trailing: Text(
        context.digits(category.items.length),
        style: TextStyle(color: colors.textFaint),
      ),
      onTap: () => _open(context, category),
    );
  }
}
