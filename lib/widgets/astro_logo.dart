import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AstroLogo extends StatelessWidget {
  final Color color;
  final double width;

  const AstroLogo({
    super.key,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_white.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: width,
    );
  }
}
