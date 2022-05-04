import 'package:flutter/cupertino.dart';
import 'package:neumorphism/constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import '../main.dart';
import 'beats.dart';

class Album extends StatefulWidget {
  final int size;

  Album({
    this.size = 25,
  });
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  @override
  Widget build(BuildContext context) {
    Offset offset = offsetNonPress;
    double blur = blurButton;

    return Container(
      height: MediaQuery.of(context).size.height * 0.01 * widget.size,
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
              spreadRadius: 3.0,
            ),
            BS.BoxShadow(
              color: isDarkMode ? darkRightShadow : lightRightShadow,
              offset: offset,
              blurRadius: blur,
              spreadRadius: 3.0,
            ),
          ]
      ),
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Beats(size: widget.size,),
              Beats(size: widget.size,),
              Beats(size: widget.size,),
              Beats(size: widget.size,),
              Beats(size: widget.size,),
              Beats(size: widget.size,),
            ]
        ),
      ),
    );
  }

}