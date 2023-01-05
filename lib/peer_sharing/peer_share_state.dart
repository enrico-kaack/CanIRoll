import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer.dart';
import 'package:caniroll/peer_sharing/peer_share.dart';
import 'package:caniroll/peer_sharing/push_data.dart';
import 'package:flutter/material.dart';

class PeerShareStateModel extends ChangeNotifier {
  late PeerSharer peerSharer = PeerSharer(
    newDataListener,
    () => notifyListeners(),
  );

  Map<Peer, PeerState> peerData = {};

  Future<void> startServerAndDiscovery() async {
    await peerSharer.start();
    notifyListeners();
  }

  void newDataListener(PushData data) {
    var peerState = PeerState.receivedNow(data.data);
    peerData.update(data.id, (_) => peerState, ifAbsent: () => peerState);
    notifyListeners();
  }

  void broadcastData(DiceWithSuccessRate data) {
    peerSharer.broadCastUpdate(data);
  }

  Future<void> stopDiscovery() async {
    await peerSharer.discovery.stopAdvertisingToOtherDevices();
    await peerSharer.discovery.stopSearchForDevice();
    notifyListeners();
  }

  Future<void> toggleServerRunning() async {
    await peerSharer.toggleServerRunning();
    notifyListeners();
  }

  Future<void> toggleDiscovery() async {
    await peerSharer.toggleSearchForDevice();
    notifyListeners();
  }

  Future<void> toggleDiscoverable() async {
    await peerSharer.toggleAdvertiseServiceToOtherDevices();
    notifyListeners();
  }
}

class PeerState {
  DiceWithSuccessRate latestData;
  DateTime received;

  PeerState.receivedNow(this.latestData) : received = DateTime.now();
}
