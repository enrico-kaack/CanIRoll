import 'package:uuid/uuid.dart';

class Dice {
  late String id;
  late int value;

  Dice(this.value) {
    id = const Uuid().v4().toString();
  }
}
