import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/geometric_pattern.dart';
import '../../../../l10n/l10n.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../hijri/presentation/widgets/hijri_labels.dart';
import '../cubit/prayer_times_cubit.dart';
import 'prayer_labels.dart';

/// The hero of the app: the next prayer, a live countdown, and how much of the
/// current prayer window has passed, over a gradient and a faint star lattice.
class NextPrayerCard extends StatefulWidget {
  const NextPrayerCard({super.key, this.showDate = true, this.onTap});

  final bool showDate;
  final VoidCallback? onTap;

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final today = context.read<PrayerTimesCubit>().state.today?.date;
      setState(() => _now = now);
      // Past midnight "today" is yesterday; AppSync normally handles this, but a
      // suspended timer can miss it, so the visible card checks too.
      if (today != null && (today.day != now.day || today.month != now.month)) {
        context.read<PrayerTimesCubit>().refresh();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = context.watch<PrayerTimesCubit>().state;
    final hijri = context.watch<HijriCubit>().state.today;
    final next = state.nextAfter(_now);
    final today = state.today;

    const onHero = Colors.white;
    final onHeroMuted = Colors.white.withValues(alpha: 0.72);

    // Progress through the current window: from the previous time to the next one.
    double progress = 0;
    if (next != null && today != null) {
      final current = today.currentAt(_now);
      final start = current != null ? today.timeOf(current) : null;
      if (start != null) {
        final total = next.time.difference(start).inSeconds;
        final done = _now.difference(start).inSeconds;
        if (total > 0) progress = (done / total).clamp(0, 1);
      }
    }

    return Material(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: colors.heroGradient,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: GeometricPattern(
                  color: Colors.white.withValues(alpha: 0.05),
                  cell: 64,
                ),
              ),
              // A soft glow of gold behind the countdown ring.
              PositionedDirectional(
                end: -60,
                top: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colors.accent.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: next == null
                    ? SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            l10n.setLocation,
                            style: text.titleMedium?.copyWith(color: onHero),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.showDate && hijri != null)
                                  Text(
                                    context.formatHijri(hijri),
                                    style: text.labelLarge?.copyWith(
                                      color: colors.accent,
                                      fontFamily: AppFonts.ui,
                                    ),
                                  ),
                                if (widget.showDate)
                                  const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.nextPrayer,
                                  style: text.bodyMedium?.copyWith(
                                    color: onHeroMuted,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.prayerName(
                                    next.prayer,
                                    on: next.time.toLocal(),
                                  ),
                                  style: text.displaySmall?.copyWith(
                                    color: onHero,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  context.formatTime(next.time),
                                  style: text.titleMedium?.copyWith(
                                    color: onHeroMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _CountdownRing(
                            progress: progress,
                            remaining: next.time.difference(_now),
                            accent: colors.accent,
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

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    required this.progress,
    required this.remaining,
    required this.accent,
  });

  final double progress;
  final Duration remaining;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final safe = remaining.isNegative ? Duration.zero : remaining;
    return SizedBox.square(
      dimension: 116,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, color: accent),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.formatCountdown(safe),
                style: text.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.timeUntil(context.formatDuration(safe)),
                style: text.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    final inset = rect.deflate(4);
    canvas.drawArc(inset, 0, math.pi * 2, false, track);
    canvas.drawArc(inset, -math.pi / 2, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
