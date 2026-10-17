import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/motion.dart';
import '../widgets/reader_theme.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import '../widgets/ayah_details_sheet.dart';
import '../widgets/mushaf_page.dart';
import '../widgets/reader_settings_sheet.dart';
import '../widgets/surah_labels.dart';

/// The mushaf, page by page. Opened either at a page or at an ayah (which is then
/// highlighted), from the index, a bookmark, "continue reading" or a deep link.
class QuranReaderPage extends StatefulWidget {
  const QuranReaderPage({
    super.key,
    this.page,
    this.ayah,
    this.highlight = true,
  });

  final int? page;

  /// In Hafs numbering, as in every link; shown in the riwayah being read.
  final AyahRef? ayah;
  final bool highlight;

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  PageController? _controller;
  int _page = 1;
  AyahRef? _selected;
  Timer? _saveDebounce;

  /// The title bar and page details; they step aside while reading.
  bool _chrome = true;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
  }

  void _initController(QuranData data) {
    if (_controller != null) return;
    final hafs = widget.ayah;
    final ayah = hafs == null ? null : data.fromHafs(hafs);
    if (widget.highlight) _selected = ayah;
    _page = (ayah != null ? data.pageOf(ayah) : widget.page ?? 1).clamp(
      1,
      QuranData.pageCount,
    );
    _controller = PageController(initialPage: _page - 1);
    _scheduleSave(data);
  }

  void _onPageChanged(QuranData data, int index) {
    setState(() {
      _page = index + 1;
      _chrome = false;
    });
    _scheduleSave(data);
  }

  /// Saves the page the reader settles on, not every page flicked past.
  void _scheduleSave(QuranData data) {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final ayahs = data.ayahsOnPage(_page);
      final selected = _selected;
      final ref = selected != null && ayahs.contains(selected)
          ? selected
          : ayahs.first;
      context.read<QuranCubit>().savePosition(ref, page: _page);
    });
  }

  Future<void> _openAyah(QuranData data, AyahRef ref) async {
    setState(() => _selected = ref);
    await showAyahDetails(context, data: data, ref: ref);
    if (mounted) setState(() => _selected = null);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// Share of the current juz read up to this page, 0…1.
  static double _juzProgress(QuranData data, int page, int juz) {
    final first = data.pageOf(data.juzStarts[juz - 1]);
    final last = juz < 30
        ? data.pageOf(data.juzStarts[juz]) - 1
        : QuranData.pageCount;
    if (last <= first) return 1;
    return ((page - first) / (last - first)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appColors = context.colors;
    final state = context.watch<QuranCubit>().state;
    final data = state.data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _initController(data);

    // The page has its own colours (night, sepia, paper), whatever the app's.
    final pageTheme = state.preferences.theme.resolve(
      Theme.of(context).brightness,
    );
    final colors = pageTheme.applyTo(appColors);
    final theme = Theme.of(context);

    final firstAyah = data.ayahsOnPage(_page).first;
    final surah = data.surah(firstAyah.surah);
    final juz = data.juzOf(firstAyah);
    final wide = context.windowSize != WindowSize.compact;
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final text = theme.textTheme;

    return Theme(
      data: theme.copyWith(
        extensions: [colors],
        scaffoldBackgroundColor: colors.mushafPage,
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            (pageTheme.brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark)
                .copyWith(statusBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: colors.mushafPage,
          body: Stack(
            children: [
              // The mushaf turns right-to-left whatever the UI language. A tap
              // outside an ayah brings the title bar back.
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setState(() => _chrome = !_chrome),
                child: Padding(
                  padding: EdgeInsets.only(top: top + 56, bottom: bottom + 8),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: QuranData.pageCount,
                      onPageChanged: (i) => _onPageChanged(data, i),
                      itemBuilder: (context, index) => ContentWidth(
                        maxWidth: wide ? 760 : double.infinity,
                        child: MushafPage(
                          data: data,
                          page: index + 1,
                          fontScale: state.preferences.fontScale,
                          selected: _selected,
                          bookmarks: {for (final b in state.bookmarks) b.ref},
                          onAyahTap: (ref) => _openAyah(data, ref),
                          pageLabel: context.digits(index + 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Title bar: frosted, sliding away while reading.
              AnimatedPositioned(
                duration: Motion.component,
                curve: Motion.enter,
                top: _chrome ? 0 : -(top + 64),
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      color: colors.mushafPage.withValues(alpha: 0.82),
                      padding: EdgeInsets.only(top: top),
                      height: top + 56,
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: MaterialLocalizations.of(context)
                                .backButtonTooltip,
                            icon: Icon(context.backArrow, color: colors.text),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.surahName(surah),
                                  style: text.titleMedium?.copyWith(
                                    color: colors.text,
                                  ),
                                ),
                                Text(
                                  '${context.digits(l10n.juzNumber(juz))} · '
                                  '${context.digits(l10n.pageNumber(_page))}',
                                  style: text.labelMedium?.copyWith(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // In Arabic the title already is the Arabic name.
                          if (!context.readsArabicScript)
                            Text(
                              surah.nameArabic,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: AppFonts.display,
                                fontSize: 20,
                                color: colors.accent,
                              ),
                            ),
                          IconButton(
                            tooltip: l10n.readerSettings,
                            icon: Icon(
                              LucideIcons.aLargeSmall,
                              color: colors.text,
                            ),
                            onPressed: () => showReaderSettings(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Where the reader is in the juz: a thin line along the bottom,
              // filling from the right like the pages.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: _juzProgress(data, _page, juz)),
                    duration: Motion.component,
                    curve: Motion.enter,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 2,
                      color: colors.accent.withValues(alpha: 0.8),
                      backgroundColor: colors.text.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
