import 'package:intl/intl.dart';

class Formatters {
  static String formatDateFromString(String date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(dateTime);
    return formatedDate;
  }

  static String formatDateFromDateTime(DateTime date) {
    //DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(date);
    return formatedDate;
  }

  static String integerOrDouble(String value) {
    if (num.parse(value) % 1 == 0) {
      return int.parse(value).toString();
    } else {
      return double.parse(value).toStringAsFixed(1);
    }
  }
}
