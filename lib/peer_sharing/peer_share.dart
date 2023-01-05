import 'dart:io';

import 'package:caniroll/peer_sharing/client.dart';
import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/discovery.dart';
import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/push_data.dart';
import 'package:caniroll/peer_sharing/server.dart';

class PeerSharer {
  late Server server;
  Client client = Client();
  DiscoveryService discovery = DiscoveryService();

  Set<Peer> peers = {};

  get id => Peer(discovery.selfId, Platform.localHostname, server.port!);

  late Function(PushData) newDataListener;
  late Function() notifyListener;
  PeerSharer(this.newDataListener, this.notifyListener) {
    server =
        Server(newDataListener, peerDiscoveredListener, () => peers.toList());
  }

  Future<void> start() async {
    await server.startListeningServer();
    await discovery.advertiseServiceToOtherDevices(server.port!);
    await discovery.searchForDevices(peerDiscoveredListener);
  }

  // reset stops server, discovery and discoverable and recreates a new session with new port and id
  Future<void> reset() async {
    await discovery.stopAdvertisingToOtherDevices();
    await discovery.stopSearchForDevice();
    await server.stop();
    server =
        Server(newDataListener, peerDiscoveredListener, () => peers.toList());
    client = Client();
    discovery = DiscoveryService();
    peers = {};
    notifyListener();
  }

  Future<void> peerDiscoveredListener(Peer p) async {
    if (server.port != null && !peerAlreadyKnown(p) && !isPeerSelf(p)) {
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

  Future<void> toggleServerRunning() async {
    if (server.isRunning) {
      await server.stop();
    } else {
      await start();
    }
  }

  Future<void> toggleSearchForDevice() async {
    if (discovery.isDiscovering) {
      await discovery.stopSearchForDevice();
    } else {
      await discovery.searchForDevices(peerDiscoveredListener);
    }
  }

  Future<void> toggleAdvertiseServiceToOtherDevices() async {
    if (discovery.isDiscoverable) {
      await discovery.stopAdvertisingToOtherDevices();
    } else if (server.isRunning) {
      await discovery.advertiseServiceToOtherDevices(server.port!);
    }
  }

  bool peerAlreadyKnown(Peer p) {
    return peers.any((element) => element == p);
  }

  bool isPeerSelf(Peer p) {
    return p.id == discovery.selfId;
  }
}
