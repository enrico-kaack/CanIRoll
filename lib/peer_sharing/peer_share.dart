import 'dart:io';

import 'package:caniroll/peer_sharing/client.dart';
import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/discovery.dart';
import 'package:caniroll/peer_sharing/server.dart';

class PeerSharer {
  Server server = Server();
  Client client = Client();
  DiscoveryService discovery = DiscoveryService();
  List<Peer> peers = [];

  get id => Peer(Platform.localHostname, server.port!);

  late Function(PushData) newDataListener;
  late Function() notifyListener;
  PeerSharer();

  Future<void> start(Function(PushData) dataListenerCallback,
      Function() notifyListenerCallback) async {
    newDataListener = dataListenerCallback;
    notifyListener = notifyListenerCallback;
    server.startListeningServer(
        newDataListener,
        peerDiscoveredListener,
        () =>
            peers); //TODO probably wait till server is fully started and ready to accept connections
    await discovery
        .advertiseServiceToOtherDevices(server.port!); //TODO error handling
    await discovery.searchForDevices(peerDiscoveredListener);
  }

  Future<void> reset() async {
    await discovery.stopAdvertisingToOtherDevices();
    await discovery.stopSearchForDevice();
    server = Server();
    client = Client();
    discovery = DiscoveryService();
    peers = [];
    notifyListener();
  }

  Future<void> peerDiscoveredListener(Peer p) async {
    if (!peers.contains(p) &&
        server.port != null &&
        !p.hostname.contains(Platform.localHostname) &&
        p.port != server.port!) {
      print("new peer $p");
      peers.add(p);
      notifyListener();
      var receivedPeers = await client.sendHello(p, id);
      for (var r in receivedPeers) {
        await peerDiscoveredListener(r);
      }
    }
  }

  Future<void> broadCastUpdate(DiceWithSuccessRate data) async {
    for (var target in peers) {
      await client.sendPush(target, id, data);
    }
  }
}
