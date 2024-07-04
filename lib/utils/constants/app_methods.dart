import 'package:intl/intl.dart';

class AppMethods {
  String dateFormatter(DateTime dt) {
    return DateFormat.yMd().format(dt);
  }

  String timeFormatter(DateTime dt) {
    return DateFormat.jm().format(dt);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String formatTimeAgoOrDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      // More than 24 hours ago, just show the date
      return DateFormat.yMd()
          .format(dateTime); // Adjust the date format as needed
    } else {
      // Less than 24 hours ago, show "X hours ago" or "X minutes ago"
      if (difference.inHours >= 1) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    }
  }
}
