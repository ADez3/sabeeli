import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/quran_ornaments.dart';
import '../widgets/surah_labels.dart';

class QuranIndexPage extends StatefulWidget {
  const QuranIndexPage({super.key});

  @override
  State<QuranIndexPage> createState() => _QuranIndexPageState();
}

class _QuranIndexPageState extends State<QuranIndexPage> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<QuranCubit>().state;
    final data = state.data;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.quran),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.surahs),
              Tab(text: l10n.juzs),
              Tab(text: l10n.bookmarks),
            ],
          ),
        ),
        body: data == null
            ? const Center(child: CircularProgressIndicator())
            : ContentWidth(
                child: TabBarView(
                  children: [
                    _SurahList(
                      data: data,
                      query: _query,
                      onQuery: (q) => setState(() => _query = q),
                    ),
                    _JuzList(data: data),
                    _BookmarkList(data: data, bookmarks: state.bookmarks),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Opens the reader on [ref]'s page with that ayah highlighted.
void openAyah(BuildContext context, AyahRef ref) => context.pushNamed(
  AppRoutes.quranSurahName,
  pathParameters: {'surah': '${ref.surah}'},
  queryParameters: {'ayah': '${ref.ayah}'},
);

void _openSurah(BuildContext context, int surah) => context.pushNamed(
  AppRoutes.quranSurahName,
  pathParameters: {'surah': '$surah'},
);

void _openPage(BuildContext context, int page) => context.pushNamed(
  AppRoutes.quranPageName,
  pathParameters: {'page': '$page'},
);

class _SurahList extends StatelessWidget {
  const _SurahList({
    required this.data,
    required this.query,
    required this.onQuery,
  });

  final QuranData data;
  final String query;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final q = query.trim().toLowerCase();
    final surahs = q.isEmpty
        ? data.surahs
        : data.surahs
              .where(
                (s) =>
                    '${s.number}' == q ||
                    s.nameArabic.contains(q) ||
                    s.nameTransliterated.toLowerCase().contains(q) ||
                    s.nameEnglish.toLowerCase().contains(q),
              )
              .toList();

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          sliver: SliverToBoxAdapter(child: ContinueReadingCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: TextField(
              onChanged: onQuery,
              decoration: InputDecoration(
                hintText: l10n.searchSurah,
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(color: colors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(color: colors.outline),
                ),
              ),
            ),
          ),
        ),
        SliverList.separated(
          itemCount: surahs.length,
          separatorBuilder: (_, _) =>
              const Divider(indent: 72, endIndent: AppSpacing.lg),
          itemBuilder: (context, i) => _SurahTile(surah: surahs[i]),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.surah});
  final SurahInfo surah;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final isArabicUi = context.languageCode == 'ar';
    return InkWell(
      onTap: () => _openSurah(context, surah.number),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            StarNumber(context.digits(surah.number)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.surahName(surah), style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    context.surahSubtitle(surah),
                    style: text.bodySmall?.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
            if (!isArabicUi)
              Text(
                surah.nameArabic,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 22,
                  color: colors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JuzList extends StatelessWidget {
  const _JuzList({required this.data});
  final QuranData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: data.juzStarts.length,
      separatorBuilder: (_, _) =>
          const Divider(indent: 72, endIndent: AppSpacing.lg),
      itemBuilder: (context, i) {
        final start = data.juzStarts[i];
        final surah = data.surah(start.surah);
        final preview = data.text(start);
        return InkWell(
          onTap: () => _openPage(context, data.pageOf(start)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                StarNumber(context.digits(i + 1)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.digits(l10n.juzNumber(i + 1)),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${context.digits(l10n.surahAyah(context.surahName(surah), start.ayah))} · ${context.digits(l10n.pageNumber(data.pageOf(start)))}',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: AppFonts.quran,
                          fontSize: 17,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BookmarkList extends StatelessWidget {
  const _BookmarkList({required this.data, required this.bookmarks});
  final QuranData data;
  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    if (bookmarks.isEmpty) {
      return MessageView(
        icon: Icons.bookmark_border_rounded,
        message: l10n.noBookmarks,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookmarks.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final b = bookmarks[i];
        final surah = data.surah(b.ref.surah);
        return AppCard(
          onTap: () => openAyah(context, b.ref),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark_rounded, color: colors.accent, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.digits(
                        l10n.surahAyah(context.surahName(surah), b.ref.ayah),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.removeBookmark,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () =>
                        context.read<QuranCubit>().toggleBookmark(b.ref),
                  ),
                ],
              ),
              Text(
                data.text(b.ref),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppFonts.quran,
                  fontSize: 20,
                  height: 1.8,
                  color: colors.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
