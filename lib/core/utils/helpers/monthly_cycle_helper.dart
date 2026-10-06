import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

/// Helper utility for calculating and managing the monthly expense cycle/lifecycle.
class MonthlyCycleHelper {
  static const int defaultCycleStartDay = 5;
  static const String settingsBoxName = 'settings';
  static const String cycleStartDayKey = 'monthly_cycle_start_day';

  /// Clamps day of month safely against month lengths (including leap years and variable month end dates).
  static DateTime getClampedDate(
    int year,
    int month,
    int day, {
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    final normalized = DateTime(year, month, 1);
    final lastDay = DateTime(normalized.year, normalized.month + 1, 0).day;
    final effectiveDay = day > lastDay ? lastDay : (day < 1 ? 1 : day);
    return DateTime(
      normalized.year,
      normalized.month,
      effectiveDay,
      hour,
      minute,
      second,
      millisecond,
    );
  }

  /// Calculates the active monthly cycle start (inclusive) and end (exclusive) dates
  /// for a given [startDay] and [referenceDate].
  ///
  /// Example (startDay = 5):
  /// - On Sep 30, 2026 -> Start: Sep 5, 2026 00:00:00, End: Oct 5, 2026 00:00:00
  /// - On Oct 4, 2026  -> Start: Sep 5, 2026 00:00:00, End: Oct 5, 2026 00:00:00
  /// - On Oct 5, 2026  -> Start: Oct 5, 2026 00:00:00, End: Nov 5, 2026 00:00:00
  static ({DateTime start, DateTime end}) getCycleRange({
    int startDay = defaultCycleStartDay,
    DateTime? referenceDate,
  }) {
    final ref = referenceDate ?? DateTime.now();
    final validStartDay = startDay.clamp(1, 31);

    DateTime start;
    DateTime end;

    if (ref.day >= validStartDay) {
      start = getClampedDate(ref.year, ref.month, validStartDay);
      end = getClampedDate(ref.year, ref.month + 1, validStartDay);
    } else {
      start = getClampedDate(ref.year, ref.month - 1, validStartDay);
      end = getClampedDate(ref.year, ref.month, validStartDay);
    }

    return (start: start, end: end);
  }

  /// Determines whether [date] falls within the active monthly cycle.
  static bool isInCycle(
    DateTime date, {
    int startDay = defaultCycleStartDay,
    DateTime? referenceDate,
  }) {
    final range = getCycleRange(
      startDay: startDay,
      referenceDate: referenceDate,
    );
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }

  /// Returns the ordinal suffix for a number (e.g. 1st, 2nd, 3rd, 4th, 5th, 21st).
  static String getOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Returns formatted cycle range with month names (e.g. "Sep 5 – Oct 5").
  static String getCycleLabel(
    int startDay, {
    DateTime? referenceDate,
    bool shortMonth = true,
  }) {
    final range = getCycleRange(
      startDay: startDay,
      referenceDate: referenceDate,
    );
    final pattern = shortMonth ? 'MMM d' : 'MMMM d';
    final formatter = DateFormat(pattern);
    return '${formatter.format(range.start)} – ${formatter.format(range.end)}';
  }

  /// Loads the saved cycle start day from Hive settings, defaulting to 5.
  static Future<int> getSavedCycleStartDay() async {
    try {
      final box = await Hive.openBox(settingsBoxName);
      final value = box.get(cycleStartDayKey, defaultValue: defaultCycleStartDay);
      if (value is int && value >= 1 && value <= 31) {
        return value;
      }
    } catch (_) {}
    return defaultCycleStartDay;
  }

  /// Saves the chosen cycle start day to Hive settings.
  static Future<void> saveCycleStartDay(int day) async {
    try {
      final box = await Hive.openBox(settingsBoxName);
      await box.put(cycleStartDayKey, day.clamp(1, 31));
    } catch (_) {}
  }
}
