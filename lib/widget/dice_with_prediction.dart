import 'package:caniroll/widget/dice_button.dart';
import 'package:flutter/material.dart';

class DiceWithSuccessRatePrediction extends StatelessWidget {
  final int diceValue;
  final double successRate;
  final Function() function;

  const DiceWithSuccessRatePrediction(
      this.diceValue, this.function, this.successRate,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        DiceButton(function, diceValue, Colors.black),
        successRate.isFinite && successRate > 0.0
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ThemeData.light().backgroundColor,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      (successRate * 100).toStringAsPrecision(3),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            : Container(),
      ],
    );
  }
}
