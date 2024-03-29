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
          if (model.peerSharer.server.hasEverRunBefore) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Provider.of<PeerShareStateModel>(context,
                              listen: false)
                          .toggleServerRunning(),
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
                            model.peerSharer.server.isRunning
                                ? Text(
                                    "Server\n on :${model.peerSharer.server.port}",
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
                      onTap: () => Provider.of<PeerShareStateModel>(context,
                              listen: false)
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
                      onTap: () => Provider.of<PeerShareStateModel>(context,
                              listen: false)
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
                    children: model.peerSharer.peerData.entries
                        .map((e) => ListTile(
                              title: Text(e.key.id.toString()),
                              subtitle: Text(e.key.url),
                              leading: Icon(Icons.circle_outlined,
                                  color: e.value.isActive
                                      ? Colors.greenAccent
                                      : Colors.blueGrey),
                            ))
                        .toList(),
                  ),
                )
              ],
            );
          } else {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/peer_share_symbol.png'),
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: const TextSpan(
                      text: """
Peer Share allows to share your current success rate calculation with your friends devices and see their calculations. 
Requires all devices to be connected to the same WiFi Network.
Press the button to start sharing with your friends devices in the same WiFi network.
                          """,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => model.startServerAndDiscovery(),
                  child: const Text("Start Peer Share"),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
