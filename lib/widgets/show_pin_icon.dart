import 'package:flutter/material.dart';

class ShowPinIcon extends StatelessWidget {
  const ShowPinIcon({
    super.key,
    required this.pinHidden,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  final bool pinHidden;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Function()? onTapCancel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: IconButton(
        icon: Icon(
          pinHidden ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {},
      ),
    );
  }
}
