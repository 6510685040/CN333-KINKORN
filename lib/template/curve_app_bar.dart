import 'package:flutter/material.dart';

class CurveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  const CurveAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFFB71C1C),
    this.textColor = const Color(0xFFFCF9CA),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: 300,
              color: backgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(300);
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Start point
    path.lineTo(0, size.height * 0.75);

    // First smooth curve up
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.75,
      size.width * 0.25,
      size.height * 0.55,
      size.width * 0.5,
      size.height * 0.55,
    );

    // Second smooth curve down
    path.cubicTo(
      size.width * 0.75,
      size.height * 0.55,
      size.width * 0.95,
      size.height * 0.75,
      size.width,
      size.height * 0.75,
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
