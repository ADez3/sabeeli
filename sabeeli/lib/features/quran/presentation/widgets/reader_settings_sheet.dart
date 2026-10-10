import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import 'quran_font.dart';
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
    final scale = context.select(
      (QuranCubit c) => c.state.preferences.fontScale,
    );
    final sample = context.select(
      (QuranCubit c) => c.state.data?.text(c.state.data!.fromHafs(_sampleAyah)),
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
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
              Text(
                l10n.riwayah,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const RiwayahPicker(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.fontSize,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  Icon(LucideIcons.minus, color: colors.textMuted),
                  Expanded(
                    child: Slider(
                      value: scale,
                      min: 0.8,
                      max: 1.8,
                      divisions: 10,
                      onChanged: context.read<QuranCubit>().setFontScale,
                    ),
                  ),
                  Icon(LucideIcons.plus, color: colors.textMuted),
                ],
              ),
              if (sample != null)
                Text(
                  sample,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: context.quranFont,
                    fontSize: 23 * scale,
                    height: 2.0,
                    color: colors.text,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
