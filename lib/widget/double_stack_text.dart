import 'package:flutter/material.dart';

class DoubleStackText extends StatelessWidget {
  final String first;
  final String second;

  const DoubleStackText(this.first, this.second, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            first,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 1,
            indent: 5,
            endIndent: 5,
            thickness: 3,
            color: Colors.black,
          ),
          Text(second),
        ],
      ),
    );
  }
}
