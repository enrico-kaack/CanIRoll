import 'package:flutter/material.dart';

import 'dice_button.dart';

class ResizeableDice extends StatelessWidget {
  final int diceNumber;
  final Color color;
  final Size size;
  final bool printNumber;

  const ResizeableDice(this.diceNumber, this.color, this.size,
      {Key? key, this.printNumber = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: getPainterForDiceNumber(diceNumber, color, printNumber)!,
      size: size,
      willChange: false,
    );
  }
}

class ResizeableDiceWithCounterBadge extends StatelessWidget {
  final int diceNumber;
  final Color color;
  final Size size;
  final int count;

  const ResizeableDiceWithCounterBadge(
      this.diceNumber, this.color, this.size, this.count,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ResizeableDice(diceNumber, color, size),
        count > 1
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ThemeData.light().backgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "${count.toString()}x",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
