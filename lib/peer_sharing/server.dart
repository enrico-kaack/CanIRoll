import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/push_data.dart';

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

    port = Random().nextInt(40000) + 10000;
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
