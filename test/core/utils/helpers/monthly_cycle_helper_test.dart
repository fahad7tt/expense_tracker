import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker/core/utils/helpers/monthly_cycle_helper.dart';

void main() {
  group('MonthlyCycleHelper', () {
    test('getOrdinal returns correct suffixes', () {
      expect(MonthlyCycleHelper.getOrdinal(1), 'st');
      expect(MonthlyCycleHelper.getOrdinal(2), 'nd');
      expect(MonthlyCycleHelper.getOrdinal(3), 'rd');
      expect(MonthlyCycleHelper.getOrdinal(4), 'th');
      expect(MonthlyCycleHelper.getOrdinal(5), 'th');
      expect(MonthlyCycleHelper.getOrdinal(11), 'th');
      expect(MonthlyCycleHelper.getOrdinal(12), 'th');
      expect(MonthlyCycleHelper.getOrdinal(13), 'th');
      expect(MonthlyCycleHelper.getOrdinal(21), 'st');
      expect(MonthlyCycleHelper.getOrdinal(22), 'nd');
      expect(MonthlyCycleHelper.getOrdinal(23), 'rd');
      expect(MonthlyCycleHelper.getOrdinal(31), 'st');
    });

    test('getCycleLabel formats properly with month names', () {
      final sepDate = DateTime(2026, 9, 30);
      expect(
        MonthlyCycleHelper.getCycleLabel(5, referenceDate: sepDate),
        'Sep 5 – Oct 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(1, referenceDate: sepDate),
        'Sep 1 – Oct 1',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(20, referenceDate: sepDate),
        'Sep 20 – Oct 20',
      );
    });

    test('getCycleRange with default 5th-5th on Sep 30', () {
      final ref = DateTime(2026, 9, 30, 11, 0, 0);
      final range = MonthlyCycleHelper.getCycleRange(
        startDay: 5,
        referenceDate: ref,
      );

      expect(range.start, DateTime(2026, 9, 5, 0, 0, 0));
      expect(range.end, DateTime(2026, 10, 5, 0, 0, 0));
    });

    test('getCycleRange with 5th-5th on Oct 4 (before 5th)', () {
      final ref = DateTime(2026, 10, 4, 23, 59, 59);
      final range = MonthlyCycleHelper.getCycleRange(
        startDay: 5,
        referenceDate: ref,
      );

      expect(range.start, DateTime(2026, 9, 5, 0, 0, 0));
      expect(range.end, DateTime(2026, 10, 5, 0, 0, 0));
    });

    test('getCycleRange with 5th-5th on Oct 5 (new cycle starts)', () {
      final ref = DateTime(2026, 10, 5, 0, 0, 0);
      final range = MonthlyCycleHelper.getCycleRange(
        startDay: 5,
        referenceDate: ref,
      );

      expect(range.start, DateTime(2026, 10, 5, 0, 0, 0));
      expect(range.end, DateTime(2026, 11, 5, 0, 0, 0));
    });

    test('month range automatically updates every month', () {
      // Month-over-month progression for 5th-5th cycle:
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2026, 9, 30),
        ),
        'Sep 5 – Oct 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2026, 10, 10),
        ),
        'Oct 5 – Nov 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2026, 11, 15),
        ),
        'Nov 5 – Dec 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2026, 12, 20),
        ),
        'Dec 5 – Jan 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2027, 1, 10),
        ),
        'Jan 5 – Feb 5',
      );
      expect(
        MonthlyCycleHelper.getCycleLabel(
          5,
          referenceDate: DateTime(2027, 2, 10),
        ),
        'Feb 5 – Mar 5',
      );
    });

    test('getCycleRange with 1st-1st on Jan 15', () {
      final ref = DateTime(2026, 1, 15);
      final range = MonthlyCycleHelper.getCycleRange(
        startDay: 1,
        referenceDate: ref,
      );

      expect(range.start, DateTime(2026, 1, 1, 0, 0, 0));
      expect(range.end, DateTime(2026, 2, 1, 0, 0, 0));
    });

    test('getCycleRange with 31st during February (clamped correctly)', () {
      final ref = DateTime(2026, 2, 15);
      final range = MonthlyCycleHelper.getCycleRange(
        startDay: 31,
        referenceDate: ref,
      );

      // Previous month is January (31 days), current month is February (28 days in 2026)
      expect(range.start, DateTime(2026, 1, 31, 0, 0, 0));
      expect(range.end, DateTime(2026, 2, 28, 0, 0, 0));
    });

    test('isInCycle correctly includes and excludes dates', () {
      final ref = DateTime(2026, 9, 30);
      const startDay = 5;

      // Inside cycle (Sep 5 00:00 to Oct 5 00:00)
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 9, 5, 0, 0, 0),
          startDay: startDay,
          referenceDate: ref,
        ),
        isTrue,
      );
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 9, 15, 14, 30),
          startDay: startDay,
          referenceDate: ref,
        ),
        isTrue,
      );
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 10, 4, 23, 59, 59),
          startDay: startDay,
          referenceDate: ref,
        ),
        isTrue,
      );

      // Outside cycle
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 9, 4, 23, 59, 59),
          startDay: startDay,
          referenceDate: ref,
        ),
        isFalse,
      );
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 8, 20),
          startDay: startDay,
          referenceDate: ref,
        ),
        isFalse,
      );
      expect(
        MonthlyCycleHelper.isInCycle(
          DateTime(2026, 10, 5, 0, 0, 0),
          startDay: startDay,
          referenceDate: ref,
        ),
        isFalse,
      );
    });
  });
}
