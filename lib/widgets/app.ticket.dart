import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AppTicketView extends StatelessWidget {
  final Widget child;
  final double radius;
  final double gap;

  const AppTicketView({
    Key? key,
    required this.child,
    this.radius = 10,
    this.gap = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketViewClipper(),
      child: child,
    );
  }
}

class TicketViewClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    // begin

    double x = 0;
    double y = size.height;
    double yControlPoint = size.height * .85;
    double increment = size.width / 12;

    while (x < size.width) {
      path.quadraticBezierTo(x + increment / 2, yControlPoint, x + increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);

    // while (x > 0) {
    //   path.quadraticBezierTo(x - increment / 2, size.height * .15, x - increment, 0);
    //   x -= increment;
    // }

    // end
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return oldClipper != this;
  }
}
