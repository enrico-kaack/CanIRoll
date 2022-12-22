import 'dart:async';

import 'package:caniroll/peer_sharing/dice_with_success_rate.dart';
import 'package:caniroll/peer_sharing/server.dart';
import 'package:caniroll/widget/double_stack_text.dart';
import 'package:caniroll/widget/resizeable_dice.dart';
import 'package:flutter/material.dart';

class PeerResultViewer extends StatefulWidget {
  DiceWithSuccessRate data;
  Peer peer;
  DateTime lastUpdate;

  PeerResultViewer(this.data, this.peer, this.lastUpdate);

  @override
  State<PeerResultViewer> createState() => _PeerResultViewerState();
}

class _PeerResultViewerState extends State<PeerResultViewer> {
  late Timer t;

  _PeerResultViewerState() {
    t = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<int, int> compactedDices = {};
    widget.data.dices.sort((a, b) => a.compareTo(b));
    for (var d in widget.data.dices) {
      compactedDices.update(d, (value) => value + 1, ifAbsent: () => 1);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DoubleStackText(
                  widget.data.target.toString(),
                  widget.data.modifier > 0
                      ? "+${widget.data.modifier.toString()}"
                      : widget.data.modifier.toString()),
              Row(
                children: [
                  ...compactedDices.entries.map((e) =>
                      ResizeableDiceWithCounterBadge(
                          e.key, Colors.black, Size.square(40), e.value)),
                ],
              ),
              Text(
                "${(widget.data.successRate * 100.0).toStringAsPrecision(3)}%",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.peer.port.toString()),
              Text(
                  "${DateTime.now().difference(widget.lastUpdate).inMinutes}m ago")
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }
}
