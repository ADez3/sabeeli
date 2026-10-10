import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/features/quran/domain/entities/quran_entities.dart';

void main() {
  final start = DateTime(2026, 10, 1);

  test('a 30-day plan covers the 604 pages, every page once', () {
    final plan = KhatmahPlan(start: start, days: 30);
    var next = 1;
    for (var day = 1; day <= 30; day++) {
      final (from, to) = plan.portion(start.add(Duration(days: day - 1)));
      expect(from, next, reason: 'day $day starts where the last ended');
      expect(to, greaterThanOrEqualTo(from));
      next = to + 1;
    }
    expect(next - 1, QuranData.pageCount);
  });

  test('a plan from the middle covers only what remains', () {
    final plan = KhatmahPlan(start: start, days: 10, fromPage: 305);
    expect(plan.pages, 300);
    expect(plan.portion(start).$1, 305);
    expect(plan.portion(start.add(const Duration(days: 9))).$2, 604);
  });

  test('days are counted by calendar date, not by 24 hours', () {
    final plan = KhatmahPlan(start: DateTime(2026, 10, 1, 23, 50), days: 7);
    expect(plan.dayOf(DateTime(2026, 10, 2, 0, 10)), 2);
  });

  test('a plan survives a round trip through storage', () {
    final plan = KhatmahPlan(start: start, days: 15, fromPage: 42);
    expect(KhatmahPlan.fromJson(plan.toJson()), plan);
    expect(KhatmahPlan.fromJson(null), isNull);
    expect(KhatmahPlan.fromJson({'start': 'nonsense', 'days': 3}), isNull);
  });
}
