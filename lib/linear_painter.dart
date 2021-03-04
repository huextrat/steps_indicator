import 'package:flutter/widgets.dart';

/// Linear Painter to animate the step line with 2 colors
class LinearPainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double lineThickness;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  LinearPainter({
    required this.lineThickness,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  }) {
    _paintBackground.color = backgroundColor;
    _paintBackground.style = PaintingStyle.stroke;
    _paintBackground.strokeWidth = lineThickness;

    _paintLine.color = progress.toString() == '0.0'
        ? progressColor.withOpacity(0.0)
        : progressColor;
    _paintLine.style = PaintingStyle.stroke;
    _paintLine.strokeWidth = lineThickness;

    _paintLine.strokeCap = StrokeCap.butt;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, _paintBackground);

    final xProgress = size.width * progress;
    canvas.drawLine(start, Offset(xProgress, size.height / 2), _paintLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
