import 'package:flutter/material.dart';

class DestinationConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DestinationConnectorDots(),
      size: Size(20, 90),
    );
  }
}

class DestinationConnectorDots extends CustomPainter {
  final Color color;

  DestinationConnectorDots({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final double dotRadius = 6.0;
    final double lineX = size.width / 2;
    final double startY = dotRadius;
    final double endY = size.height - dotRadius - 20;

    //top dot setup
    final Paint topDotPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    //bottom dot setup
    final Paint bottomDotPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    //Dotted line setup
    final Paint dottedLinePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.square;

    final double dashWidth = 0.5; // Adjust the length of dashes
    final double dashSpace = 5.0; // Adjust the length of gaps

    // Define a custom dash pattern
    final List<double> dashPattern = <double>[dashWidth, dashSpace];

    dottedLinePaint.color = color;

    final double deltaY = endY - startY;
    final int segments = (deltaY / (dashWidth + dashSpace)).floor();

    double currentY = startY;
    for (int i = 0; i < segments; i++) {
      final double y1 = currentY;
      final double y2 = y1 + dashWidth;

      canvas.drawLine(Offset(lineX, y1), Offset(lineX, y2), dottedLinePaint);

      currentY = y2 + dashSpace;
    }

    canvas.drawCircle(Offset(lineX, startY), dotRadius, topDotPaint);
    canvas.drawCircle(Offset(lineX, endY), dotRadius, bottomDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // This painter doesn't change, so no need to repaint
  }
}