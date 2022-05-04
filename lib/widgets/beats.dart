import 'package:flutter/cupertino.dart';
import 'package:neumorphism/constants.dart';
import 'dart:math';

class Beats extends StatefulWidget {
  final int size;

  Beats({
    this.size = 25,
  });
  @override
  _BeatsState createState() => _BeatsState();
}

class _BeatsState extends State<Beats> {
  late int MIN = 2;
  late int MAX = 12;
  late num randomSize = ((Random().nextInt(MAX) + MIN).toDouble()) / 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * randomSize * widget.size / 25,
      width: 5,
      margin: const EdgeInsets.all(defaultPadding / 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: beatGradient,
      ),
    );
  }
}