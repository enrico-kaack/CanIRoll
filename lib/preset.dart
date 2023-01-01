import 'package:uuid/uuid.dart';

class Preset {
  late String id;
  late String name;
  late int modifier;
  late List<int> dices;

  Preset(this.name, this.modifier, this.dices) {
    id = const Uuid().v4().toString();
  }

}