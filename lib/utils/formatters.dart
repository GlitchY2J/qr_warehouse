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
}
