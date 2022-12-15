import 'package:caniroll/state.dart';
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
            dices.add(OutlinedButton(
                onPressed: () => model.deleteDice(d.id),
                child: Text("d${d.value}")));
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
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: dices,
                ),
              ),
              Row(
                children: [
                  DiceButton(() => model.addDice(4), 4),
                  DiceButton(() => model.addDice(6), 6),
                  DiceButton(() => model.addDice(8), 8),
                  DiceButton(() => model.addDice(10), 10),
                  OutlinedButton(
                    onPressed: () => model.addDice(12),
                    child: const Text("d12"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addDice(20),
                    child: const Text("d20"),
                  )
                ],
              ),
              const Text("Chances for success"),
              Text(model.successPercentageRounded.toString()),
              const Text("Chances for failure"),
              Text(model.failurePercentageRounded.toString()),
            ],
          );
        },
      ),
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
