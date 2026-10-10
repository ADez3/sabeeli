import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/riwayah.dart';
import '../cubit/quran_cubit.dart';

extension QuranFontX on BuildContext {
  /// The font of the riwayah being read: each mushaf's text is encoded for its
  /// own King Fahd Complex font, so the two always go together. A plain read:
  /// every screen showing Quran text already rebuilds when the mushaf changes.
  String get quranFont =>
      (read<QuranCubit>().state.data?.riwayah ?? Riwayah.hafs).fontFamily;
}
