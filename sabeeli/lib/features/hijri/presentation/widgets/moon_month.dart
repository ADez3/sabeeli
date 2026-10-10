import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/solar.dart';
import '../../../../core/hijri/hijri_date.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/moon_phase.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/hijri_cubit.dart';
import 'hijri_labels.dart';

/// A Hijri month as the moon sees it: every day drawn in the real phase of the
/// moon on that date, today ringed, and the days that matter marked in amber.
/// Follows the user's adjusted calendar, so a corrected month start moves it too.
class MoonMonth extends StatefulWidget {
  const MoonMonth({super.key});

  @override
  State<MoonMonth> createState() => _MoonMonthState();
}

class _MoonMonthState extends State<MoonMonth> {
  /// Months from the current one.
  int _offset = 0;

  void _shift(int by) {
    HapticFeedback.selectionClick();
    setState(() => _offset += by);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<HijriCubit>().state;
    final calendar = state.calendar;
    final now = DateTime.now();
    final today = state.today ?? calendar.fromGregorian(now);
    final ym = HijriDate.fromMonthIndex(today.monthIndex + _offset);
    final length = calendar.daysInMonth(ym.year, ym.month);
    final first = calendar.toGregorian(HijriDate(ym.year, ym.month, 1));

    // Leading blanks so day 1 falls under its weekday, starting the week where the
    // locale does.
    final firstDayOfWeek = MaterialLocalizations.of(context)
        .firstDayOfWeekIndex; // 0 = Sunday
    final lead = (first.weekday % 7 - firstDayOfWeek) % 7;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final weekdays = [
      for (var i = 0; i < 7; i++)
        DateFormat.E(locale)
            .format(DateTime(2024, 1, 7 + (firstDayOfWeek + i) % 7)),
    ];

    final events = _events(l10n, ym.month);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0F2C), Color(0xFF060814)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Arrow(
                icon: context.isRtl
                    ? LucideIcons.chevronRight
                    : LucideIcons.chevronLeft,
                onTap: () => _shift(-1),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l10n.hijriMonthName(ym.month),
                      style: const TextStyle(
                        fontFamily: AppFonts.display,
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${context.digits(ym.year)} ${l10n.hijriYearSuffix} · ${context.formatShortDate(first)}',
                      style: text.labelMedium?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              _Arrow(icon: context.forwardChevron, onTap: () => _shift(1)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (final w in weekdays)
                Expanded(
                  child: Text(
                    w,
                    textAlign: TextAlign.center,
                    style: text.labelSmall?.copyWith(color: Colors.white38),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.78,
            children: [
              for (var i = 0; i < lead; i++) const SizedBox.shrink(),
              for (var d = 1; d <= length; d++)
                _Day(
                  day: d,
                  date: DateTime(first.year, first.month, first.day + d - 1),
                  isToday: _offset == 0 && d == today.day,
                  marked: events.any((e) => e.$1 == d) || d >= 13 && d <= 15,
                  accent: colors.accent,
                ),
            ],
          ),
          // The white days are in every month; the rest depend on it.
          ...[
            const SizedBox(height: AppSpacing.md),
            for (final (day, name) in [...events, (13, l10n.whiteDays)])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        name,
                        style: text.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      day == 13
                          ? '${context.digits(13)}–${context.digits(15)}'
                          : context.formatShortDate(
                              DateTime(
                                first.year,
                                first.month,
                                first.day + day - 1,
                              ),
                            ),
                      style: text.bodySmall?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Days that matter in a month, by Hijri day.
  static List<(int, String)> _events(AppLocalizations l10n, int month) =>
      switch (month) {
        1 => [(1, l10n.islamicNewYear), (10, l10n.ashura)],
        9 => [(1, l10n.ramadanBegins)],
        10 => [(1, l10n.eidAlFitr)],
        12 => [(9, l10n.dayOfArafah), (10, l10n.eidAlAdha)],
        _ => const [],
      };
}

class _Day extends StatelessWidget {
  const _Day({
    required this.day,
    required this.date,
    required this.isToday,
    required this.marked,
    required this.accent,
  });

  final int day;
  final DateTime date;
  final bool isToday;
  final bool marked;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // The real moon that evening, when a new Hijri day begins.
    final age = Solar.moonAge(DateTime(date.year, date.month, date.day, 19));
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: accent, width: 1.4) : null,
        color: isToday ? accent.withValues(alpha: 0.08) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MoonPhaseIcon(age: age, size: 20),
          const SizedBox(height: 3),
          Text(
            context.digits(day),
            style: text.labelMedium?.copyWith(
              color: marked ? accent : Colors.white,
              fontWeight: isToday || marked ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            context.digits(date.day),
            style: text.labelSmall?.copyWith(
              color: Colors.white38,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onTap,
    icon: Icon(icon, color: Colors.white70, size: 20),
  );
}
