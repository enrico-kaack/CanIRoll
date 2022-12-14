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
    default:
      return null;
  }
}

class CustomD8DicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.strokeJoin = StrokeJoin.miter;

    //base triangle
    var linePath = Path();
    linePath.moveTo(size.width / 2, 10);
    linePath.lineTo(10, size.height - 10);
    linePath.lineTo(size.width - 10, size.height - 10);
    linePath.lineTo(size.width / 2, 10);
    linePath.close();
    canvas.drawPath(linePath, paint);

    //3 attaching traingles for 3d effect
    var linePath3D = Path();
    linePath.moveTo(size.width / 2, 10);

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
    final offset = Offset(xCenter, yCenter);
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
    final yCenter = (size.height - textPainter.height) / 2;
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
