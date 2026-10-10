import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/astronomy/prayer.dart';
import '../../../../core/astronomy/prayer_calculator.dart';
import '../../../../core/astronomy/solar.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/platform/live_state.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sky.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../l10n/l10n.dart';
import '../../../hijri/presentation/cubit/hijri_cubit.dart';
import '../../../hijri/presentation/widgets/hijri_labels.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../domain/entities/prayer_settings.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/prayer_labels.dart';
import '../widgets/set_location_card.dart';

const _white = Colors.white;
final _whiteMuted = Colors.white.withValues(alpha: 0.7);

/// The day as a journey through its sky: scrolling moves from the dark before Fajr,
/// through the blue of day and the gold of Asr, to the night after Isha. Each
/// prayer is a stop along the way, and a glowing line marks the present moment.
class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key, this.arrivedByDive = false});

  /// Opened by swiping up from the home sky: plays the arrival.
  final bool arrivedByDive;

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage>
    with SingleTickerProviderStateMixin, LiveStateMixin {
  final _scroll = ScrollController();
  late final AnimationController _arrival = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    value: widget.arrivedByDive ? 0 : 1,
  );
  int _dayOffset = 0;
  Timer? _minute;
  bool _scrolledToNow = false;

  @override
  void initState() {
    super.initState();
    if (widget.arrivedByDive) _arrival.forward();
  }

  @override
  void onLiveChanged(bool live) {
    _minute?.cancel();
    _minute = null;
    if (!live) return;
    _minute = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _minute?.cancel();
    _scroll.dispose();
    _arrival.dispose();
    super.dispose();
  }

  void _scrollToNow(double y, double viewport) {
    if (_scrolledToNow) return;
    _scrolledToNow = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = (y - viewport * 0.42).clamp(
        0.0,
        _scroll.position.maxScrollExtent,
      );
      widget.arrivedByDive
          ? _scroll.animateTo(
              target,
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
            )
          : _scroll.jumpTo(target);
    });
  }

  void _changeDay(int offset) {
    HapticFeedback.selectionClick();
    setState(() {
      _dayOffset = offset;
      _scrolledToNow = offset != 0;
    });
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = context.select((LocationCubit c) => c.state.location);
    if (location == null) {
      return const Scaffold(
        body: ContentWidth(child: SetLocationCard(expanded: true)),
      );
    }
    final cubit = context.watch<PrayerTimesCubit>();
    final now = DateTime.now();
    final times = _dayOffset == 0
        ? cubit.state.today
        : cubit.timesFor(DateTime(now.year, now.month, now.day + _dayOffset));
    if (times == null) return const Scaffold(body: SizedBox.shrink());

    final top = MediaQuery.paddingOf(context).top + 150;
    final bottom = context.navBarClearance + 40;
    final layout = _DayLayout.build(times: times, top: top, bottom: bottom);
    final isToday = _dayOffset == 0;
    if (isToday) {
      _scrollToNow(layout.yOf(now), MediaQuery.sizeOf(context).height);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF04060F),
        body: AnimatedBuilder(
          animation: _arrival,
          builder: (context, child) {
            final v = Curves.easeOutCubic.transform(_arrival.value);
            return Opacity(
              opacity: v,
              child: Transform.scale(scale: 1.12 - 0.12 * v, child: child),
            );
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scroll,
                child: SizedBox(
                  height: layout.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DaySkyPainter(
                            layout: layout,
                            where: location.coordinates,
                            day: times,
                            rtl: context.isRtl,
                          ),
                        ),
                      ),
                      ..._stations(
                        context,
                        layout,
                        times,
                        cubit.state.settings,
                        isToday ? now : null,
                      ),
                      if (isToday &&
                          !now.isBefore(layout.start) &&
                          now.isBefore(layout.end))
                        _NowMarker(
                          y: layout.yOf(now),
                          now: now,
                          where: location.coordinates,
                        ),
                    ],
                  ),
                ),
              ),
              _Header(
                dayOffset: _dayOffset,
                date: times.date,
                onDayChanged: _changeDay,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _stations(
    BuildContext context,
    _DayLayout layout,
    PrayerTimes times,
    PrayerSettings settings,
    DateTime? now,
  ) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final next = now == null ? null : times.nextAfter(now);
    final widgets = <Widget>[];
    for (final (i, prayer) in Prayer.values.indexed) {
      final at = times.timeOf(prayer);
      final y = layout.stationY[i];
      final past = now != null && !at.isAfter(now);
      if (i > 0) {
        final prevY = layout.stationY[i - 1];
        final gap = at.difference(times.timeOf(Prayer.values[i - 1]));
        widgets.add(
          PositionedDirectional(
            start: _DayLayout.lineX + 18,
            top: (prevY + y) / 2 - 9,
            child: Text(
              context.formatDuration(gap),
              style: text.labelSmall?.copyWith(
                color: _white.withValues(alpha: 0.45),
              ),
            ),
          ),
        );
      }
      widgets.add(
        PositionedDirectional(
          start: 0,
          end: 0,
          top: y - 40,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: past ? 0.5 : 1,
            child: _Station(
              prayer: prayer,
              time: at,
              date: times.date,
              isNext: prayer == next,
              alert: settings.alertFor(prayer),
              onAlert: (a) {
                context.read<PrayerTimesCubit>().setAlert(prayer, a);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        '${l10n.prayerName(prayer)} · ${l10n.alertName(a)}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
              },
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

/// Maps time to vertical position: proportional to the clock, but with prayers
/// never closer than [_minGap] so short intervals (Maghrib → Isha) stay readable.
class _DayLayout {
  _DayLayout._(this.start, this.end, this.anchors, this.stationY, this.height);

  final DateTime start;
  final DateTime end;
  final List<(DateTime, double)> anchors;
  final List<double> stationY;
  final double height;

  /// Distance of the timeline from the start edge.
  static const lineX = 64.0;
  static const _pxPerMinute = 0.95;
  static const _minGap = 128.0;

  static _DayLayout build({
    required PrayerTimes times,
    required double top,
    required double bottom,
  }) {
    // The whole local day, midnight to midnight, so "now" always has a place.
    final d = times.date;
    final start = DateTime(d.year, d.month, d.day).toUtc();
    final end = DateTime(d.year, d.month, d.day + 1).toUtc();
    double minutes(DateTime a, DateTime b) => b.difference(a).inSeconds / 60;

    // Each prayer sits below the previous one in proportion to the time between
    // them. The night hours at either end are compressed: they are mostly sleep.
    final ys = <double>[
      top + 40 + minutes(start, times.fajr) * _pxPerMinute * 0.5,
    ];
    for (var i = 1; i < Prayer.values.length; i++) {
      final gap = minutes(
        times.timeOf(Prayer.values[i - 1]),
        times.timeOf(Prayer.values[i]),
      );
      ys.add(ys.last + (gap * _pxPerMinute).clamp(_minGap, double.infinity));
    }
    final endY = ys.last + 60 + minutes(times.isha, end) * _pxPerMinute * 0.5;
    final anchors = <(DateTime, double)>[
      (start, top),
      for (final (i, p) in Prayer.values.indexed) (times.timeOf(p), ys[i]),
      (end, endY),
    ];
    return _DayLayout._(start, end, anchors, ys, endY + bottom);
  }

  double yOf(DateTime t) {
    if (!t.isAfter(anchors.first.$1)) return anchors.first.$2;
    for (var i = 1; i < anchors.length; i++) {
      final (ta, ya) = anchors[i - 1];
      final (tb, yb) = anchors[i];
      if (!t.isAfter(tb)) {
        final f = t.difference(ta).inSeconds / tb.difference(ta).inSeconds;
        return ya + (yb - ya) * f;
      }
    }
    return anchors.last.$2;
  }
}

/// The background: the real colour of the sky at every moment of the day, and the
/// hairline path joining the prayers.
class _DaySkyPainter extends CustomPainter {
  _DaySkyPainter({
    required this.layout,
    required this.where,
    required this.day,
    required this.rtl,
  });

  final _DayLayout layout;
  final Coordinates where;
  final PrayerTimes day;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = <Color>[];
    final stops = <double>[];
    var t = layout.start;
    while (!t.isAfter(layout.end)) {
      final sun = Solar.sunAt(where, t);
      final sky = SkyPalette.at(sun.altitude, morning: sun.hourAngle < 0);
      colors.add(Color.lerp(sky.middle, sky.horizon, 0.3)!);
      stops.add((layout.yOf(t) / size.height).clamp(0.0, 1.0));
      t = t.add(const Duration(minutes: 15));
    }
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF04060F), ...colors, const Color(0xFF04060F)],
          stops: [0, ...stops, 1],
        ).createShader(rect),
    );

    final x = rtl ? size.width - _DayLayout.lineX : _DayLayout.lineX;
    canvas.drawLine(
      Offset(x, layout.anchors.first.$2),
      Offset(x, layout.anchors.last.$2),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_DaySkyPainter old) =>
      old.day != day || old.where != where || old.rtl != rtl;
}

class _Station extends StatelessWidget {
  const _Station({
    required this.prayer,
    required this.time,
    required this.date,
    required this.isNext,
    required this.alert,
    required this.onAlert,
  });

  final Prayer prayer;
  final DateTime time;
  final DateTime date;
  final bool isNext;
  final PrayerAlert alert;
  final ValueChanged<PrayerAlert> onAlert;

  static const _cycle = [
    PrayerAlert.sound,
    PrayerAlert.silent,
    PrayerAlert.off,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final minor = !prayer.isObligatory;
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          SizedBox(
            width: _DayLayout.lineX * 2,
            child: Center(
              child: Container(
                width: isNext ? 16 : 10,
                height: isNext ? 16 : 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _white,
                  boxShadow: isNext
                      ? [
                          BoxShadow(
                            color: _white.withValues(alpha: 0.6),
                            blurRadius: 16,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // No capitals or tracking: they break Arabic names.
                Text(
                  l10n.prayerName(prayer, on: date),
                  style: text.titleSmall?.copyWith(
                    color: isNext ? const Color(0xFFF4B56A) : _whiteMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  context.formatTime(time),
                  style: (minor ? text.headlineSmall : text.headlineLarge)
                      ?.copyWith(
                        color: _white,
                        height: 1.1,
                        fontWeight: isNext ? FontWeight.w400 : FontWeight.w200,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.alertName(alert),
            onPressed: () {
              HapticFeedback.selectionClick();
              onAlert(_cycle[(_cycle.indexOf(alert) + 1) % _cycle.length]);
            },
            icon: Icon(
              alertIcon(alert),
              size: 20,
              color: alert == PrayerAlert.off
                  ? _white.withValues(alpha: 0.35)
                  : _white,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
    );
  }
}

/// A line of light at the present moment, with the sun (or the moon) on the path.
class _NowMarker extends StatelessWidget {
  const _NowMarker({required this.y, required this.now, required this.where});

  final double y;
  final DateTime now;
  final Coordinates where;

  @override
  Widget build(BuildContext context) {
    final day = Solar.sunAt(where, now).altitude > -0.8;
    final label = '${context.l10n.now} · ${context.formatTime(now)}';
    return PositionedDirectional(
      start: 0,
      end: 0,
      top: y - 14,
      child: IgnorePointer(
        child: SizedBox(
          height: 28,
          child: Row(
            children: [
              SizedBox(
                width: _DayLayout.lineX * 2,
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: day
                          ? const Color(0xFFFFE6B0)
                          : const Color(0xFFF1EEE4),
                      boxShadow: [
                        BoxShadow(
                          color: (day ? const Color(0xFFFFC46B) : Colors.white)
                              .withValues(alpha: 0.7),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      day ? LucideIcons.sun : LucideIcons.moon,
                      size: 15,
                      color: const Color(0xFF2A2A2A),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: [
                        _white.withValues(alpha: 0.9),
                        _white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppSpacing.sm,
                  end: AppSpacing.xl,
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: _white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.dayOffset,
    required this.date,
    required this.onDayChanged,
  });

  final int dayOffset;
  final DateTime date;
  final ValueChanged<int> onDayChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final hijri = context
        .select((HijriCubit c) => c.state.calendar)
        .fromGregorian(date);
    final place = context.select((LocationCubit c) => c.state.location?.name);
    final title = switch (dayOffset) {
      0 => l10n.yourDay,
      1 => l10n.tomorrow,
      _ => context.formatWeekdayDate(date),
    };

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xE604060F), Color(0x9904060F), Color(0x0004060F)],
          stops: [0, 0.6, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (Navigator.of(context).canPop())
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    icon: Icon(context.backArrow, color: _white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: text.displaySmall?.copyWith(color: _white),
                ),
              ),
              IconButton(
                tooltip: l10n.settings,
                icon: const Icon(LucideIcons.slidersHorizontal, color: _white),
                onPressed: () =>
                    context.pushNamed(AppRoutes.prayerSettingsName),
              ),
            ],
          ),
          Text(
            [
              if (dayOffset <= 1) context.formatWeekdayDate(date),
              context.formatHijri(hijri),
              ?place,
            ].join(' · '),
            style: text.bodySmall?.copyWith(color: _whiteMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _DayButton(
                icon: context.isRtl
                    ? LucideIcons.chevronRight
                    : LucideIcons.chevronLeft,
                onTap: () => onDayChanged(dayOffset - 1),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (dayOffset != 0)
                GlassPanel(
                  radius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  onTap: () => onDayChanged(0),
                  child: Text(
                    l10n.today,
                    style: const TextStyle(color: _white),
                  ),
                ),
              const Spacer(),
              const _PermissionBanner(),
              const SizedBox(width: AppSpacing.sm),
              _DayButton(
                icon: context.forwardChevron,
                onTap: () => onDayChanged(dayOffset + 1),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GlassPanel(
    shape: BoxShape.circle,
    padding: const EdgeInsets.all(8),
    onTap: onTap,
    child: Icon(icon, size: 18, color: _white),
  );
}

/// A small glass pill that explains, and fixes in one tap, why a prayer
/// notification might not arrive.
class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<PrayerTimesCubit>().state;
    final perms = state.permissions;
    final wantsAlerts = state.settings.alerts.values.any(
      (a) => a != PrayerAlert.off,
    );
    if (perms == null || !wantsAlerts) return const SizedBox.shrink();
    final cubit = context.read<PrayerTimesCubit>();
    final (message, action) = !perms.notificationsAllowed
        ? (l10n.notificationsBlocked, cubit.requestNotificationPermission)
        : !perms.exactAlarmsAllowed
        ? (l10n.exactAlarmsNeeded, cubit.requestExactAlarms)
        : (null, null);
    if (message == null) return const SizedBox.shrink();
    return Tooltip(
      message: message,
      child: GlassPanel(
        radius: 18,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        ),
        onTap: action,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              perms.notificationsAllowed
                  ? LucideIcons.alarmClock
                  : LucideIcons.bellOff,
              size: 15,
              color: const Color(0xFFF4B860),
            ),
            const SizedBox(width: 6),
            Text(l10n.allow, style: const TextStyle(color: _white)),
          ],
        ),
      ),
    );
  }
}
