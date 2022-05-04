import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../main.dart';

class NeuText extends StatefulWidget {
  NeuText({
    Key? key,
    required this.text,
    required this.textColor,
    required this.textSize,
    required this.onPressed,
    required this.fontWeight,
    this.isWide = false,
    this.isChosen = false,
  }) : super(key: key);

  final FontWeight fontWeight;
  final bool isWide;
  final bool isChosen;
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double textSize;
  _NeuTextState createState() => _NeuTextState();
}

class _NeuTextState extends State<NeuText> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height / 6,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: animationTime),
          decoration: BS.BoxDecoration(
            borderRadius: BorderRadius.circular(defRadius),
            gradient: LinearGradient(
              colors: isDarkMode ? [
                darkLeftBackgroundColor,
                darkRightBackgroundColor,
              ]
                  : [
                lightLeftBackgroundColor,
                lightRightBackgroundColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            /*
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientTopButtonColor,
                gradientBottomButtonColor,
              ],
            ),
            */
            boxShadow: [
              BS.BoxShadow(
                color: isDarkMode ? darkLeftShadow : Colors.white,
                offset: -offset,
                blurRadius: blur,
                spreadRadius: 0.0,
                inset: isPressed,
              ),
              BS.BoxShadow(
                color: isDarkMode ? darkRightShadow : lightRightShadow,
                offset: offset,
                blurRadius: blur,
                spreadRadius: 0.0,
                inset: isPressed,
              ),
            ]
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: Text(
            widget.text,
            //textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
              fontSize: widget.textSize / 1.25,
              fontWeight: widget.fontWeight,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}