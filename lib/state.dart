import 'package:caniroll/dice.dart';
import 'package:caniroll/preset.dart';
import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer_share_state.dart';
import 'package:caniroll/success_rate_simulator.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class StateModel extends ChangeNotifier {
  int _target = 11;
  int _modifier = 0;

  int get target => _target;
  int get modifier => _modifier;

  List<Dice> _dices = [];

  List<Dice> get dices => _dices;

  double succesRate = 0.0;
  double get successPercentageRounded => (succesRate * 10000).round() / 100;
  double get failureRate => 1 - succesRate;
  double get failurePercentageRounded =>
      ((100 - successPercentageRounded) * 100).round() / 100;


  double successRateNextD4 = 0.0;
  double successRateNextD6 = 0.0;
  double successRateNextD8 = 0.0;
  double successRateNextD10 = 0.0;
  double successRateNextD12 = 0.0;
  double successRateNextD20 = 0.0;

  SuccessRateCalculator calculator = SuccessRateCalculator();

  PeerShareStateModel _peerSharerStateModel;

  StateModel(this._peerSharerStateModel);
  
  void setFromPreset(int modifier, List<int> values) {
    _modifier = modifier;
    _dices = values.map((value) => Dice(value)).toList();
    notifyListeners();
  }


  void refreshSuccessRate() async {
    successRateNextD4 = 0.0;
    successRateNextD6 = 0.0;
    successRateNextD8 = 0.0;
    successRateNextD10 = 0.0;
    successRateNextD12 = 0.0;
    successRateNextD20 = 0.0;

    if (_dices.isEmpty) {
      succesRate = 0;
      notifyListeners();
      return;
    }

    calcSuccessRate(_dices.map((e) => e.value).toList(), _target, _modifier);
  }

  Future<void> calcSuccessRate(
      List<int> dices, int target, int modifier) async {
    var resultStream = await calculator.runSuccessRateCalculationAndSimulation(
        dices, target, modifier);
    resultStream.forEach((element) {
      if (element is Map<String, double>) {
        var typedElement = element as Map<String, double>;
        switch (typedElement.entries.first.key) {
          case "successRate":
            succesRate = typedElement.entries.first.value;
            _peerSharerStateModel.broadcastData(
                DiceWithSuccessRate(target, modifier, dices, succesRate));
            notifyListeners();
            break;
          case "4":
            successRateNextD4 = typedElement.entries.first.value;
            notifyListeners();
            break;
          case "6":
            successRateNextD6 = typedElement.entries.first.value;
            notifyListeners();
            break;
          case "8":
            successRateNextD8 = typedElement.entries.first.value;
            notifyListeners();
            break;
          case "10":
            successRateNextD10 = typedElement.entries.first.value;
            notifyListeners();
            break;
          case "12":
            successRateNextD12 = typedElement.entries.first.value;
            notifyListeners();
            break;
          case "20":
            successRateNextD20 = typedElement.entries.first.value;
            notifyListeners();
            break;
          default:
        }
      }
    });
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
    _dices.add(Dice(diceNumber));
    notifyListeners();
    refreshSuccessRate();
  }

  void deleteDice(String uuid) {
    _dices.removeWhere((element) => element.id == uuid);
    refreshSuccessRate();
  }

  void reset() {
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

  List<Preset> _presets = [];

  List<Preset> get presets => _presets;

  set presets(List<Preset> value) {
    _presets = value;
    notifyListeners();
  }

  void setPreset(){
    String defaultName = "";
    List<int> values = [];
    for (var d in model.dices) {
      defaultName = "${defaultName}d${d.value}+";
      values.add(d.value);
    }
    defaultName = "$defaultName${model.modifier}";
    _presetName = defaultName;
    _presets.add(Preset(presetName, model.modifier, values));

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList("presets", _presets.map((p) => p.name).toList());
    });

    notifyListeners();
  }


  void deletePreset(String uuid) {
    _presets.removeWhere((element) => element.id == uuid);
    notifyListeners();
  }

}
