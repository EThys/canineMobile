import 'package:canineappadmin/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../values/app_colors.dart';
import '../extensions.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.children,
    this.colors = AppColors.defaultGradient,
    super.key,
  });

  final List<Color> colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
        ),
        child: Stack(
          children: [
            // Add the background image here
            Positioned.fill(
              child: Image.asset(
                  Vectors.asyco, // Update with your image path
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.5), // Optional dark overlay
                colorBlendMode: BlendMode.darken, // Optional blend mode
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 130,left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: context.heightFraction(sizeFraction: 0.1),
                  ),
                  ...children,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100); // Adjust this value for curve height
    path.quadraticBezierTo(
      size.width / 2, // Control point x
      size.height + 50, // Control point y
      size.width, // End point x
      size.height - 100, // End point y
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
