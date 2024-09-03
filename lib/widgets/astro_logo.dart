import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AstroLogo extends StatelessWidget {
  final double width;

  const AstroLogo({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF9949DF), Color(0xFFD1AEF0)],
        ).createShader(bounds);
      },
      child: SvgPicture.asset(
        'assets/images/qr_logo.svg',
        semanticsLabel: 'QR Warehouse',
        width: width,
      ),
    );
    // return SvgPicture.asset(
    //   'assets/images/logo_white.svg',
    //   colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    //   width: width,
    // );
  }
}
