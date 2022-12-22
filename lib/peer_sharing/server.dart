import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';

class Server {
  bool isRunning = false;
  int? port;

  late Function(PushData) newDataListener;
  late Function(Peer) peerListener;
  late List<Peer> Function() getPeerList;

  Server();

  Future<void> startListeningServer(Function(PushData) newDataListener,
      Function(Peer) newPeerListener, List<Peer> Function() getPeerList) async {
    this.newDataListener = newDataListener;
    peerListener = newPeerListener;
    this.getPeerList = getPeerList;

    port ??= Random().nextInt(40000) + 10000;
    var server = await HttpServer.bind(InternetAddress.anyIPv4, port!);
    print("Server running on IP : " +
        server.address.toString() +
        " On Port : " +
        server.port.toString());
    isRunning = true;

    await for (var request in server) {
      print("received request ${request.requestedUri.path}");
      switch (request.method) {
        case "POST":
          switch (request.requestedUri.path) {
            case "/hello":
              await handleHello(request);
              break;
            case "/push":
              await handlePush(request);
              break;
            default:
              request.response
                ..statusCode = 404
                ..close();
          }

          break;
        default:
      }
    }
  }

  Future<void> handleHello(HttpRequest req) async {
    try {
      String content = await utf8.decoder.bind(req).join();
      var data = Peer.fromJson(jsonDecode(content));
      peerListener(data);
      req.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(getPeerList()))
        ..close();
    } catch (e) {
      req.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Exception: $e.')
        ..close();
    }
  }

  Future<void> handlePush(HttpRequest req) async {
    try {
      String content = await utf8.decoder.bind(req).join();
      print("received data $content");
      var data = PushData.fromJson(jsonDecode(content));
      peerListener(data.id);
      newDataListener(data);
      req.response
        ..statusCode = HttpStatus.ok
        ..close();
    } catch (e) {
      req.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Exception: $e.')
        ..close();
    }
  }
}

class Peer {
  String hostname;
  int port;

  get url => "$hostname:$port";

  Peer(this.hostname, this.port);

  Peer.fromJson(Map<String, dynamic> json)
      : hostname = json["host"],
        port = json["port"];

  Map<String, dynamic> toJson() => {"host": hostname, "port": port};

  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Peer && other.hostname == hostname && other.port == port;
  }

  @override
  int get hashCode => Object.hash(hostname, port);

  @override
  String toString() {
    return url;
  }
}

class PushData {
  Peer id;
  DiceWithSuccessRate data;

  PushData(this.id, this.data);
  PushData.fromJson(Map<String, dynamic> json)
      : id = Peer.fromJson(json["id"]),
        data = DiceWithSuccessRate.fromJson(json["data"]);

  Map<String, dynamic> toJson() => {"id": id.toJson(), "data": data.toJson()};
}
