import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pill_tabs.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';

/// Today's portion of a plan, and where the reader stands in it.
extension KhatmahProgress on QuranState {
  /// Pages still to read today; 0 when today's portion is done.
  int pagesLeftToday(DateTime now) {
    final p = plan;
    if (p == null) return 0;
    final target = p.portion(now).$2;
    final at = position?.page ?? (p.fromPage - 1);
    return (target - at).clamp(0, QuranData.pageCount);
  }

  /// The surahs on the pages of today's portion, lit in the Quran sky.
  Set<int> todaysSurahs(DateTime now) {
    final p = plan;
    final d = data;
    if (p == null || d == null || p.dayOf(now) > p.days) return const {};
    final (from, to) = p.portion(now);
    return {
      for (var page = from; page <= to; page++)
        for (final ref in d.ayahsOnPage(page)) ref.surah,
    };
  }
}

/// Plans a khatmah: how many days, from the beginning or from where the reader
/// is. With a plan running, shows it and lets it end.
Future<void> showKhatmahSheet(BuildContext context) {
  final cubit = context.read<QuranCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const _KhatmahSheet()),
  );
}

class _KhatmahSheet extends StatefulWidget {
  const _KhatmahSheet();

  @override
  State<_KhatmahSheet> createState() => _KhatmahSheetState();
}

class _KhatmahSheetState extends State<_KhatmahSheet> {
  static const _choices = [7, 10, 15, 30, 60];
  int _days = 30;

  /// 0: from page 1; 1: from the current page.
  int _from = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<QuranCubit>().state;
    final current = state.plan;
    final here = state.position?.page;
    final fromPage = _from == 1 && here != null ? here : 1;
    final draft = KhatmahPlan(
      start: DateTime.now(),
      days: _days,
      fromPage: fromPage,
    );
    final ends = DateTime.now().add(Duration(days: _days - 1));

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.khatmahPlan, style: text.titleLarge),
            if (current != null) ...[
              const SizedBox(height: AppSpacing.md),
              _Current(plan: current),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: colors.hairline),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final d in _choices)
                  ChoiceChip(
                    label: Text(context.digits(l10n.khatmahDays(d))),
                    selected: _days == d,
                    onSelected: (_) => setState(() => _days = d),
                  ),
              ],
            ),
            if (here != null && here > 1) ...[
              const SizedBox(height: AppSpacing.md),
              PillTabs(
                labels: [
                  l10n.khatmahFromStart,
                  context.digits(l10n.khatmahFromHere(here)),
                ],
                selected: _from,
                onChanged: (i) => setState(() => _from = i),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Icon(LucideIcons.bookOpenCheck, color: colors.accent, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    context.digits(
                      '${l10n.khatmahPerDay(draft.pagesPerDay.ceil())} · '
                      '${l10n.khatmahEnds(context.formatShortDate(ends))}',
                    ),
                    style: text.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () {
                context.read<QuranCubit>().setPlan(draft);
                Navigator.of(context).pop();
              },
              child: Text(l10n.khatmahStart),
            ),
            if (current != null)
              TextButton(
                onPressed: () {
                  context.read<QuranCubit>().setPlan(null);
                  Navigator.of(context).pop();
                },
                child: Text(l10n.khatmahEnd),
              ),
          ],
        ),
      ),
    );
  }
}

class _Current extends StatelessWidget {
  const _Current({required this.plan});

  final KhatmahPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<QuranCubit>().state;
    final now = DateTime.now();
    final day = plan.dayOf(now).clamp(1, plan.days);
    final (from, to) = plan.portion(now);
    final left = state.pagesLeftToday(now);
    final reached = state.position?.page ?? plan.fromPage - 1;
    final share = ((reached - plan.fromPage + 1) / plan.pages).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.digits(l10n.khatmahDayOf(day, plan.days)),
          style: text.titleMedium?.copyWith(color: colors.accent),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.digits(
            '${l10n.khatmahToday(from, to)} · '
            '${left == 0 ? l10n.khatmahDone : l10n.khatmahLeft(left)}',
          ),
          style: text.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: share,
            minHeight: 4,
            color: colors.accent,
            backgroundColor: colors.text.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
