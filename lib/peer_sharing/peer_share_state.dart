import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/peer_share.dart';
import 'package:flutter/material.dart';

class PeerShareStateModel extends ChangeNotifier {
  late PeerSharer peerSharer = PeerSharer(
    () => notifyListeners(),
  );

  Future<void> startServerAndDiscovery() async {
    await peerSharer.start();
    notifyListeners();
  }

  Future<void> unpausePausedServer() async {
    await peerSharer.unpauseServerIfPaused();
    notifyListeners();
  }

  Future<void> pauseServerAndDiscovery() async {
    await peerSharer.pauseServerAndDiscovery();
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
    await peerSharer.toggleServerAndHealthCheckRunning();
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
