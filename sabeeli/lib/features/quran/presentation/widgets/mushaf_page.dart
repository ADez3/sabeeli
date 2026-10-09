import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/quran_entities.dart';
import 'ayah_number.dart';
import 'quran_ornaments.dart';

/// One page of the Madani mushaf, laid out as flowing text.
///
/// The text is the KFGQPC Hafs encoding rendered with its own font, unaltered. The
/// end-of-ayah ornament is produced by the font itself: a no-break space followed
/// by the ayah number in Arabic-Indic digits is ligated into the numbered circle.
class MushafPage extends StatefulWidget {
  const MushafPage({
    super.key,
    required this.data,
    required this.page,
    required this.fontScale,
    required this.selected,
    required this.bookmarks,
    required this.onAyahTap,
    required this.pageLabel,
  });

  final QuranData data;
  final int page;
  final double fontScale;
  final AyahRef? selected;
  final Set<AyahRef> bookmarks;
  final ValueChanged<AyahRef> onAyahTap;
  final String pageLabel;

  @override
  State<MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  final Map<AyahRef, TapGestureRecognizer> _recognizers = {};

  TapGestureRecognizer _recognizerFor(AyahRef ref) => _recognizers.putIfAbsent(
    ref,
    () => TapGestureRecognizer()..onTap = () => widget.onAyahTap(ref),
  );

  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final data = widget.data;
    final ayahs = data.ayahsOnPage(widget.page);
    final baseSize = context.windowSize == WindowSize.compact ? 23.0 : 28.0;
    final fontSize = baseSize * widget.fontScale;

    final quranStyle = TextStyle(
      fontFamily: AppFonts.quran,
      fontSize: fontSize,
      height: 2.05,
      color: colors.text,
    );

    // Group the page's ayahs by surah: a surah that starts here gets its banner.
    final groups = <List<AyahRef>>[];
    for (final ref in ayahs) {
      if (groups.isEmpty || groups.last.first.surah != ref.surah) {
        groups.add([ref]);
      } else {
        groups.last.add(ref);
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        for (final group in groups) ...[
          if (group.first.ayah == 1) ...[
            SurahBanner(nameArabic: data.surah(group.first.surah).nameArabic),
            if (data.surah(group.first.surah).hasBasmalaHeader)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  // Al-Fatihah 1:1 is the basmala; reused so it is the same text and font.
                  data.text(const AyahRef(1, 1)),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: quranStyle.copyWith(fontSize: fontSize * 0.95),
                ),
              ),
          ],
          Text.rich(
            TextSpan(
              children: [
                for (final ref in group) _ayahSpan(ref, quranStyle, colors),
              ],
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            widget.pageLabel,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: colors.textMuted),
          ),
        ),
      ],
    );
  }

  TextSpan _ayahSpan(AyahRef ref, TextStyle style, AppColors colors) {
    final selected = widget.selected == ref;
    final bookmarked = widget.bookmarks.contains(ref);
    final background = selected ? colors.ayahHighlight : null;
    // Recognizers only fire on the leaf span that was hit, so each leaf gets one.
    final recognizer = _recognizerFor(ref);
    return TextSpan(
      children: [
        TextSpan(
          text: widget.data.text(ref),
          recognizer: recognizer,
          style: style.copyWith(backgroundColor: background),
        ),
        ayahNumberSpan(
          context,
          ayah: ref.ayah,
          style: style,
          color: bookmarked ? colors.accent : colors.primary,
          background: background,
          recognizer: recognizer,
          onTap: () => widget.onAyahTap(ref),
        ),
      ],
    );
  }
}
