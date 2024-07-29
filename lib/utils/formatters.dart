import 'package:intl/intl.dart';

class Formatters {
  static String formatDate(date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(dateTime);
    return formatedDate;
  }
}
