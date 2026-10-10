import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/quran_ornaments.dart';
import '../widgets/quran_sky/quran_sky.dart';
import '../widgets/surah_labels.dart';

/// The Quran tab: a night sky of the 114 surahs by default, or the classic lists.
class QuranIndexPage extends StatefulWidget {
  const QuranIndexPage({super.key});

  @override
  State<QuranIndexPage> createState() => _QuranIndexPageState();
}

class _QuranIndexPageState extends State<QuranIndexPage> {
  String _query = '';
  bool _sky = true;
  int? _selected;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
  }

  void _setMode(bool sky) {
    if (sky == _sky) return;
    HapticFeedback.selectionClick();
    setState(() => _sky = sky);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuranCubit>().state;
    final data = state.data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _sky
          ? _skyMode(context, state, data)
          : _listMode(context, state, data),
    );
  }

  Widget _skyMode(BuildContext context, QuranState state, QuranData data) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final percent = (state.readPages.length / QuranData.pageCount * 100)
        .floor();
    final selected = _selected;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      key: const ValueKey('sky'),
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF04050D),
        body: Stack(
          children: [
            Positioned.fill(
              child: QuranSky(
                data: data,
                readPages: state.readPages,
                current: state.position?.ref.surah,
                selected: selected,
                onSelected: (s) => setState(() => _selected = s),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.quran,
                            style: text.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _ModeToggle(sky: true, onChanged: _setMode),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.digits(l10n.khatmahProgress(percent)),
                      style: text.bodyMedium?.copyWith(
                        color: const Color(0xFFF4B860),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.skyHint,
                      style: text.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: context.navBarClearance - AppSpacing.md,
              child: ContentWidth(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, a) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(a),
                      child: child,
                    ),
                  ),
                  child: selected == null
                      ? _GlassContinue(
                          key: const ValueKey('continue'),
                          state: state,
                          data: data,
                        )
                      : _SurahPreview(
                          key: ValueKey(selected),
                          surah: data.surah(selected),
                          progress: data.surahProgress(
                            selected,
                            state.readPages,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listMode(BuildContext context, QuranState state, QuranData data) {
    final l10n = context.l10n;
    return DefaultTabController(
      key: const ValueKey('list'),
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.quran),
          actions: [
            _ModeToggle(sky: false, onChanged: _setMode),
            const SizedBox(width: AppSpacing.md),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.surahs),
              Tab(text: l10n.juzs),
              Tab(text: l10n.bookmarks),
            ],
          ),
        ),
        body: ContentWidth(
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

/// Sky / List switch: two icons in a small pill.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.sky, required this.onChanged});

  final bool sky;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onSky = sky;
    final fg = onSky ? Colors.white : context.colors.text;
    Widget option(bool value, IconData icon, String label) {
      final active = value == sky;
      return Tooltip(
        message: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active ? fg.withValues(alpha: 0.16) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 18,
              color: active ? fg : fg.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        option(true, LucideIcons.sparkles, l10n.skyView),
        option(false, LucideIcons.listOrdered, l10n.listView),
      ],
    );
    return onSky
        ? GlassPanel(radius: 20, padding: const EdgeInsets.all(3), child: row)
        : DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.colors.outline),
            ),
            child: Padding(padding: const EdgeInsets.all(3), child: row),
          );
  }
}

class _GlassContinue extends StatelessWidget {
  const _GlassContinue({super.key, required this.state, required this.data});

  final QuranState state;
  final QuranData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final position = state.position;
    final surah = data.surah(position?.ref.surah ?? 1);
    return GlassPanel(
      onTap: () => context.pushNamed(
        AppRoutes.quranPageName,
        pathParameters: {'page': '${position?.page ?? 1}'},
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.bookOpenText, color: Colors.white, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position == null ? l10n.startReading : l10n.continueReading,
                  style: text.titleSmall?.copyWith(color: Colors.white),
                ),
                if (position != null)
                  Text(
                    context.digits(
                      l10n.surahAyah(
                        context.surahName(surah),
                        position.ref.ayah,
                      ),
                    ),
                    style: text.bodySmall?.copyWith(color: Colors.white70),
                  ),
              ],
            ),
          ),
          Text(
            surah.nameArabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: AppFonts.display,
              fontSize: 20,
              color: Color(0xFFF4B860),
            ),
          ),
        ],
      ),
    );
  }
}

/// The selected star: its surah at a glance, and the way in.
class _SurahPreview extends StatelessWidget {
  const _SurahPreview({super.key, required this.surah, required this.progress});

  final SurahInfo surah;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    void open() => context.pushNamed(
      AppRoutes.quranIntroName,
      pathParameters: {'surah': '${surah.number}'},
    );
    return GlassPanel(
      onTap: open,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.surahName(surah),
                      style: text.titleMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      context.surahSubtitle(surah),
                      style: text.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Text(
                surah.nameArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: AppFonts.display,
                  fontSize: 26,
                  color: Color(0xFFF4B860),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    color: const Color(0xFFF4B860),
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                context.digits(l10n.surahProgress((progress * 100).floor())),
                style: text.labelSmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                l10n.openSurah,
                style: text.labelLarge?.copyWith(color: Colors.white),
              ),
              Icon(
                context.isRtl
                    ? LucideIcons.chevronLeft
                    : LucideIcons.chevronRight,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ],
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
                prefixIcon: const Icon(LucideIcons.search),
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
        SliverToBoxAdapter(child: SizedBox(height: context.navBarClearance)),
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
            NumberBadge(context.digits(surah.number)),
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
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: context.navBarClearance,
      ),
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
                NumberBadge(context.digits(i + 1)),
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
      return MessageView(icon: LucideIcons.bookmark, message: l10n.noBookmarks);
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        context.navBarClearance,
      ),
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
                  Icon(
                    LucideIcons.bookmarkCheck,
                    color: colors.accent,
                    size: 20,
                  ),
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
                    icon: const Icon(LucideIcons.x, size: 18),
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
