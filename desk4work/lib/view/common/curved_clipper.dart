import 'package:flutter/material.dart';

class CurvedClipper extends CustomClipper<Path>{
  final double _clipperHeight;


  CurvedClipper(this._clipperHeight);


  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(.0, _clipperHeight - 24.0);
    var leftControlPoint = Offset(size.width/4, _clipperHeight - 4.0);
    var startPoint = Offset(size.width/2.0, _clipperHeight - 2.0 );
    path.quadraticBezierTo(leftControlPoint.dx, leftControlPoint.dy, startPoint.dx, startPoint.dy);
    var rightControlPoint = Offset((size.width/4) * 3.0, _clipperHeight -4.0);
    var endPoint = Offset(size.width, _clipperHeight - 24.0);
    path.quadraticBezierTo(rightControlPoint.dx, rightControlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}