import 'package:caniroll/dice.dart';
import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer_share_state.dart';
import 'package:caniroll/success_rate_simulator.dart';
import 'package:flutter/foundation.dart';

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

  Map<int, double> successRates = <int, double>{};

  SuccessRateCalculator calculator = SuccessRateCalculator();

  PeerShareStateModel _peerSharerStateModel;

  StateModel(this._peerSharerStateModel);

  void refreshSuccessRate() async {
    successRates = <int, double>{};

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
          default:
            var parsedDiceType = int.tryParse(typedElement.entries.first.key);
            if (parsedDiceType != null) {
              successRates.putIfAbsent(
                  parsedDiceType, () => typedElement.entries.first.value);
              notifyListeners();
            }
            break;
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
