import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AstrophysicsLogo extends StatelessWidget {
  final Color color;
  final double width;

  const AstrophysicsLogo({
    super.key,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/astrophysics_white.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: width,
    );
  }
}
