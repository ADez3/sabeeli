import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/riwayah.dart';
import '../cubit/quran_cubit.dart';

extension RiwayahLabels on AppLocalizations {
  String riwayahName(Riwayah r) => switch (r) {
    Riwayah.hafs => riwayahHafs,
    Riwayah.warsh => riwayahWarsh,
    Riwayah.qalun => riwayahQalun,
  };

  String riwayahWhere(Riwayah r) => switch (r) {
    Riwayah.hafs => riwayahHafsHint,
    Riwayah.warsh => riwayahWarshHint,
    Riwayah.qalun => riwayahQalunHint,
  };
}

/// The riwayah to read in: automatic (by region) or a fixed choice. Each
/// option shows its Arabic name in calligraphy and where it is read.
class RiwayahPicker extends StatelessWidget {
  const RiwayahPicker({super.key});

  static const _arabicNames = {
    Riwayah.hafs: 'حفص عن عاصم',
    Riwayah.warsh: 'ورش عن نافع',
    Riwayah.qalun: 'قالون عن نافع',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<QuranCubit>();
    final chosen = context.select(
      (QuranCubit c) => c.state.preferences.riwayah,
    );
    // Rebuild when the region-resolved riwayah changes too.
    context.select((QuranCubit c) => c.state.data?.riwayah);
    final automatic = cubit.riwayah;

    Widget arabic(Riwayah r) => Text(
      _arabicNames[r]!,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: 18,
        color: colors.accent,
      ),
    );

    return RadioGroup<Riwayah?>(
      groupValue: chosen,
      onChanged: cubit.setRiwayah,
      child: Column(
        children: [
          RadioListTile<Riwayah?>(
            value: null,
            title: Text(l10n.riwayahAuto),
            subtitle: Text(l10n.riwayahName(automatic)),
            secondary: arabic(automatic),
          ),
          for (final r in Riwayah.values)
            RadioListTile<Riwayah?>(
              value: r,
              title: Text(l10n.riwayahName(r)),
              subtitle: Text(l10n.riwayahWhere(r)),
              secondary: arabic(r),
            ),
        ],
      ),
    );
  }
}
