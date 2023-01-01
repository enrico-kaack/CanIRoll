import 'package:caniroll/dice.dart';
import 'package:caniroll/preset.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class StateModel extends ChangeNotifier {
  int _target = 11;
  int _modifier = 0;

  int get target => _target;
  int get modifier => _modifier;

  final List<Dice> _dices = [];

  List<Dice> get dices => _dices;

  double succesRate = 0.0;
  double get successPercentageRounded => (succesRate * 10000).round() / 100;
  double get failureRate => 1 - succesRate;
  double get failurePercentageRounded =>
      ((100 - successPercentageRounded) * 100).round() / 100;

  void refreshSuccessRate() async {
    if (_dices.isEmpty) {
      succesRate = 0;
      notifyListeners();
      return;
    }

    succesRate = calcSuccessRate(
        _dices.map((e) => e.value).toList(), _target, _modifier);
    notifyListeners();
  }

  double calcSuccessRate(List<int> dices, int target, int modifier) {
    int target = _target - modifier;

    var permutations =
        getRecursionPermutations(_dices.map((e) => e.value).toList());
    var matching = permutations
        .map((e) => e.reduce((value, element) => value + element))
        .where((element) => element >= target)
        .length;
    return matching / permutations.length;
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

  void setTarget(int target) {
    _target = target;
    notifyListeners();
    refreshSuccessRate();
  }

  void setModifier(int modifier) {
    _modifier = modifier;
    notifyListeners();
    refreshSuccessRate();
  }

  void addDice(int diceNumber) {
    //enforces dice limitation due to performance
    if (_dices.isNotEmpty &&
        _dices
                .map((e) => e.value)
                .reduce((value, element) => value * element) >=
            10e4) {
      return;
    }

    _dices.add(Dice(diceNumber));
    notifyListeners();
    refreshSuccessRate();
  }

  void deleteDice(String uuid) {
    _dices.removeWhere((element) => element.id == uuid);
    refreshSuccessRate();
  }

  void reset() {
    _target = 10;
    _modifier = 0;
    _dices.clear();
    refreshSuccessRate();
  }
}

class PresetStateModel extends ChangeNotifier {

  StateModel model;

  int _presetModifier = 0;
  String _presetName = "Preset";

  PresetStateModel(this.model);

  int get presetModifier => _presetModifier;
  String get presetName => _presetName;

  final List<Preset> _presets = [];

  List<Preset> get presets => _presets;

  void setPreset(){
    String defaultName = "";
    for (var d in model.dices) {
      defaultName = "${defaultName}d${d.value}+";
    }
    defaultName = "$defaultName${model.modifier}";
    _presetName = defaultName;
    notifyListeners();
  }

  void addPreset(){
    List<int> values = [];
    for (var d in model.dices) {
      values.add(d.value);
    }

    _presets.add(Preset(presetName, model.modifier, values));
    notifyListeners();
  }

  void deletePreset(String uuid) {
    _presets.removeWhere((element) => element.id == uuid);
    notifyListeners();
  }

}
