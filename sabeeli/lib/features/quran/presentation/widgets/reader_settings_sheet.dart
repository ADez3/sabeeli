import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/motion.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import 'quran_font.dart';
import 'reader_theme.dart';
import 'riwayah_picker.dart';

/// Al-Fatihah 1:2 (Hafs numbering), a short line to preview the size on.
const _sampleAyah = AyahRef(1, 2);

Future<void> showReaderSettings(BuildContext context) {
  final cubit = context.read<QuranCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        BlocProvider.value(value: cubit, child: const _ReaderSettings()),
  );
}

class _ReaderSettings extends StatelessWidget {
  const _ReaderSettings();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final cubit = context.read<QuranCubit>();
    final prefs = context.select((QuranCubit c) => c.state.preferences);
    final sample = context.select(
      (QuranCubit c) => c.state.data?.text(c.state.data!.fromHafs(_sampleAyah)),
    );
    final page = prefs.theme
        .resolve(Theme.of(context).brightness)
        .applyTo(colors);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // A live preview: the page colour, the size and the riwayah's font.
            AnimatedContainer(
              duration: Motion.component,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: page.mushafPage,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: colors.hairline),
              ),
              child: Text(
                sample ?? '',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: context.quranFont,
                  fontSize: 23 * prefs.fontScale,
                  height: 2.0,
                  color: page.text,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.pageColour, style: text.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (final t in ReaderTheme.values)
                  Expanded(
                    child: _Swatch(
                      theme: t,
                      selected: prefs.theme == t,
                      onTap: () => cubit.setReaderTheme(t),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.fontSize, style: text.titleSmall),
            Row(
              children: [
                Icon(LucideIcons.aArrowDown, color: colors.textMuted, size: 20),
                Expanded(
                  child: Slider(
                    value: prefs.fontScale,
                    min: 0.8,
                    max: 1.8,
                    divisions: 10,
                    onChanged: cubit.setFontScale,
                  ),
                ),
                Icon(LucideIcons.aArrowUp, color: colors.textMuted, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.riwayah, style: text.titleSmall),
            const RiwayahPicker(),
          ],
        ),
      ),
    );
  }
}

/// A page colour to pick: a small rounded page in that colour with "Aa".
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final ReaderTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final label = switch (theme) {
      ReaderTheme.auto => l10n.pageAuto,
      ReaderTheme.night => l10n.pageNight,
      ReaderTheme.sepia => l10n.pageSepia,
      ReaderTheme.paper => l10n.pagePaper,
    };
    // "Auto" shows half night, half paper.
    final night = ReaderTheme.night.applyTo(colors);
    final paper = ReaderTheme.paper.applyTo(colors);
    final own = theme.applyTo(colors);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: Motion.micro,
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: theme == ReaderTheme.auto
                    ? LinearGradient(
                        colors: [night.mushafPage, paper.mushafPage],
                        stops: const [0.5, 0.5],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: theme == ReaderTheme.auto ? null : own.mushafPage,
                border: Border.all(
                  color: selected ? colors.primary : colors.outline,
                  width: selected ? 2.5 : 1,
                ),
              ),
              alignment: Alignment.center,
              child: theme == ReaderTheme.auto
                  ? null
                  : Text('Aa', style: TextStyle(color: own.text, fontSize: 15)),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? colors.primary : colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
