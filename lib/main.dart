import 'package:caniroll/probability_gauge.dart';
import 'package:caniroll/state.dart';
import 'package:caniroll/success_rate_simulator.dart';
import 'package:caniroll/widget/dice_button.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StateModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Can I roll?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Can I roll?"),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<StateModel>(context, listen: false).reset(),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Consumer<StateModel>(
        builder: (context, model, child) {
          List<Widget> dices = [];
          for (var d in model.dices) {
            dices.add(
                DiceButton(() => model.deleteDice(d.id), d.value, Colors.blue));
          }

          return Column(
            children: <Widget>[
              NumberSwitchWidget(
                text: "Target",
                min: 0,
                max: 100,
                value: model.target,
                onChanged: (value) => model.setTarget(value),
              ),
              NumberSwitchWidget(
                text: "Modifier",
                onChanged: (value) => model.setModifier(value),
                min: -100,
                max: 100,
                value: model.modifier,
                textMapper: (v) => double.parse(v) >= 0 ? "+" + v : v,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 60,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: dices,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 65,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DiceWithSuccessRatePrediction(
                        4, () => model.addDice(4), model.successRateNextD4),
                    DiceWithSuccessRatePrediction(
                        6, () => model.addDice(6), model.successRateNextD6),
                    DiceWithSuccessRatePrediction(
                        8, () => model.addDice(8), model.successRateNextD8),
                    DiceWithSuccessRatePrediction(
                        10, () => model.addDice(10), model.successRateNextD10),
                    DiceWithSuccessRatePrediction(
                        12, () => model.addDice(12), model.successRateNextD12),
                    DiceWithSuccessRatePrediction(
                        20, () => model.addDice(20), model.successRateNextD20),
                  ],
                ),
              ),
              ProbabilityGauge(model.successPercentageRounded),
            ],
          );
        },
      ),
    );
  }
}

class DiceWithSuccessRatePrediction extends StatelessWidget {
  int diceValue;
  double successRate;
  Function() function;

  DiceWithSuccessRatePrediction(
      this.diceValue, this.function, this.successRate);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        DiceButton(function, diceValue, Colors.black),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: ThemeData.light().backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: successRate.isFinite && successRate > 0.0
                ? Text(
                    (successRate * 100).toStringAsPrecision(3),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        )
      ],
    );
  }
}

class NumberSwitchWidget extends StatelessWidget {
  final String text;
  final int value;
  final int min;
  final int max;
  Function(int value) onChanged;
  String Function(String)? textMapper;
  NumberSwitchWidget(
      {Key? key,
      required this.text,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged,
      this.textMapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(text),
          NumberPicker(
            itemHeight: 100.0,
            axis: Axis.horizontal,
            minValue: min,
            maxValue: max,
            value: value,
            textMapper: textMapper,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
