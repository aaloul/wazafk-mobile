import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Relative "time ago" label matching the design (e.g. "30 min ago").
/// Falls back to an absolute date for anything older than ~30 days.
String timeAgo(BuildContext context, DateTime? date) {
  if (date == null) return '';
  final strings = context.resources.strings;
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return strings.justNow;
  if (diff.inMinutes < 60) return strings.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return strings.hoursAgo(diff.inHours);
  if (diff.inDays < 30) return strings.daysAgo(diff.inDays);
  return DateFormat('dd-MM-yyyy').format(date);
}
