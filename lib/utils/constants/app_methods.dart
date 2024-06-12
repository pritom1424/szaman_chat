import 'package:intl/intl.dart';

class AppMethods {
  String dateFormatter(DateTime dt) {
    return DateFormat.yMd().format(dt);
  }
}
