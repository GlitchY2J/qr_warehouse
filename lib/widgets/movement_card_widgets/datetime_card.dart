import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  String formatDate(date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(dateTime);
    return formatedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 30,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatDate(movements[index].dateTime),
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
