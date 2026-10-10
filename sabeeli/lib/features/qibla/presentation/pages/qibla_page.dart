import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/platform/live_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ambient_background.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/hub_header.dart';
import '../../../../core/widgets/icon_toggle.dart';
import '../../../../l10n/l10n.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/widgets/set_location_card.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/land_mask.dart';
import '../../domain/usecases/get_land_mask_usecase.dart';
import '../cubit/qibla_cubit.dart';
import '../widgets/qibla_globe.dart';

/// The Qibla: a live compass, or the globe showing the path to the Kaaba.
class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> with LiveStateMixin {
  bool _globe = false;
  late final QiblaCubit _cubit = getIt<QiblaCubit>()
    ..start(context.read<LocationCubit>().state.location?.coordinates);

  /// The tab stays alive in the background of the shell; the compass does not.
  @override
  void onLiveChanged(bool live) => live ? _cubit.resume() : _cubit.pause();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: AmbientBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                ContentWidth(
                  child: HubHeader(
                    title: l10n.qibla,
                    subtitle: l10n.qiblaSubtitle,
                    trailing: IconToggle<bool>(
                      selected: _globe,
                      onChanged: (g) => setState(() => _globe = g),
                      options: [
                        (false, LucideIcons.compass, l10n.compassView),
                        (true, LucideIcons.globe, l10n.globeView),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    // The page sits above the floating navigation bar.
                    padding: EdgeInsets.only(bottom: context.navBarClearance),
                    child: BlocListener<LocationCubit, LocationState>(
                      listenWhen: (a, b) => a.location != b.location,
                      listener: (context, s) => context
                          .read<QiblaCubit>()
                          .start(s.location?.coordinates),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: _globe
                            ? const _GlobeBody(key: ValueKey('globe'))
                            : const _QiblaBody(key: ValueKey('compass')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlobeBody extends StatefulWidget {
  const _GlobeBody({super.key});

  @override
  State<_GlobeBody> createState() => _GlobeBodyState();
}

class _GlobeBodyState extends State<_GlobeBody> {
  late final Future<LandMask?> _mask = getIt<GetLandMaskUseCase>()(
    const NoParams(),
  ).then((r) => r.valueOrNull);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final location = context.select((LocationCubit c) => c.state.location);
    final state = context.watch<QiblaCubit>().state;
    if (location == null) {
      return const ContentWidth(child: SetLocationCard(expanded: true));
    }
    return ContentWidth(
      maxWidth: 560,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<LandMask?>(
                future: _mask,
                builder: (context, snap) => snap.data == null
                    ? const SizedBox.shrink()
                    : QiblaGlobe(
                        user: location.coordinates,
                        mask: snap.data!,
                        youLabel: l10n.you,
                        makkahLabel: l10n.makkah,
                      ),
              ),
            ),
            Text(
              l10n.qiblaGreatCircle,
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(
                color: colors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: l10n.qiblaDirection,
                      value: l10n.degreesFromNorth(
                        context.formatNumber(state.bearing ?? 0, decimals: 1),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 36, color: colors.outline),
                  Expanded(
                    child: _Stat(
                      label: l10n.location,
                      value: l10n.distanceToKaaba(
                        context.formatNumber(state.distanceKm ?? 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QiblaBody extends StatelessWidget {
  const _QiblaBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<QiblaCubit>().state;

    if (state.status == QiblaStatus.noLocation) {
      return const ContentWidth(child: SetLocationCard(expanded: true));
    }
    if (state.status == QiblaStatus.initial) return const SizedBox.shrink();

    final bearing = state.bearing ?? 0;
    final facing = state.isFacing;
    final heading = state.reading?.heading;

    return ContentWidth(
      maxWidth: 560,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.md),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              state.status == QiblaStatus.noCompass
                  ? l10n.qiblaDirection
                  : facing
                  ? l10n.facingQibla
                  : l10n.turnTowards,
              key: ValueKey(facing),
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(
                color: facing ? colors.accent : colors.text,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final size = math.min(constraints.maxWidth, 360.0);
              return Center(
                child: SizedBox.square(
                  dimension: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // The dial turns so north stays north; the Kaaba marker sits on it.
                      Transform.rotate(
                        angle: heading == null ? 0 : -heading * math.pi / 180,
                        child: CustomPaint(
                          size: Size.square(size),
                          painter: _DialPainter(
                            bearing: bearing,
                            ring: colors.outline,
                            tick: colors.textMuted,
                            north: colors.danger,
                            kaaba: colors.accent,
                            glow: facing,
                          ),
                        ),
                      ),
                      // The phone's own direction: fixed, pointing up.
                      Positioned(
                        top: 0,
                        child: Icon(
                          LucideIcons.navigation2,
                          size: 30,
                          color: facing ? colors.accent : colors.primary,
                        ),
                      ),
                      Container(
                        width: size * 0.36,
                        height: size * 0.36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surface,
                          border: Border.all(color: colors.outline),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${context.digits(bearing.round())}°',
                              style: text.headlineMedium?.copyWith(
                                color: facing ? colors.accent : colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (state.turn != null && !facing)
                              Icon(
                                state.turn! > 0
                                    ? LucideIcons.rotateCw
                                    : LucideIcons.rotateCcw,
                                color: colors.textMuted,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          if (state.status == QiblaStatus.noCompass)
            _Note(
              icon: LucideIcons.navigationOff,
              text: l10n.compassUnavailable,
            )
          else if (state.reading?.needsCalibration ?? false)
            _Note(icon: LucideIcons.rotate3d, text: l10n.calibrateCompass),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: l10n.qiblaDirection,
                    value: context.digits(
                      l10n.degreesFromNorth(
                        context.formatNumber(bearing, decimals: 1),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 36, color: colors.outline),
                Expanded(
                  child: _Stat(
                    label: l10n.location,
                    value: context.digits(
                      l10n.distanceToKaaba(
                        context.formatNumber(state.distanceKm ?? 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: context.colors.textMuted),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        value,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    ],
  );
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => AppCard(
    color: context.colors.accent.withValues(alpha: 0.08),
    child: Row(
      children: [
        Icon(icon, color: context.colors.accent),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.bearing,
    required this.ring,
    required this.tick,
    required this.north,
    required this.kaaba,
    required this.glow,
  });

  final double bearing;
  final Color ring;
  final Color tick;
  final Color north;
  final Color kaaba;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    // The ring is inset so the Kaaba marker can sit outside it, clear of the letters.
    final r = size.width / 2 - 34;

    if (glow) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [kaaba.withValues(alpha: 0.18), Colors.transparent],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    for (var d = 0; d < 360; d += 5) {
      final major = d % 30 == 0;
      final a = d * math.pi / 180 - math.pi / 2;
      final outer = c + Offset(math.cos(a), math.sin(a)) * r;
      final inner =
          c + Offset(math.cos(a), math.sin(a)) * (r - (major ? 14 : 7));
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = d == 0 ? north : tick.withValues(alpha: major ? 0.9 : 0.4)
          ..strokeWidth = major ? 2 : 1,
      );
    }

    // Cardinal letters are universal on compasses, so they are not translated.
    const letters = {0: 'N', 90: 'E', 180: 'S', 270: 'W'};
    for (final e in letters.entries) {
      final a = e.key * math.pi / 180 - math.pi / 2;
      final p = c + Offset(math.cos(a), math.sin(a)) * (r - 30);
      final tp = TextPainter(
        text: TextSpan(
          text: e.value,
          style: TextStyle(
            color: e.key == 0 ? north : tick,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(e.key * math.pi / 180);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // The Kaaba: a gold mark across the ring and a cube just outside it.
    final a = bearing * math.pi / 180 - math.pi / 2;
    final dir = Offset(math.cos(a), math.sin(a));
    canvas.drawLine(
      c + dir * (r - 16),
      c + dir * (r + 6),
      Paint()
        ..color = kaaba
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    final k = c + dir * (r + 20);
    canvas.save();
    canvas.translate(k.dx, k.dy);
    canvas.rotate(bearing * math.pi / 180);
    final cube = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 22, height: 22),
      const Radius.circular(3),
    );
    canvas.drawRRect(cube, Paint()..color = const Color(0xFF1A1A1A));
    canvas.drawRect(
      const Rect.fromLTWH(-11, -5, 22, 3),
      Paint()..color = kaaba,
    );
    canvas.drawRRect(
      cube,
      Paint()
        ..color = kaaba
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.bearing != bearing ||
      old.glow != glow ||
      old.ring != ring ||
      old.kaaba != kaaba;
}
