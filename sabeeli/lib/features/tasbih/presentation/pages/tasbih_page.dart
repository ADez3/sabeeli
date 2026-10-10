import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/tasbih_state_data.dart';
import '../cubit/tasbih_cubit.dart';
import '../widgets/misbaha.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<TasbihCubit>()..load(),
    child: const _TasbihView(),
  );
}

class _TasbihView extends StatelessWidget {
  const _TasbihView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final cubit = context.read<TasbihCubit>();
    final s = context.watch<TasbihCubit>().state;
    final isArabicUi = context.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasbih),
        actions: [
          IconButton(
            tooltip: l10n.vibration,
            icon: Icon(
              s.vibrate ? LucideIcons.vibrate : LucideIcons.smartphone,
            ),
            onPressed: cubit.toggleVibration,
          ),
          IconButton(
            tooltip: l10n.reset,
            icon: const Icon(LucideIcons.rotateCcw),
            onPressed: cubit.reset,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  for (final d in DhikrPresets.all)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: AppSpacing.sm,
                      ),
                      child: ChoiceChip(
                        label: Text(isArabicUi ? d.arabic : d.transliteration),
                        selected: d.id == s.dhikrId,
                        onSelected: (_) => cubit.selectDhikr(d.id),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final t in DhikrPresets.targets)
                  ChoiceChip(
                    label: Text(t == 0 ? l10n.noTarget : context.digits(t)),
                    selected: s.target == t,
                    onSelected: (_) => cubit.setTarget(t),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Misbaha(
                  onCount: cubit.increment,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.dhikr.arabic,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: AppFonts.display,
                          fontSize: 22,
                          color: colors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 120),
                        transitionBuilder: (child, a) =>
                            ScaleTransition(scale: a, child: child),
                        child: Text(
                          context.digits(s.count),
                          key: ValueKey(s.count),
                          style: text.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.text,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      if (s.target > 0)
                        Text(
                          '/ ${context.digits(s.target)}',
                          style: text.titleMedium?.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    context.digits(l10n.rounds(s.rounds)),
                    style: text.titleSmall?.copyWith(color: colors.textMuted),
                  ),
                  Text(
                    context.digits(l10n.totalCount(s.total)),
                    style: text.titleSmall?.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
            Text(
              l10n.tapToCount,
              style: text.labelMedium?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
