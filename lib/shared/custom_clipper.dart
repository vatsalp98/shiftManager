import 'dart:math' as math;

import 'package:flutter/material.dart';

class DrawClip extends CustomClipper<Path> {
  double move;
  DrawClip(this.move);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xMid =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * math.pi);
    double yMid = size.height * 0.8 + 50 * math.cos(move * math.pi);
    path.quadraticBezierTo(xMid, yMid, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
