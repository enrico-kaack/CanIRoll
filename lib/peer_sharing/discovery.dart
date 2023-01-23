import 'dart:math';

import 'package:caniroll/peer_sharing/peer.dart';
import 'package:nsd/nsd.dart';

class DiscoveryService {
  Registration? _registration;
  Discovery? _discovery;

  bool get isDiscovering => _discovery != null;
  bool get isDiscoverable => _registration != null;

  int selfId = Random().nextInt(1 << 32);

  Future<void> searchForDevices(Function(Peer) newServiceListener) async {
    print("Discovery: start discovering");
    _discovery = await startDiscovery('_http._tcp');
    _discovery!.addServiceListener((service, status) {
      if (status == ServiceStatus.found &&
          service.name != null &&
          service.name!.contains("CanIRoll") &&
          service.host != null &&
          service.port != null) {
        if (service.name!.split("-").length == 2 &&
            service.name!.split("-").last != selfId.toString()) {
          print(
              "new peer service name ${service.name} with local seed $selfId");
          var peer = Peer(int.parse(service.name!.split("-").last),
              service.host!, service.port!);
          newServiceListener(peer);
        }
      }
    });
  }

  Future<void> stopSearchForDevice() async {
    if (_discovery != null) {
      print("Discovery: stop discovering");
      await stopDiscovery(_discovery!);
      _discovery = null;
    }
  }

  Future<void> advertiseServiceToOtherDevices(int port) async {
    print("Discovery: start advertising");
    _registration = await register(
        Service(name: 'CanIRoll-$selfId', type: '_http._tcp', port: port));
  }

  Future<void> stopAdvertisingToOtherDevices() async {
    if (_registration != null) {
      print("Discovery: stop advertising");
      await unregister(_registration!);
      _registration = null;
    }
  }
}
