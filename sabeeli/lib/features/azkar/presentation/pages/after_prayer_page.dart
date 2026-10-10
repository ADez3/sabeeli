import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rolling_digits.dart';
import '../../../../l10n/l10n.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../prayer_times/presentation/widgets/prayer_labels.dart';
import '../../../quran/domain/entities/quran_entities.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/ayah_number.dart';
import '../../../tasbih/presentation/widgets/misbaha.dart';
import '../../domain/entities/after_prayer.dart';
import '../cubit/after_prayer_cubit.dart';
import '../../../quran/presentation/widgets/quran_font.dart';

/// The adhkar after the salam, one step at a time: repeated adhkar are counted on
/// the misbaha, the rest are read and confirmed with a tap.
class AfterPrayerPage extends StatelessWidget {
  const AfterPrayerPage({super.key, this.prayer});

  /// Null: the prayer whose time most recently began.
  final Prayer? prayer;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AfterPrayerCubit>()
      ..load(
        prayer ??
            context.read<PrayerTimesCubit>().state.lastPrayerAt(DateTime.now()),
      ),
    child: const _AfterPrayerView(),
  );
}

class _AfterPrayerView extends StatefulWidget {
  const _AfterPrayerView();

  @override
  State<_AfterPrayerView> createState() => _AfterPrayerViewState();
}

class _AfterPrayerViewState extends State<_AfterPrayerView> {
  bool _translation = false;

  @override
  void initState() {
    super.initState();
    // Ayat al-Kursi and the Quls are read from the mushaf text.
    context.read<QuranCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.watch<AfterPrayerCubit>().state;
    final cubit = context.read<AfterPrayerCubit>();

    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      icon: const Icon(LucideIcons.x),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        l10n.afterPrayerOf(l10n.prayerName(s.prayer)),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (context.languageCode != 'ar')
                      IconButton(
                        tooltip: l10n.showTranslation,
                        isSelected: _translation,
                        icon: const Icon(LucideIcons.languages),
                        onPressed: () =>
                            setState(() => _translation = !_translation),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
              if (s.loaded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xs,
                    AppSpacing.xl,
                    0,
                  ),
                  child: _StepsProgress(state: s, onTap: cubit.goTo),
                ),
              Expanded(
                child: !s.loaded
                    ? const SizedBox.shrink()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 480),
                        switchInCurve: const Cubic(0.05, 0.7, 0.1, 1),
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, a) => FadeTransition(
                          opacity: a,
                          child: SlideTransition(
                            position: Tween(
                              begin: const Offset(0, 0.04),
                              end: Offset.zero,
                            ).animate(a),
                            child: child,
                          ),
                        ),
                        child: s.finished
                            ? _Finished(
                                key: const ValueKey('done'),
                                state: s,
                                onRestart: cubit.restart,
                              )
                            : _StepView(
                                key: ValueKey(s.index),
                                state: s,
                                translation: _translation,
                                onCount: cubit.count,
                              ),
                      ),
              ),
              if (s.loaded && !s.finished)
                _StepNav(
                  onPrevious: s.index > 0
                      ? () => cubit.goTo(s.index - 1)
                      : null,
                  onSkip: () => cubit.goTo(s.index + 1),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One thin segment per step, filling as each is said.
class _StepsProgress extends StatelessWidget {
  const _StepsProgress({required this.state, required this.onTap});

  final AfterPrayerState state;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        for (var i = 0; i < state.steps.length; i++)
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: AppSpacing.sm,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      end: i < state.index
                          ? 1
                          : i == state.index && state.target > 0
                          ? state.counted / state.target
                          : 0,
                    ),
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 3,
                      color: colors.primary,
                      backgroundColor: colors.text.withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({
    super.key,
    required this.state,
    required this.translation,
    required this.onCount,
  });

  final AfterPrayerState state;
  final bool translation;
  final VoidCallback onCount;

  @override
  Widget build(BuildContext context) {
    final step = state.step!;
    // Up to a full string of beads is counted on the misbaha; single adhkar and
    // the Quran passages are read and then confirmed.
    if (!step.isQuran && state.target > 1) {
      return _CountedStep(
        state: state,
        translation: translation,
        onCount: onCount,
      );
    }
    return _ReadStep(state: state, translation: translation, onDone: onCount);
  }
}

class _CountedStep extends StatelessWidget {
  const _CountedStep({
    required this.state,
    required this.translation,
    required this.onCount,
  });

  final AfterPrayerState state;
  final bool translation;
  final VoidCallback onCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final step = state.step!;
    final long = step.arabic!.length > 40;
    return Column(
      children: [
        if (long)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              0,
            ),
            child: _DhikrText(step: step, size: 22),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Misbaha(
              onCount: onCount,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!long) _DhikrText(step: step, size: 30),
                  RollingDigits(
                    context.digits(state.left),
                    style: text.displayLarge!.copyWith(color: colors.text),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (translation) _Translation(step: step),
        Text(
          context.l10n.turnTheBeads,
          style: text.labelMedium?.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }
}

class _ReadStep extends StatelessWidget {
  const _ReadStep({
    required this.state,
    required this.translation,
    required this.onDone,
  });

  final AfterPrayerState state;
  final bool translation;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final step = state.step!;
    final data = context.select((QuranCubit c) => c.state.data);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  if (step.isQuran)
                    data == null
                        ? const SizedBox.shrink()
                        : _QuranPassage(step: step, data: data)
                  else
                    _DhikrText(step: step, size: 25),
                  if (translation) _Translation(step: step),
                  if (step.virtue != null) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      step.virtue!,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: text.bodyMedium?.copyWith(
                        color: colors.accent,
                        height: 1.8,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _DoneButton(
            label: state.target > 1
                ? context.digits(l10n.progressOf(state.counted, state.target))
                : l10n.doneStep,
            progress: state.target > 1 ? state.counted / state.target : null,
            onPressed: onDone,
          ),
        ),
      ],
    );
  }
}

class _DhikrText extends StatelessWidget {
  const _DhikrText({required this.step, required this.size});

  final AfterPrayerStep step;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
    step.arabic!,
    textAlign: TextAlign.center,
    textDirection: TextDirection.rtl,
    style: TextStyle(
      fontFamily: AppFonts.display,
      fontSize: size,
      height: 1.9,
      color: context.colors.text,
    ),
  );
}

/// Ayat al-Kursi or a Qul, from the mushaf text in the Quran font.
class _QuranPassage extends StatelessWidget {
  const _QuranPassage({required this.step, required this.data});

  final AfterPrayerStep step;
  final QuranData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // The step names the passage in Hafs numbering; read it in the riwayah
    // being read (Ayat al-Kursi is Warsh 2:253–254).
    final refs = data.fromHafsRange(step.quranFrom!, step.quranTo!);
    final from = refs.first;
    final style = TextStyle(
      fontFamily: context.quranFont,
      fontSize: 25,
      height: 2.1,
      color: colors.text,
    );
    final surah = data.surah(from.surah);
    return Column(
      children: [
        Text(
          surah.nameArabic,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppFonts.display,
            fontSize: 18,
            color: colors.accent,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // A whole surah opens with its basmala, as in the mushaf.
        if (from.ayah == 1 && data.hasBasmalaHeader(surah.number))
          Text(
            data.basmala,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: style.copyWith(fontSize: 22),
          ),
        Text.rich(
          TextSpan(
            children: [
              for (final r in refs) ...[
                TextSpan(text: data.text(r)),
                ayahNumberSpan(
                  context,
                  ayah: r.ayah,
                  style: style,
                  color: colors.primary,
                ),
              ],
            ],
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: style,
        ),
      ],
    );
  }
}

class _Translation extends StatelessWidget {
  const _Translation({required this.step});

  final AfterPrayerStep step;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          if (step.transliteration != null)
            Text(
              step.transliteration!,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: text.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colors.text,
              ),
            ),
          if (step.translation != null)
            Text(
              step.translation!,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: text.bodySmall?.copyWith(
                color: colors.textMuted,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

/// A pill that fills as the repetitions of a read step are confirmed.
class _DoneButton extends StatelessWidget {
  const _DoneButton({
    required this.label,
    required this.onPressed,
    this.progress,
  });

  final String label;
  final double? progress;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 220,
      height: 56,
      child: Material(
        color: colors.primary.withValues(alpha: 0.14),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (progress != null)
                FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: progress,
                  child: ColoredBox(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.check, size: 20, color: colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepNav extends StatelessWidget {
  const _StepNav({required this.onPrevious, required this.onSkip});

  final VoidCallback? onPrevious;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.colors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onPrevious,
            style: TextButton.styleFrom(foregroundColor: muted),
            child: Text(l10n.previousStep),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(foregroundColor: muted),
            child: Text(l10n.skipStep),
          ),
        ],
      ),
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({super.key, required this.state, required this.onRestart});

  final AfterPrayerState state;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, t, child) => Opacity(
                opacity: t,
                child: Transform.scale(scale: 0.8 + 0.2 * t, child: child),
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.accent.withValues(alpha: 0.55),
                      colors.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Icon(LucideIcons.heart, size: 40, color: colors.accent),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.azkarDone,
              textAlign: TextAlign.center,
              style: text.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.digits(l10n.remembrances(state.totalRepetitions)),
              style: text.bodyMedium?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: () => context.pop(),
              child: Text(l10n.doneStep),
            ),
            TextButton(onPressed: onRestart, child: Text(l10n.restart)),
          ],
        ),
      ),
    );
  }
}
