import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ProbabilityGauge extends StatelessWidget {
  double probability;

  ProbabilityGauge(this.probability);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: CustomPaint(
        painter: ProbabilityGaugePainter(probability),
        willChange: false,
      ),
    );
  }
}

class ProbabilityGaugePainter extends CustomPainter {
  double successRate;

  ProbabilityGaugePainter(this.successRate);

  @override
  void paint(Canvas canvas, Size size) {
    const lineStartX = 40.0;
    const yDrawAreaStart = 50.0;
    final lineEndX = size.width - lineStartX;

    final lineWidth = lineEndX - lineStartX;

    final xMajorDivider = lineWidth / 10;
    const majorTickLength = 30.0;
    const minorTickLength = 20.0;

    drawTicks(lineStartX, yDrawAreaStart, xMajorDivider, majorTickLength,
        minorTickLength, canvas, size);

    drawSuccessRate(
        canvas, size, lineStartX, lineEndX, lineWidth, yDrawAreaStart);
  }

  void drawSuccessRate(Canvas canvas, Size size, double lineStartX,
      double lineEndX, double lineWidth, double yDrawAreaStart) {
    //paint the current success rate text
    var rectCenter =
        Offset(lineStartX + ((lineWidth / 100) * successRate), yDrawAreaStart);
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: successRate.toString(),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter = rectCenter.dx - textPainter.width / 2;
    final yCenter = 5 + textPainter.height / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

    //paint the colored line
    var progressLinePaint = Paint();
    progressLinePaint.style = PaintingStyle.stroke;
    progressLinePaint.strokeWidth = 6;
    progressLinePaint.shader = ui.Gradient.linear(
        Offset(lineStartX - 2, yDrawAreaStart),
        Offset(lineEndX + 2, yDrawAreaStart),
        [Colors.red, Colors.orange, Colors.yellow, Colors.green],
        [0.0, 0.3, 0.6, 0.8]);

    var linePathProgressLine = Path();
    linePathProgressLine.moveTo(lineStartX - 2, yDrawAreaStart);
    linePathProgressLine.lineTo(lineEndX + 2, yDrawAreaStart);
    canvas.drawPath(linePathProgressLine, progressLinePaint);

    //paint downwards arrow with colors from colored line
    var downArrowPath = Path();
    downArrowPath.moveTo(rectCenter.dx - 20, 5 + textPainter.height + 10);
    downArrowPath.lineTo(rectCenter.dx, yDrawAreaStart - 5);
    downArrowPath.lineTo(rectCenter.dx + 20, 5 + textPainter.height + 10);
    canvas.drawPath(downArrowPath, progressLinePaint);
  }

  void drawTicks(
      double lineStartX,
      double yDrawAreaStart,
      double xMajorDivider,
      double majorTickLength,
      double minorTickLength,
      Canvas canvas,
      Size size) {
    var majorTickPaint = Paint();
    majorTickPaint.style = PaintingStyle.stroke;
    majorTickPaint.color = const Color.fromARGB(255, 93, 93, 93);
    majorTickPaint.strokeWidth = 4;

    var minorTickPaint = Paint();
    minorTickPaint.style = PaintingStyle.stroke;
    minorTickPaint.color = const Color.fromARGB(255, 93, 93, 93);
    minorTickPaint.strokeWidth = 3;

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    for (var i = 0; i <= 10; i++) {
      var offsetX = i * xMajorDivider + lineStartX;
      var linePath = Path();
      linePath.moveTo(offsetX, yDrawAreaStart);
      linePath.lineTo(offsetX, yDrawAreaStart + majorTickLength);
      canvas.drawPath(linePath, majorTickPaint);

      //draw subdivision
      if (i < 10) {
        var minorTickStartX = offsetX;
        for (var minorTickI = 1; minorTickI < 5; minorTickI++) {
          var minorOffsetX = minorTickI * (xMajorDivider / 5) + minorTickStartX;
          var linePath = Path();
          linePath.moveTo(minorOffsetX, yDrawAreaStart);
          linePath.lineTo(minorOffsetX, yDrawAreaStart + minorTickLength);
          canvas.drawPath(linePath, minorTickPaint);
        }
      }
      final textSpan = TextSpan(
        text: (i * 10).toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      final xCenter = offsetX - textPainter.width / 2;
      final yCenter = yDrawAreaStart + majorTickLength;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant ProbabilityGaugePainter oldDelegate) {
    return successRate != oldDelegate.successRate;
  }
}
