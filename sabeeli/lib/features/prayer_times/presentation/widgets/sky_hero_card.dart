import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sky.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/l10n.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../hijri/presentation/widgets/hijri_labels.dart';
import '../cubit/prayer_times_cubit.dart';
import 'prayer_labels.dart';

/// The hero of the app: the sky of the current prayer period, the next prayer with
/// a live countdown and, optionally, the whole day as a sun path through the six
/// prayer times.
class SkyHeroCard extends StatefulWidget {
  const SkyHeroCard({super.key, this.showTimeline = true, this.onTap});

  final bool showTimeline;
  final VoidCallback? onTap;

  @override
  State<SkyHeroCard> createState() => _SkyHeroCardState();
}

class _SkyHeroCardState extends State<SkyHeroCard> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final today = context.read<PrayerTimesCubit>().state.today?.date;
      setState(() => _now = now);
      // A suspended timer can miss midnight; the visible card rolls the day too.
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
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = context.watch<PrayerTimesCubit>().state;
    final hijri = context.watch<HijriCubit>().state.today;
    final today = state.today;
    final next = state.nextAfter(_now);
    if (today == null || next == null) return const SizedBox.shrink();

    final phase = SkyPhase.at(today, _now);
    final muted = Colors.white.withValues(alpha: 0.72);
    final remaining = next.time.difference(_now);

    return Material(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: phase.colors,
            ),
          ),
          child: Stack(
            children: [
              if (phase.stars) const Positioned.fill(child: _Stars()),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hijri != null)
                      Text(
                        context.formatHijri(hijri),
                        style: text.labelLarge?.copyWith(color: muted),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.prayerName(
                                  next.prayer,
                                  on: next.time.toLocal(),
                                ),
                                style: text.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                context.formatTime(next.time),
                                style: text.titleMedium?.copyWith(color: muted),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              context.formatCountdown(
                                remaining.isNegative
                                    ? Duration.zero
                                    : remaining,
                              ),
                              style: text.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            Text(
                              l10n.nextPrayer,
                              style: text.labelMedium?.copyWith(color: muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.showTimeline) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _SunPath(times: today, now: _now, next: next.prayer),
                    ],
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

/// The six times of the day, evenly spaced along an arc, with the sun (or the
/// moon) at the current moment between them.
class _SunPath extends StatelessWidget {
  const _SunPath({required this.times, required this.now, required this.next});

  final PrayerTimes times;
  final DateTime now;
  final Prayer next;

  /// Position of [now] in slot units: 0 at Fajr, 5 at Isha, interpolated in between.
  double? _position() {
    const prayers = Prayer.values;
    for (var i = 0; i < prayers.length - 1; i++) {
      final a = times.timeOf(prayers[i]);
      final b = times.timeOf(prayers[i + 1]);
      if (!now.isBefore(a) && now.isBefore(b)) {
        return i + now.difference(a).inSeconds / b.difference(a).inSeconds;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final current = times.currentAt(now);

    return Column(
      children: [
        SizedBox(
          height: 56,
          width: double.infinity,
          child: CustomPaint(
            painter: _SunPathPainter(
              position: _position(),
              passed: current == null ? -1 : Prayer.values.indexOf(current),
              next: Prayer.values.indexOf(next),
              rtl: rtl,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            for (final p in Prayer.values)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l10n.prayerName(p, on: times.date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall?.copyWith(
                        color: Colors.white.withValues(
                          alpha: p == next ? 1 : 0.7,
                        ),
                        fontWeight: p == next
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    Text(
                      context.formatTime(times.timeOf(p)),
                      maxLines: 1,
                      style: text.labelSmall?.copyWith(
                        color: Colors.white.withValues(
                          alpha: p == next ? 1 : 0.6,
                        ),
                        fontWeight: p == next
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SunPathPainter extends CustomPainter {
  _SunPathPainter({
    required this.position,
    required this.passed,
    required this.next,
    required this.rtl,
  });

  final double? position;
  final int passed;
  final int next;
  final bool rtl;

  static const _slots = 6;

  Offset _point(Size size, double slot) {
    // Slots are centred like the Expanded labels below them.
    final step = size.width / _slots;
    var x = step / 2 + slot * step;
    if (rtl) x = size.width - x;
    final f = slot / (_slots - 1);
    final y = size.height - 8 - math.sin(f * math.pi) * (size.height - 18);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final faint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final bright = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    Path path(double to) {
      final p = Path();
      const steps = 60;
      for (var i = 0; i <= steps; i++) {
        final pt = _point(size, to * i / steps);
        i == 0 ? p.moveTo(pt.dx, pt.dy) : p.lineTo(pt.dx, pt.dy);
      }
      return p;
    }

    canvas.drawPath(path(_slots - 1), faint);
    final pos = position;
    if (pos != null) canvas.drawPath(path(pos), bright);

    for (var i = 0; i < _slots; i++) {
      final pt = _point(size, i.toDouble());
      final isNext = i == next;
      canvas.drawCircle(
        pt,
        isNext ? 4.5 : 3.5,
        Paint()
          ..color = i <= passed || isNext
              ? Colors.white
              : Colors.white.withValues(alpha: 0.35),
      );
    }

    if (pos != null) {
      final sun = _point(size, pos);
      canvas.drawCircle(
        sun,
        14,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFE2A8).withValues(alpha: 0.9),
              const Color(0x00FFE2A8),
            ],
          ).createShader(Rect.fromCircle(center: sun, radius: 14)),
      );
      canvas.drawCircle(sun, 5.5, Paint()..color = const Color(0xFFFFF1D0));
    }
  }

  @override
  bool shouldRepaint(_SunPathPainter old) =>
      old.position != position ||
      old.passed != passed ||
      old.next != next ||
      old.rtl != rtl;
}

/// A few fixed stars; deterministic so they do not jump between frames.
class _Stars extends StatelessWidget {
  const _Stars();

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _StarsPainter()));
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);
    final paint = Paint();
    for (var i = 0; i < 40; i++) {
      final o = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height * 0.6,
      );
      paint.color = Colors.white.withValues(
        alpha: 0.15 + random.nextDouble() * 0.45,
      );
      canvas.drawCircle(o, 0.6 + random.nextDouble() * 0.9, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => false;
}
