import 'dart:async';
import 'dart:io';

import 'package:caniroll/peer_sharing/client.dart';
import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/discovery.dart';
import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/push_data.dart';
import 'package:caniroll/peer_sharing/server.dart';

class PeerSharer {
  late Server server;
  late Client client;
  DiscoveryService discovery = DiscoveryService();

  get peers => peerData.keys;
  Map<Peer, PeerState> peerData = {};

  get id => Peer(discovery.selfId, Platform.localHostname, server.port!);

  late Function() notifyListener;

  Timer? _timer;

  PeerSharer(this.notifyListener) {
    server = Server(dataReceivedListener, peerDiscoveredListener,
        () => peers.toList(), peerHealthyListener);
    client = Client(peerHealthyListener);
    healthChecker();
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
    server = Server(dataReceivedListener, peerDiscoveredListener,
        () => peers.toList(), peerHealthyListener);
    client = Client(peerHealthyListener);
    discovery = DiscoveryService();
    peerData = {};
    notifyListener();
  }

  Future<void> healthChecker() async {
    _timer = Timer.periodic(
      const Duration(seconds: 20),
      (timer) {
        for (var p in peers) {
          client.sendHealthCheck(p, id, peers.toList());
        }
        notifyListener();
      },
    );
  }

  Future<void> dataReceivedListener(PushData data) async {
    var peerState = PeerState.receivedNow(data.data);
    peerData.update(data.id, (value) {
      value.latestData = data.data;
      value.latestDataReceived = DateTime.now();
      return value;
    }, ifAbsent: () => PeerState.receivedNow(data.data));
    notifyListener();
  }

  Future<void> peerHealthyListener(Peer p) async {
    peerData.update(
      p,
      (value) {
        value.receivedHealthyNow();
        return value;
      },
      ifAbsent: () => PeerState.healthyNow(),
    );
    notifyListener();
  }

  Future<void> peerDiscoveredListener(Peer p) async {
    if (server.port != null && !peerAlreadyKnown(p) && !isPeerSelf(p)) {
      print("new peer $p");
      peerData.putIfAbsent(p, () => PeerState());
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

class PeerState {
  DiceWithSuccessRate? latestData;
  DateTime? latestDataReceived;
  late DateTime lastHealthy;

  Duration get timeSinceLastHealthy => DateTime.now().difference(lastHealthy);
  bool get isActive => timeSinceLastHealthy.abs().inSeconds < 60;

  PeerState.receivedNow(this.latestData)
      : latestDataReceived = DateTime.now(),
        lastHealthy = DateTime.now();

  PeerState.healthyNow() : lastHealthy = DateTime.now();

  PeerState() {
    lastHealthy = DateTime.fromMillisecondsSinceEpoch(0);
  }

  void receivedHealthyNow() {
    lastHealthy = DateTime.now();
  }
}
