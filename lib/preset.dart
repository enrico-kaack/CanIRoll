import 'package:uuid/uuid.dart';
import 'package:caniroll/dice.dart';

class Preset {
  late String id;
  late String name;
  late int modifier;
  late List<Dice> dice;

  Preset(this.name, this.modifier, this.dice) {
    id = const Uuid().v4().toString();
  }

}