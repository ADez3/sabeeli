import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failure_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/ayah_details_cubit.dart';
import '../cubit/quran_cubit.dart';
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

class _AyahDetailsSheet extends StatelessWidget {
  const _AyahDetailsSheet({required this.data, required this.ref});

  final QuranData data;
  final AyahRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final surah = data.surah(ref.surah);
    final bookmarked = context.select(
      (QuranCubit c) => c.state.isBookmarked(ref),
    );
    final details = context.watch<AyahDetailsCubit>().state;
    final ayahText = data.text(ref);
    final quranStyle = TextStyle(
      fontFamily: AppFonts.quran,
      fontSize: 25,
      height: 2.0,
      color: colors.text,
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.digits(
                    l10n.surahAyah(context.surahName(surah), ref.ayah),
                  ),
                  style: text.titleMedium,
                ),
              ),
              Text(
                '${context.digits(l10n.juzNumber(data.juzOf(ref)))} · ${context.digits(l10n.pageNumber(data.pageOf(ref)))}',
                style: text.labelMedium?.copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: ayahText),
                ayahNumberSpan(
                  context,
                  ayah: ref.ayah,
                  style: quranStyle,
                  color: colors.primary,
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: quranStyle,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ActionChip(
                avatar: Icon(
                  bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: bookmarked ? colors.accent : null,
                  size: 18,
                ),
                label: Text(bookmarked ? l10n.removeBookmark : l10n.bookmark),
                onPressed: () {
                  context.read<QuranCubit>().toggleBookmark(ref);
                  _toast(
                    context,
                    bookmarked ? l10n.bookmarkRemoved : l10n.bookmarkAdded,
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.flag_outlined, size: 18),
                label: Text(l10n.setAsLastRead),
                onPressed: () {
                  context.read<QuranCubit>().savePosition(ref);
                  _toast(context, l10n.lastReadSaved);
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l10n.copy),
                onPressed: () {
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
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: l10n.tafsirMuyassar,
            child: details.tafsir == null
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
          ),
          const SizedBox(height: AppSpacing.lg),
          _TranslationSection(details: details),
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 3, height: 16, color: colors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: colors.accent),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _TranslationSection extends StatelessWidget {
  const _TranslationSection({required this.details});
  final AyahDetailsState details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<AyahDetailsCubit>();
    final edition = details.translation;

    final picker = PopupMenuButton<String>(
      tooltip: l10n.translationLanguage,
      icon: Icon(Icons.translate_rounded, color: colors.textMuted, size: 20),
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

    return _Section(
      title: edition == null ? l10n.translation : edition.name,
      trailing: picker,
      child: switch (edition) {
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
              icon: const Icon(Icons.download_rounded),
              label: Text(l10n.download),
            ),
          ],
        ),
        final e => Text(
          details.translationText ?? '',
          textDirection: e.isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
        ),
      },
    );
  }
}
