import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
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
    setState(() => _page = index + 1);
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<QuranCubit>().state;
    final data = state.data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _initController(data);

    final firstAyah = data.ayahsOnPage(_page).first;
    final surah = data.surah(firstAyah.surah);
    final wide = context.windowSize != WindowSize.compact;

    return Scaffold(
      backgroundColor: colors.mushafPage,
      appBar: AppBar(
        backgroundColor: colors.mushafPage,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.surahName(surah)),
            Text(
              '${context.digits(l10n.juzNumber(data.juzOf(firstAyah)))} · ${context.digits(l10n.pageNumber(_page))}',
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colors.textMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.readerSettings,
            icon: const Icon(LucideIcons.aLargeSmall),
            onPressed: () => showReaderSettings(context),
          ),
        ],
      ),
      // The mushaf turns right-to-left whatever the UI language.
      body: Directionality(
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
    );
  }
}
