import 'package:flutter/material.dart';

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double step = 8.0;

    // Zigzag at the top
    path.moveTo(0, 0);
    double x = 0;
    double y = 0;
    bool up = false;

    while (x < size.width) {
      x += step;
      if (x > size.width) x = size.width;
      y = up ? 0 : 6.0;
      path.lineTo(x, y);
      up = !up;
    }

    // Right side
    path.lineTo(size.width, size.height);

    // Zigzag at the bottom
    x = size.width;
    up = true;
    while (x > 0) {
      x -= step;
      if (x < 0) x = 0;
      y = up ? size.height - 6.0 : size.height;
      path.lineTo(x, y);
      up = !up;
    }

    // Left side
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
