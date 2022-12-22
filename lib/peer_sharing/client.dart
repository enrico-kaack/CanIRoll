import 'dart:convert';

import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/server.dart';

import 'package:http/http.dart' as http;

class Client {
  Future<List<Peer>> sendHello(Peer p, Peer id) async {
    var url = Uri.http(p.url, "/hello");
    print(url);
    try {
      var res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(id),
      );
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List)
            .map((e) => Peer.fromJson(e))
            .toList();
      } else {
        return []; //TODO better error handling, what if no response --> throw error and it will be ignored
      }
    } catch (e) {
      print("failed sending hello to $p: $e");
      return [];
    }
  }

  Future<void> sendPush(Peer target, Peer id, DiceWithSuccessRate data) async {
    var url = Uri.http(target.url, "/push");
    print(url);
    try {
      var res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(PushData(id, data)),
      );
    } catch (e) {
      print("failed sending push to $target: $e");
    }
    //TODO handle status code
  }
}
