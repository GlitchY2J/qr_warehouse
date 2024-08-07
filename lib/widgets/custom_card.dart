import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/details_page.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    this.child,
    required this.partNumber,
    super.key,
    required this.getPartNumber,
  });

  final PartNumber partNumber;
  final Widget? child;
  final VoidCallback getPartNumber;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late int min, max;

  Color backgroundColor = const Color(0xff323537);
  Color greenBackground = const Color(0xFF9ADE7B);
  Color yellowBackground = const Color(0xFFFFBB64);
  Color redBackground = const Color(0xFFF28585);
  Color splashColor = const Color(0xFF433D8B);
  Color cardTextColor = Colors.white70;

  @override
  void initState() {
    min = int.parse(widget.partNumber.min);
    max = int.parse(widget.partNumber.max);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double minratio = max * 0.20;
    double maxratio = max * 0.10;
    return Container(
      width: 400,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),

      // card color depending on min, max and quantity values
      child: Material(
        color: int.parse(widget.partNumber.quantity) >= max ||
                int.parse(widget.partNumber.quantity) <= min
            ? redBackground
            : int.parse(widget.partNumber.quantity) >= min &&
                        int.parse(widget.partNumber.quantity) <=
                            minratio + min ||
                    int.parse(widget.partNumber.quantity) <= max &&
                        int.parse(widget.partNumber.quantity) >= max - maxratio
                ? yellowBackground
                : greenBackground,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: splashColor,
          onTap: () async {
            await Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (BuildContext context) => DetailsPage(
                  partNumber: widget.partNumber,
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
                      widget.partNumber.partNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.partNumber.location,
                      style: TextStyle(
                        color: cardTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 230,
                      child: Text(
                        widget.partNumber.description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cardTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.partNumber.quantity,
                      style: TextStyle(
                        color: cardTextColor,
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
