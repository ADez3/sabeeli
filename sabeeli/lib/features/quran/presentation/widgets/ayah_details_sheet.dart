import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failure_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/pill_tabs.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/ayah_details_cubit.dart';
import '../cubit/quran_cubit.dart';
import 'quran_font.dart';
import 'reader_theme.dart';
import 'ayah_number.dart';
import 'surah_labels.dart';

Future<void> showAyahDetails(
  BuildContext context, {
  required QuranData data,
  required AyahRef ref,
}) {
  final quran = context.read<QuranCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: quran),
        BlocProvider(
          create: (_) => getIt<AyahDetailsCubit>()
            ..load(
              ref,
              preferredId: quran.state.preferences.translationId,
              languageCode: context.languageCode,
            ),
        ),
      ],
      child: _AyahDetailsSheet(data: data, ref: ref),
    ),
  );
}

class _AyahDetailsSheet extends StatefulWidget {
  const _AyahDetailsSheet({required this.data, required this.ref});

  final QuranData data;
  final AyahRef ref;

  @override
  State<_AyahDetailsSheet> createState() => _AyahDetailsSheetState();
}

class _AyahDetailsSheetState extends State<_AyahDetailsSheet> {
  /// 0: tafsir, 1: translation.
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final data = widget.data;
    final ref = widget.ref;
    final surah = data.surah(ref.surah);
    final prefs = context.select((QuranCubit c) => c.state.preferences);
    final bookmarked = context.select(
      (QuranCubit c) => c.state.isBookmarked(ref),
    );
    final details = context.watch<AyahDetailsCubit>().state;
    final ayahText = data.text(ref);
    // The ayah sits on a piece of the reader's own page.
    final page = prefs.theme
        .resolve(Theme.of(context).brightness)
        .applyTo(colors);
    final quranStyle = TextStyle(
      fontFamily: context.quranFont,
      fontSize: 24,
      height: 2.0,
      color: page.text,
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.66,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        // Clear of the system navigation bar, which the sheet slides over.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.digits(
                          l10n.surahAyah(context.surahName(surah), ref.ayah),
                        ),
                        style: text.titleLarge,
                      ),
                      Text(
                        '${context.digits(l10n.juzNumber(data.juzOf(ref)))} · '
                        '${context.digits(l10n.pageNumber(data.pageOf(ref)))}',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (context.languageCode != 'ar')
                  Text(
                    surah.nameArabic,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: AppFonts.display,
                      fontSize: 22,
                      color: colors.accent,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: page.mushafPage,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: colors.hairline),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: ayahText),
                  ayahNumberSpan(
                    context,
                    ayah: ref.ayah,
                    style: quranStyle,
                    color: page.primary,
                  ),
                ],
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: quranStyle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Action(
                icon: bookmarked
                    ? LucideIcons.bookmarkCheck
                    : LucideIcons.bookmark,
                label: bookmarked ? l10n.removeBookmark : l10n.bookmark,
                active: bookmarked,
                onTap: () {
                  context.read<QuranCubit>().toggleBookmark(ref);
                  _toast(
                    context,
                    bookmarked ? l10n.bookmarkRemoved : l10n.bookmarkAdded,
                  );
                },
              ),
              _Action(
                icon: LucideIcons.flag,
                label: l10n.setAsLastRead,
                onTap: () {
                  context.read<QuranCubit>().savePosition(ref);
                  _toast(context, l10n.lastReadSaved);
                },
              ),
              _Action(
                icon: LucideIcons.copy,
                label: l10n.copy,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          '$ayahText ﴿${context.digits(ref.ayah)}﴾\n'
                          '[${surah.nameArabic} ${ref.surah}:${ref.ayah}]',
                    ),
                  );
                  _toast(context, l10n.copied);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PillTabs(
            labels: [l10n.tafsir, l10n.translation],
            selected: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: Motion.component,
            switchInCurve: Motion.enter,
            child: _tab == 0
                ? Padding(
                    key: const ValueKey('tafsir'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.tafsirMuyassar,
                          style: text.labelMedium?.copyWith(
                            color: colors.accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        details.tafsir == null
                            ? const LinearProgressIndicator()
                            : Text(
                                details.tafsir!,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: AppFonts.ui,
                                  fontSize: 17,
                                  height: 1.9,
                                  color: colors.text,
                                ),
                              ),
                      ],
                    ),
                  )
                : _TranslationSection(
                    key: const ValueKey('translation'),
                    details: details,
                  ),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
}

/// A round action with its name under it.
class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = active ? colors.accent : colors.text;
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          Material(
            color: active
                ? colors.accent.withValues(alpha: 0.16)
                : colors.surfaceHigh,
            shape: CircleBorder(side: BorderSide(color: colors.hairline)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox.square(
                dimension: 52,
                child: Icon(icon, size: 20, color: tint),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _TranslationSection extends StatelessWidget {
  const _TranslationSection({super.key, required this.details});
  final AyahDetailsState details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<AyahDetailsCubit>();
    final edition = details.translation;

    final picker = PopupMenuButton<String>(
      tooltip: l10n.translationLanguage,
      icon: Icon(LucideIcons.languages, color: colors.textMuted, size: 20),
      onSelected: (id) {
        final chosen = id.isEmpty
            ? null
            : details.editions.firstWhere((e) => e.id == id);
        cubit.select(chosen);
        context.read<QuranCubit>().setTranslation(id.isEmpty ? null : id);
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: '', child: Text(l10n.noTranslation)),
        for (final e in details.editions)
          PopupMenuItem(
            value: e.id,
            child: Text(
              '${e.languageCode.toUpperCase()} · ${e.name}${e.isTafsir ? ' (${l10n.tafsir})' : ''}',
            ),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  edition == null ? l10n.translation : edition.name,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: colors.accent),
                ),
              ),
              picker,
            ],
          ),
          switch (edition) {
            null => Text(
              l10n.noTranslation,
              style: TextStyle(color: colors.textMuted),
            ),
            _ when details.downloading => Row(
              children: [
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(l10n.downloading),
              ],
            ),
            _ when details.translationMissing => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translationUnavailable,
                  style: TextStyle(color: colors.textMuted),
                ),
                if (details.failure != null)
                  Text(
                    failureText(l10n, details.failure!),
                    style: TextStyle(color: colors.danger),
                  ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: cubit.download,
                  icon: const Icon(LucideIcons.download),
                  label: Text(l10n.download),
                ),
              ],
            ),
            final e => Text(
              details.translationText ?? '',
              textDirection: e.isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(height: 1.7),
            ),
          },
        ],
      ),
    );
  }
}
