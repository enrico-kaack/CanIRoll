import 'dart:isolate';

import 'package:flutter/foundation.dart';

class SuccesRateSimulatorInput {
  int additionalDice;
  List<List<int>> existingPermutations;
  int target;
  int modifier;

  SuccesRateSimulatorInput(this.additionalDice, this.existingPermutations,
      this.target, this.modifier);
}

Future<double> asyncSuccessRateSimulation(SuccesRateSimulatorInput data) async {
  return compute<SuccesRateSimulatorInput, double>(
      simulateSuccessRateWithAdditionalDice, data);
}

class SuccessRateCalculationInput {
  List<int> dices;
  int target;
  int modifier;
  SendPort sendPort;

  SuccessRateCalculationInput(
      this.dices, this.target, this.modifier, this.sendPort);
}

class SuccessRateCalculator {
  Isolate? isolate;

  Future<Stream> runSuccessRateCalculationAndSimulation(
      List<int> dices, int target, int modifier) async {
    //kill existing calculation
    if (isolate != null) {
      isolate!.kill(priority: Isolate.immediate);
    }

    ReceivePort myReceivePort = ReceivePort();
    var input = SuccessRateCalculationInput(
        dices, target, modifier, myReceivePort.sendPort);

    isolate = await Isolate.spawn<SuccessRateCalculationInput>(
        isolateCalcSuccessRateAndSimulate, input);
    return myReceivePort;
  }
}

void isolateCalcSuccessRateAndSimulate(SuccessRateCalculationInput data) {
  int target = data.target - data.modifier;

  var permutations = getRecursionPermutations(data.dices);
  var matching = permutations
      .map((e) => e.reduce((value, element) => value + element))
      .where((element) => element >= target)
      .length;

  var probability = matching / permutations.length;
  data.sendPort.send({"successRate": probability});

  for (var d in [4, 6, 8, 10, 12, 20]) {
    var input =
        SuccesRateSimulatorInput(d, permutations, data.target, data.modifier);
    var simulatedSuccessRate = simulateSuccessRateWithAdditionalDice(input);
    data.sendPort.send({d.toString(): simulatedSuccessRate});
  }
}

List<List<int>> getRecursionPermutations(List<int> dices) {
  List<List<int>> possibilities = [];
  if (dices.length == 1) {
    for (var i = 1; i <= dices.first; i++) {
      possibilities.add([i]);
    }
    return possibilities;
  }

  var listForRecursion = dices.sublist(1);
  var otherPosibilities = getRecursionPermutations(listForRecursion);
  for (var i = 1; i <= dices.first; i++) {
    List<List<int>> newComibnations = [];
    for (var others in otherPosibilities) {
      var newCombination = [...others];
      newCombination.add(i);
      newComibnations.add(newCombination);
    }
    possibilities.addAll(newComibnations);
  }
  return possibilities;
}

double simulateSuccessRateWithAdditionalDice(SuccesRateSimulatorInput data) {
  int target = data.target - data.modifier;

  var permutations = simulateRecursionsWithAdditionalDice(
      data.additionalDice, data.existingPermutations);
  var matching = permutations
      .map((e) => e.reduce((value, element) => value + element))
      .where((element) => element >= target)
      .length;
  return matching / permutations.length;
}

List<List<int>> simulateRecursionsWithAdditionalDice(
    int dice, List<List<int>> existingPermutations) {
  List<List<int>> possibilities = [];
  for (var i = 1; i <= dice; i++) {
    List<List<int>> newComibnations = [];
    for (var others in existingPermutations) {
      var newCombination = [...others];
      newCombination.add(i);
      newComibnations.add(newCombination);
    }
    possibilities.addAll(newComibnations);
  }
  return possibilities;
}
