import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer.dart';

class PushData {
  Peer id;
  DiceWithSuccessRate data;

  PushData(this.id, this.data);
  PushData.fromJson(Map<String, dynamic> json)
      : id = Peer.fromJson(json["id"]),
        data = DiceWithSuccessRate.fromJson(json["data"]);

  Map<String, dynamic> toJson() => {"id": id.toJson(), "data": data.toJson()};
}
