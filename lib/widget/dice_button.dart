import 'package:flutter/material.dart';

class DiceButton extends StatelessWidget {
  Function() onPressed;
  int diceNumber;
  Color color;

  DiceButton(this.onPressed, this.diceNumber, this.color);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: CustomPaint(
        painter: getPainterForDiceNumber(diceNumber, color, true)!,
        size: const Size.square(60),
        willChange: false,
      ),
    );
  }
}

CustomPainter? getPainterForDiceNumber(
    int diceNumber, Color color, bool printNumber) {
  switch (diceNumber) {
    case 6:
      return CustomD6DicePainter(color, printNumber: printNumber);
    case 4:
      return CustomD4DicePainter(color, printNumber: printNumber);
    case 8:
      return CustomD8DicePainter(color, printNumber: printNumber);
    case 10:
      return CustomD10DicePainter(color, printNumber: printNumber);
    case 12:
      return CustomD12DicePainter(color, printNumber: printNumber);
    case 20:
      return CustomD20DicePainter(color, printNumber: printNumber);
    default:
      return null;
  }
}

class CustomD20DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD20DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;

    //inner figure, starting top left going clockwise
    List<List<double>> innerPoints = [
      [0.25, 0.4],
      [0.75, 0.4],
      [0.5, 0.8],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();

    var linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    for (var p in innerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    //outer points, starting top going clockwise
    List<List<double>> outerPoints = [
      [0.5, 0.0],
      [1, 0.25],
      [1, 0.75],
      [0.5, 1],
      [0, 0.75],
      [0.0, 0.25],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();
    linePath = Path();
    linePath.moveTo(outerPoints[0][0], outerPoints[0][1]);
    for (var p in outerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    linePath.lineTo(outerPoints[5][0], outerPoints[5][1]);
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    linePath.lineTo(outerPoints[4][0], outerPoints[4][1]);
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    linePath.lineTo(outerPoints[0][0], outerPoints[0][1]);

    linePath.moveTo(innerPoints[1][0], innerPoints[1][1]);
    linePath.lineTo(outerPoints[0][0], outerPoints[0][1]);
    linePath.moveTo(innerPoints[1][0], innerPoints[1][1]);
    linePath.lineTo(outerPoints[1][0], outerPoints[1][1]);
    linePath.moveTo(innerPoints[1][0], innerPoints[1][1]);
    linePath.lineTo(outerPoints[2][0], outerPoints[2][1]);

    linePath.moveTo(innerPoints[2][0], innerPoints[2][1]);
    linePath.lineTo(outerPoints[2][0], outerPoints[2][1]);
    linePath.moveTo(innerPoints[2][0], innerPoints[2][1]);
    linePath.lineTo(outerPoints[3][0], outerPoints[3][1]);
    linePath.moveTo(innerPoints[2][0], innerPoints[2][1]);
    linePath.lineTo(outerPoints[4][0], outerPoints[4][1]);

    canvas.drawPath(linePath, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: '20',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) * 0.52;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomD12DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD12DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;

    //inner figure, starting top going clockwise
    List<List<double>> innerPoints = [
      [0.5, 0.3],
      [0.7, 0.45],
      [0.6, 0.65],
      [0.4, 0.65],
      [0.3, 0.45],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();

    var linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    for (var p in innerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    //outer points, starting top going clockwise
    List<List<double>> outerPoints = [
      [0.5, 0.05],
      [0.75, 0.15],
      [0.9, 0.4],
      [0.91, 0.6],
      [0.75, 0.85],
      [0.5, 0.95],
      [0.25, 0.85],
      [0.09, 0.6],
      [0.1, 0.4],
      [0.25, 0.15],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();
    linePath = Path();
    linePath.moveTo(outerPoints[0][0], outerPoints[0][1]);
    for (var p in outerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    linePath.lineTo(outerPoints[0][0], outerPoints[0][1]);
    linePath.moveTo(innerPoints[1][0], innerPoints[1][1]);
    linePath.lineTo(outerPoints[2][0], outerPoints[2][1]);
    linePath.moveTo(innerPoints[2][0], innerPoints[2][1]);
    linePath.lineTo(outerPoints[4][0], outerPoints[4][1]);
    linePath.moveTo(innerPoints[3][0], innerPoints[3][1]);
    linePath.lineTo(outerPoints[6][0], outerPoints[6][1]);
    linePath.moveTo(innerPoints[4][0], innerPoints[4][1]);
    linePath.lineTo(outerPoints[8][0], outerPoints[8][1]);

    canvas.drawPath(linePath, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: '12',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) * 0.47;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomD10DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD10DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;

    //inner figure, starting top, going clockwise
    List<List<double>> innerPoints = [
      [0.5, 0],
      [0.7, 0.5],
      [0.5, 0.65],
      [0.3, 0.5],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();

    var linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    for (var p in innerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    //outer points, starting top, going clockwise
    List<List<double>> outerPoints = [
      [0.5, 0.0],
      [1.0, 0.6],
      [0.5, 1.0],
      [0.0, 0.6],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();
    linePath = Path();
    linePath.moveTo(outerPoints[0][0], outerPoints[0][1]);
    for (var p in outerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    //3 attaching traingles for 3d effect
    var linePath3D = Path();
    linePath3D.moveTo(innerPoints[1][0], innerPoints[1][1]);
    linePath3D.lineTo(outerPoints[1][0], outerPoints[1][1]);

    linePath3D.moveTo(innerPoints[2][0], innerPoints[2][1]);
    linePath3D.lineTo(outerPoints[2][0], outerPoints[2][1]);

    linePath3D.moveTo(innerPoints[3][0], innerPoints[3][1]);
    linePath3D.lineTo(outerPoints[3][0], outerPoints[3][1]);

    canvas.drawPath(linePath3D, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: '10',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 10 * 4.0;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomD8DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD8DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;

    //inner figure, starting top, going clockwise
    List<List<double>> innerPoints = [
      [0.5, 0],
      [1, 0.7],
      [0, 0.7],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();

    var linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    for (var p in innerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    //outer points, starting top, going clockwise
    List<List<double>> outerPoints = [
      [0.5, 0.0],
      [1.0, 0.3],
      [1.0, 0.7],
      [0.5, 1.0],
      [0, 0.7],
      [0, 0.3],
      [0.5, 0]
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();
    linePath = Path();
    linePath.moveTo(outerPoints[0][0], outerPoints[0][1]);
    for (var p in outerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 24,
      );
      final textSpan = TextSpan(
        text: '8',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) * 0.4;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomD6DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD6DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.color = color;

    var rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 28,
      );
      final textSpan = TextSpan(
        text: '6',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomD4DicePainter extends CustomPainter {
  Color color;
  bool printNumber;

  CustomD4DicePainter(this.color, {this.printNumber = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;

    List<List<double>> innerPoints = [
      [0.5, 0.1],
      [1, 0.9],
      [0, 0.9],
    ].map((e) => [e[0] * size.width, e[1] * size.height]).toList();

    var linePath = Path();
    linePath.moveTo(innerPoints[0][0], innerPoints[0][1]);
    for (var p in innerPoints) {
      linePath.lineTo(p[0], p[1]);
    }
    linePath.close();
    canvas.drawPath(linePath, paint);

    if (printNumber) {
      final textStyle = TextStyle(
        color: color,
        fontSize: 24,
      );
      final textSpan = TextSpan(
        text: '4',
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
      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2 + 5;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
