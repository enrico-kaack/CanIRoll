import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/push_data.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class Client {
  Future<List<Peer>> sendHello(Peer p, Peer id) async {
    var url = Uri.http(p.url, "/hello");
    print(url);
    final httpClient = HttpClient();
    httpClient.connectionTimeout = const Duration(seconds: 10);
    final client = IOClient(httpClient);
    Response res;
    try {
      res = await client.post(
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
    } on TimeoutException catch (e) {
      print("Timeout: failed sending hello to $p: $e");
      return [];
    } catch (e) {
      print("failed sending hello to $p: $e");
      return [];
    }
  }

  Future<void> sendPush(Peer target, Peer id, DiceWithSuccessRate data) async {
    var url = Uri.http(target.url, "/push");
    print(url);
    final httpClient = HttpClient();
    httpClient.connectionTimeout = const Duration(seconds: 10);
    final client = IOClient(httpClient);
    Response res;
    try {
      res = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(PushData(id, data)),
      );
    } on TimeoutException catch (e) {
      print("Timeout: failed sending push to $target: $e");
    } catch (e) {
      print("failed sending push to $target: $e");
    }
    //TODO handle status code --> handle peer as unresponsive and remove later
  }
}
