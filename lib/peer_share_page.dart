import 'package:caniroll/peer_sharing/peer_share_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeerSharePage extends StatelessWidget {
  const PeerSharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<PeerShareStateModel>(context, listen: false)
            .stopDiscovery();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Peer Share"),
        ),
        body: Consumer<PeerShareStateModel>(builder: (context, model, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Start Server & Discovery'),
                onPressed: () =>
                    Provider.of<PeerShareStateModel>(context, listen: false)
                        .startServerAndDiscovery(),
              ),
              ElevatedButton(
                child: const Text('Stop Discovery/being Discoverable'),
                onPressed: () =>
                    Provider.of<PeerShareStateModel>(context, listen: false)
                        .stopDiscovery(),
              ),
              Text(
                  "Network Service Discovery discovering running: ${model.peerSharer.discovery.isDiscovering.toString()}"),
              Text(
                  "Network Service Discovery discoverable: ${model.peerSharer.discovery.isDiscoverable.toString()}"),
              Text(
                  "Server running: ${model.peerSharer.server.isRunning.toString()} on port ${model.peerSharer.server.port.toString()}"),
              ...model.peerSharer.peers.map((e) => Text(e.toString())).toList(),
            ],
          );
        }),
      ),
    );
  }
}
