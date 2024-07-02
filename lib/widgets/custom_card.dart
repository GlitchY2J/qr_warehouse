import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/details_page.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    required this.partnumber,
    required this.description,
    required this.location,
    required this.qty,
    this.child,
    required this.partsList,
    super.key,
  });

  final Map<String, dynamic> partsList;
  final String partnumber;
  final String description;
  final String location;
  final String qty;
  final Widget? child;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late int min, max;

  Color backgroundColor = const Color(0xff323537);
  Color greenBackground = Colors.green[400]!;
  Color yellowBackground = Colors.amber[600]!;
  Color redBackground = const Color(0xFFFF5252);

  @override
  void initState() {
    min = int.parse(widget.partsList["3"]);
    max = int.parse(widget.partsList["4"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double minratio = max * 0.20;
    double maxratio = max * 0.10;
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: int.parse(widget.qty) >= max || int.parse(widget.qty) <= min
            ? redBackground
            : int.parse(widget.qty) >= min &&
                        int.parse(widget.qty) <= minratio + min ||
                    int.parse(widget.qty) <= max &&
                        int.parse(widget.qty) >= max - maxratio
                ? yellowBackground
                : greenBackground,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.lightBlue[600],
          onTap: () {
            //debugPrint(widget.partsList["0"]);
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => DetailsPage(
                  parts: widget.partsList,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.partnumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.qty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
