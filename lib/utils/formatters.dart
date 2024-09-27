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

  static String integerOrDouble(String value, String measure) {
    if (measure == 'IN' || measure == 'FT' || measure == 'YD') {
      return numberToDouble(value);
    } else {
      return numberToInteger(value);
    }
  }

  // PARSE NUMBER TO DOUBLE
  static String numberToDouble(String value) {
    return double.parse(value).toStringAsFixed(1);
  }

  // PARSE NUMBER TO INTEGER
  static String numberToInteger(String value) {
    return int.parse(value).toString();
  }
}
