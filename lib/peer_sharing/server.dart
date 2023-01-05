import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/push_data.dart';

class Server {
  bool get isRunning => _server != null;
  int port = Random().nextInt(40000) + 10000;

  HttpServer? _server;

  late Function(PushData) newDataListener;
  late Function(Peer) peerListener;
  late List<Peer> Function() getPeerList;

  Server(this.newDataListener, this.peerListener, this.getPeerList);

  Future<void> startListeningServer() async {
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port!);
    print("Server running on IP : " +
        _server!.address.toString() +
        " On Port : " +
        _server!.port.toString());
    handleRequests();
  }

  Future<void> handleRequests() async {
    await for (var request in _server!) {
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

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
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
