import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer_share.dart';
import 'package:caniroll/peer_sharing/server.dart';
import 'package:flutter/material.dart';

class PeerShareStateModel extends ChangeNotifier {
  late PeerSharer peerSharer = PeerSharer();

  Map<Peer, PeerState> peerData = {};

  Future<void> startServerAndDiscovery() async {
    await peerSharer.start(
      newDataListener,
      () => notifyListeners(),
    );
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
}

class PeerState {
  DiceWithSuccessRate latestData;
  DateTime received;

  PeerState.receivedNow(this.latestData) : received = DateTime.now();
}
