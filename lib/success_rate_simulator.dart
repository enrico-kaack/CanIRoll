import 'dart:isolate';

import 'package:flutter/foundation.dart';

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
    assert(dices.isNotEmpty);

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

  var permutationResponse = calcPermutationsForDices(data.dices, target);
  var matching = permutationResponse.removedPermutations;
  var allPermutationsCount = permutationResponse.permutations.length +
      permutationResponse.removedPermutations;

  var probability = matching / allPermutationsCount;
  data.sendPort.send({"successRate": probability});

  for (var d in [4, 6, 8, 10, 12, 20]) {
    var res = calcPermutationsForDices([d], target,
        permutations: permutationResponse.permutations,
        removedPermutations: permutationResponse.removedPermutations);
    data.sendPort.send({
      d.toString(): res.removedPermutations /
          (res.permutations.length + res.removedPermutations)
    });
  }
}

PermutationWithRemovedPermutations calcPermutationsForDices(
    List<int> dices, int normalisedTarget,
    {List<int> permutations = const [0], int removedPermutations = 0}) {
  for (var d in dices) {
    removedPermutations = removedPermutations * d;
    List<int> newPermutations = [];
    for (var p in permutations) {
      for (var val = 1; val <= d; val++) {
        var newPermutationValue = p + val;
        //dont add this permutation if it already fullfill the target
        if (newPermutationValue >= normalisedTarget) {
          removedPermutations++;
        } else {
          newPermutations.add(newPermutationValue);
        }
      }
    }
    permutations = newPermutations;
  }
  return PermutationWithRemovedPermutations(permutations, removedPermutations);
}

class PermutationWithRemovedPermutations {
  List<int> permutations;
  int removedPermutations;
  PermutationWithRemovedPermutations(
      this.permutations, this.removedPermutations);
}
