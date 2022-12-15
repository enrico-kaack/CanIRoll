import 'package:flutter/material.dart';

class DiceButton extends StatelessWidget {
  Function() onPressed;
  int diceNumber;

  DiceButton(this.onPressed, this.diceNumber);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: CustomPaint(
        painter: getPainterForDiceNumber(diceNumber)!,
        size: const Size.square(60),
        willChange: false,
      ),
    );
  }
}

CustomPainter? getPainterForDiceNumber(int diceNumber) {
  switch (diceNumber) {
    case 6:
      return CustomD6DicePainter();
    case 4:
      return CustomD4DicePainter();
    case 8:
      return CustomD8DicePainter();
    case 10:
      return CustomD10DicePainter();
    default:
      return null;
  }
}

class CustomD10DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;

    //inner figure
    var topX = size.width / 2;
    var topY = 10.0;
    var rightX = size.width - (size.width / 3);
    var rightY = (size.height / 10) * 4.5;
    var bottomX = topX;
    var bottomY = (size.height / 10) * 6.0;
    var leftX = (size.width / 3);
    var leftY = rightY;

    //outer points
    var outRightX = size.width - 10;
    var outRightY = (size.height / 10) * 5;
    var outBottomX = topX;
    var outBottomY = size.height - topY;
    var outLeftX = 10.0;
    var outLeftY = outRightY;

    //draw inner figure
    var linePath = Path();
    linePath.moveTo(topX, topY);
    linePath.lineTo(rightX, rightY);
    linePath.lineTo(bottomX, bottomY);
    linePath.lineTo(leftX, leftY);
    linePath.close();
    canvas.drawPath(linePath, paint);

    //3 attaching traingles for 3d effect
    var linePath3D = Path();
    linePath3D.moveTo(rightX, rightY);
    linePath3D.lineTo(outRightX, outRightY);
    linePath3D.lineTo(topX, topY);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    linePath3D.moveTo(bottomX, bottomY);
    linePath3D.lineTo(outBottomX, outBottomY);
    linePath3D.lineTo(outRightX, outRightY);
    linePath3D.lineTo(rightX, rightY);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    linePath3D.moveTo(bottomX, bottomY);
    linePath3D.lineTo(outBottomX, outBottomY);
    linePath3D.lineTo(outLeftX, outLeftY);
    linePath3D.lineTo(leftX, leftY);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    linePath3D.moveTo(leftX, leftY);
    linePath3D.lineTo(outLeftX, outLeftY);
    linePath3D.lineTo(topX, topY);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: '0',
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomD8DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.round;

    //base triangle
    var linePath = Path();
    linePath.moveTo(size.width / 2, 10);
    linePath.lineTo(10, size.height - 20);
    linePath.lineTo(size.width - 10, size.height - 20);
    linePath.lineTo(size.width / 2, 10);
    linePath.close();
    canvas.drawPath(linePath, paint);

    //3 attaching traingles for 3d effect
    var linePath3D = Path();
    linePath3D.moveTo(size.width / 2, 10);
    linePath3D.lineTo(size.width - 7, size.height / 2 - 5);
    linePath3D.lineTo(size.width - 10, size.height - 20);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    linePath3D.moveTo(size.width - 10, size.height - 20);
    linePath3D.lineTo(size.width / 2, size.height - 10);
    linePath3D.lineTo(10, size.height - 20);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    linePath3D.moveTo(10, size.height - 20);
    linePath3D.lineTo(7, size.height / 2 - 5);
    linePath3D.lineTo(size.width / 2, 10);
    linePath3D.close();
    canvas.drawPath(linePath3D, paint);

    final textStyle = TextStyle(
      color: Colors.black,
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
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter - 1);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomD4DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.miter;

    var linePath = Path();
    linePath.moveTo(size.width / 2, 10);
    linePath.lineTo(10, size.height - 10);
    linePath.lineTo(size.width - 10, size.height - 10);
    linePath.lineTo(size.width / 2, 10);
    linePath.close();

    canvas.drawPath(linePath, paint);

    final textStyle = TextStyle(
      color: Colors.black,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomD6DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    var rect = Rect.fromLTRB(10, 10, size.width - 10, size.height - 10);
    canvas.drawRect(rect, paint);

    final textStyle = TextStyle(
      color: Colors.black,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
