import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/azkar_entities.dart';
import '../cubit/azkar_cubit.dart';
import '../widgets/azkar_labels.dart';

/// Reads a category one dhikr after another. Tapping a card counts one
/// repetition; when its count is reached the next card scrolls into view.
class AzkarReaderPage extends StatefulWidget {
  const AzkarReaderPage({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<AzkarReaderPage> createState() => _AzkarReaderPageState();
}

class _AzkarReaderPageState extends State<AzkarReaderPage> {
  final _keys = <int, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().load();
  }

  void _scrollTo(DhikrItem item) {
    final ctx = _keys[item.id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = context.select(
      (AzkarCubit c) => c.state.byId(widget.categoryId),
    );
    if (category == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (_) => getIt<AzkarSessionCubit>(),
      child: Builder(
        builder: (context) {
          final session = context.watch<AzkarSessionCubit>().state;
          final done = category.items.where(session.isDone).length;
          final total = category.items.length;
          final allDone = done == total;

          return Scaffold(
            appBar: AppBar(
              title: Text(context.azkarTitle(category)),
              actions: [
                IconButton(
                  tooltip: l10n.restart,
                  icon: const Icon(LucideIcons.rotateCcw),
                  onPressed: context.read<AzkarSessionCubit>().restart,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: total == 0 ? 0 : done / total,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        context.digits(l10n.progressOf(done, total)),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: ContentWidth(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xxxl,
                ),
                children: [
                  for (final (i, item) in category.items.indexed) ...[
                    _DhikrCard(
                      key: _keys.putIfAbsent(item.id, GlobalKey.new),
                      item: item,
                      onCompleted: () {
                        final next = category.items
                            .skip(i + 1)
                            .where((x) => !session.isDone(x))
                            .firstOrNull;
                        if (next != null) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollTo(next),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (allDone)
                    _DoneBanner(
                      onRestart: context.read<AzkarSessionCubit>().restart,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({super.key, required this.item, required this.onCompleted});

  final DhikrItem item;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final session = context.watch<AzkarSessionCubit>().state;
    final left = session.left(item);
    final done = left == 0;
    final showTranslation = context.languageCode != 'ar';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: done ? 0.55 : 1,
      child: AppCard(
        onTap: done
            ? null
            : () {
                if (context.read<AzkarSessionCubit>().count(item)) {
                  onCompleted();
                }
              },
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.arabic,
              textDirection: TextDirection.rtl,
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.9,
                fontSize: 21,
              ),
            ),
            if (showTranslation && item.translation != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                item.translation!,
                textDirection: TextDirection.ltr,
                style: text.bodyMedium?.copyWith(
                  color: colors.textMuted,
                  height: 1.6,
                ),
              ),
            ],
            if (item.virtue != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  item.virtue!,
                  textDirection: TextDirection.rtl,
                  style: text.bodySmall?.copyWith(height: 1.7),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                if (item.reference != null)
                  IconButton(
                    tooltip: l10n.source,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      LucideIcons.info,
                      color: colors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => _showReference(context, item.reference!),
                  ),
                Text(
                  context.digits(l10n.repeatCount(item.count)),
                  style: text.labelMedium?.copyWith(color: colors.textMuted),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, a) =>
                      ScaleTransition(scale: a, child: child),
                  child: Container(
                    key: ValueKey(left),
                    constraints: const BoxConstraints(minWidth: 52),
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: done
                          ? colors.primary
                          : colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: done
                        ? Icon(LucideIcons.check, color: colors.onPrimary)
                        : Text(
                            context.digits(left),
                            style: text.titleLarge?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if (!done && item.count > 1)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  l10n.tapToCount,
                  textAlign: TextAlign.end,
                  style: text.labelSmall?.copyWith(color: colors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static void _showReference(BuildContext context, String reference) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.source,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(reference, style: const TextStyle(height: 1.8)),
              ],
            ),
          ),
        ),
      );
}

class _DoneBanner extends StatelessWidget {
  const _DoneBanner({required this.onRestart});
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
    child: MessageView(
      icon: LucideIcons.heart,
      message: context.l10n.azkarDone,
      actionLabel: context.l10n.restart,
      onAction: onRestart,
    ),
  );
}
