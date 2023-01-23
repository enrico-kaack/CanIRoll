class DiceWithSuccessRate {
  int target;
  int modifier;
  List<int> dices;
  double successRate;

  DiceWithSuccessRate(this.target, this.modifier, this.dices, this.successRate);

  DiceWithSuccessRate.fromJson(Map<String, dynamic> json)
      : target = json["target"],
        modifier = json["modifier"],
        dices = (json["dices"] as List).map((e) => e as int).toList(),
        successRate = json["successRate"];

  Map<String, dynamic> toJson() => {
        "target": target,
        "modifier": modifier,
        "dices": dices,
        "successRate": successRate
      };
}
