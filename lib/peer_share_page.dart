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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Provider.of<PeerShareStateModel>(context, listen: false)
                            .startServerAndDiscovery(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.dns,
                            color: model.peerSharer.server.isRunning
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black,
                          ),
                          model.peerSharer.server.port != null
                              ? Text(
                                  "Server\n on :${model.peerSharer.server.port ?? ""}",
                                  textAlign: TextAlign.center,
                                )
                              : const Text(
                                  "Server\nstopped",
                                  textAlign: TextAlign.center,
                                )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Provider.of<PeerShareStateModel>(context, listen: false)
                            .toggleDiscovery(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.manage_search,
                            color: model.peerSharer.discovery.isDiscovering
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black,
                          ),
                          model.peerSharer.discovery.isDiscovering
                              ? const Text(
                                  "Discovery\n running",
                                  textAlign: TextAlign.center,
                                )
                              : const Text(
                                  "Discovery\nstopped",
                                  textAlign: TextAlign.center,
                                )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Provider.of<PeerShareStateModel>(context, listen: false)
                            .toggleDiscoverable(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.podcasts,
                            color: model.peerSharer.discovery.isDiscoverable
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black,
                          ),
                          model.peerSharer.discovery.isDiscoverable
                              ? const Text(
                                  "Discoverable\n",
                                  textAlign: TextAlign.center,
                                )
                              : const Text(
                                  "Undiscoverable\n",
                                  textAlign: TextAlign.center,
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: model.peerSharer.peers
                      .map((e) => ListTile(
                            title: Text(e.id.toString()),
                            subtitle: Text(e.url),
                          ))
                      .toList(),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
