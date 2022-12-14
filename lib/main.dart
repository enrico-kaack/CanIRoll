import 'dart:typed_data';

import 'package:caniroll/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  OutlinedButton(
                    onPressed: () => model.addDice(4),
                    child: const Text("d4"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addDice(6),
                    child: const Text("d6"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addDice(8),
                    child: const Text("d8"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addDice(10),
                    child: const Text("d10"),
                  ),
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
              OutlinedButton(
                  onPressed: () => {
                    model.setModifier(model.presetModifier),
                    for (var d in model.presetDices){
                      model.addDice(d.value),
                    }
                  },
                  child: Text(model.presetName),
              ),
              Expanded(
                 child: Align(
                   alignment: FractionalOffset.bottomLeft,
                   child: OutlinedButton(
                     onPressed: ()  {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const Presets()),
                       );
                     },
                     child: Text("Presets"),
                   ),
                 ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class Presets extends StatelessWidget {
  const Presets({Key? key}) : super(key: key);

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
          for (var d in model.presetDices) {
            dices.add(OutlinedButton(
                onPressed: () => model.deletePresetDice(d.id),
                child: Text("d${d.value}")));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: "Preset Name",
                      contentPadding: EdgeInsets.all(10)),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: TextEditingController(
                      text: model.presetName.toString()),
                  onSubmitted: (value)  {
                    model.setPreset(value);
                  },
                ),
              ),
              NumberSwitchWidget(
                text: "Modifier",
                onChanged: (value) => model.setPresetModifier(value),
                min: -100,
                max: 100,
                value: model.presetModifier,
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
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(4),
                    child: const Text("d4"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(6),
                    child: const Text("d6"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(8),
                    child: const Text("d8"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(10),
                    child: const Text("d10"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(12),
                    child: const Text("d12"),
                  ),
                  OutlinedButton(
                    onPressed: () => model.addPresetDice(20),
                    child: const Text("d20"),
                  ),
                ],
              ),
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
