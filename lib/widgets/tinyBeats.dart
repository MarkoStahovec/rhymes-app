import 'package:flutter/cupertino.dart';
import 'package:neumorphism/constants.dart';
import 'dart:math';

class TinyBeats extends StatefulWidget {
  final bool isBorder;

  TinyBeats({
    this.isBorder = false,
  });

  @override
  _TinyBeatsState createState() {
    return _TinyBeatsState();
  }
}

class _TinyBeatsState extends State<TinyBeats> {
  late double MIN = 4.2;
  late int MAX = 11;
  late double randomSize = widget.isBorder ? (MIN) :
  ((Random().nextInt(MAX) + MIN + (Random().nextDouble()*8)).toDouble());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: randomSize,
      width: 4,
      margin: const EdgeInsets.all(defaultPadding / 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: altBeatGradient,
      ),
    );
  }
}