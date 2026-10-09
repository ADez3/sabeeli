import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/azkar_entities.dart';
import '../cubit/azkar_cubit.dart';
import '../widgets/azkar_labels.dart';

class AzkarCategoriesPage extends StatefulWidget {
  const AzkarCategoriesPage({super.key});

  @override
  State<AzkarCategoriesPage> createState() => _AzkarCategoriesPageState();
}

class _AzkarCategoriesPageState extends State<AzkarCategoriesPage> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<AzkarCubit>().state;
    final featured = [for (final key in featuredAzkar) ?state.byKey(key)];
    final q = _query.trim().toLowerCase();
    final others = state.categories
        .where((c) => !featuredAzkar.contains(c.key))
        .where(
          (c) =>
              q.isEmpty ||
              c.titleArabic.contains(q) ||
              c.titleEnglish.toLowerCase().contains(q) ||
              context.azkarTitle(c).toLowerCase().contains(q),
        )
        .toList();
    final columns = context.windowSize == WindowSize.compact ? 2 : 3;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.azkar)),
      body: state.status != AzkarStatus.ready
          ? const Center(child: CircularProgressIndicator())
          : ContentWidth(
              maxWidth: 900,
              child: CustomScrollView(
                slivers: [
                  if (q.isEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      sliver: SliverGrid.count(
                        crossAxisCount: columns,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1.25,
                        children: [
                          for (final c in featured) _FeaturedTile(category: c),
                        ],
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SectionHeader(l10n.allCategories),
                          TextField(
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: l10n.searchAzkar,
                              prefixIcon: const Icon(LucideIcons.search),
                              isDense: true,
                              filled: true,
                              fillColor: colors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                                borderSide: BorderSide(color: colors.outline),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                                borderSide: BorderSide(color: colors.outline),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: others.length,
                    itemBuilder: (context, i) {
                      final c = others[i];
                      return ListTile(
                        leading: Icon(azkarIcon(c.key)),
                        title: Text(context.azkarTitle(c)),
                        trailing: Text(
                          context.digits(c.items.length),
                          style: TextStyle(color: colors.textMuted),
                        ),
                        onTap: () => _open(context, c),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: context.navBarClearance),
                  ),
                ],
              ),
            ),
    );
  }
}

void _open(BuildContext context, AzkarCategory c) => context.pushNamed(
  AppRoutes.azkarCategoryName,
  pathParameters: {'categoryId': '${c.id}'},
);

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({required this.category});
  final AzkarCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEvening = category.key == 'evening' || category.key == 'sleep';
    final tint = isEvening ? colors.accent : colors.primary;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context, category),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconBadge(azkarIcon(category.key), color: tint),
                  const Spacer(),
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
          ],
        ),
      ),
    );
  }
}
