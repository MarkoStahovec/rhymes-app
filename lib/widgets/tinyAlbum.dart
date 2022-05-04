import 'package:flutter/cupertino.dart';
import 'package:neumorphism/constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:neumorphism/widgets/tinyBeats.dart';
import '../main.dart';

class TinyAlbum extends StatefulWidget {
  @override
  _TinyAlbumState createState() => _TinyAlbumState();
}

class _TinyAlbumState extends State<TinyAlbum> {
  @override
  Widget build(BuildContext context) {
    Offset offset = offsetNonPress;
    double blur = blurButton;

    return Container(
      height: 80,
      //height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isDarkMode ? darkButtonGradient : lightButtonGradient,
          border: Border.all(
            width: defaultPadding / 4,
            color: isDarkMode ? darkBorderColor : lightBorderColor,
          ),
          boxShadow: [
            BS.BoxShadow(
              color: isDarkMode ? darkLeftShadow : lightLeftShadow,
              offset: -offset,
              blurRadius: blur,
              spreadRadius: 0.0,
            ),
            BS.BoxShadow(
              color: isDarkMode ? darkRightShadow : lightRightShadow,
              offset: offset,
              blurRadius: blur,
              spreadRadius: 0.0,
            ),
          ]
      ),
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TinyBeats(isBorder: true),
              TinyBeats(),
              TinyBeats(),
              TinyBeats(),
              TinyBeats(isBorder: true),
            ]
        ),
      ),
    );
  }

}