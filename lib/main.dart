
import 'dart:typed_data';
import 'package:caniroll/peer_share_page.dart';
import 'package:caniroll/peer_sharing/peer_share_state.dart';
import 'package:caniroll/probability_gauge.dart';
import 'package:caniroll/state.dart';
import 'package:caniroll/widget/dice_button.dart';
import 'package:caniroll/widget/dice_with_prediction.dart';
import 'package:caniroll/widget/peer_result_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caniroll/preset.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StateModel>(create: (context) => StateModel(),),
        ChangeNotifierProvider<PresetStateModel>(
          create: (context) => PresetStateModel(
              Provider.of<StateModel>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),),
    //ChangeNotifierProvider(
      //create: (context) => StateModel(),
      //child: const MyApp(),
    //),
        ChangeNotifierProvider<PeerShareStateModel>(
          create: (_) => PeerShareStateModel(),
        ),
        ChangeNotifierProvider<StateModel>(
          create: (context) => StateModel(
              Provider.of<PeerShareStateModel>(context, listen: false)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Can I roll?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        "/main": (context) => HomePage(),
        "/peershare": (context) => PeerSharePage(),
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    switch (state) {
      case AppLifecycleState.paused:
        Provider.of<PeerShareStateModel>(context, listen: false)
            .pauseServerAndDiscovery();
        break;
      case AppLifecycleState.resumed:
        Provider.of<PeerShareStateModel>(context, listen: false)
            .unpausePausedServer();
        break;
      default:
    }
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
              onPressed: () => {
                Provider.of<PresetStateModel>(context, listen: false).setPreset(),
              },
              icon: Icon(Icons.add),
          ),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, "/peershare"),
              icon: Icon(Icons.sync),
          ),
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

                Consumer<PresetStateModel>(
                  builder: (context, value, child) {
                    List<Widget> presets = [];
                    for (var p in Provider.of<PresetStateModel>(context, listen: false).presets) {
                      presets.add(OutlinedButton(
                          onPressed: () =>
                          {
                            model.reset(),
                            model.setFromPreset(p.modifier, p.dices),
                          },
                          onLongPress: () => Provider.of<PresetStateModel>(context, listen: false).deletePreset(p.id),
                          child: Text(p.name)));
                    }
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: presets,
                      ),
                    );
                  },
                ),
              ],
            );
        }
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                ],
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
              Consumer<PeerShareStateModel>(builder: (context, model, child) {
                return Expanded(
                  child: ListView(
                    children: [
                      ...model.peerSharer.peerData.entries
                          .where((element) => element.value.latestData != null)
                          .map((v) => PeerResultViewer(v.value.latestData!,
                              v.key, v.value.latestDataReceived!))
                    ],
                  ),
                );
              }),
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
          NumberPicker(
            itemHeight: 50.0,
            itemWidth: 150.0,
            axis: Axis.vertical,
            minValue: min,
            maxValue: max,
            value: value,
            textMapper: textMapper,
            onChanged: onChanged,
            haptics: true,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
