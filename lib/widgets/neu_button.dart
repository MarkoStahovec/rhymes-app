import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../main.dart';

class NeuButton extends StatefulWidget {
  NeuButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.textSize,
    required this.onPressed,
    required this.hasGradient,
    this.isWide = false,
    this.isChosen = false,
  }) : super(key: key);

  final bool hasGradient;
  final bool isWide;
  final bool isChosen;
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final double textSize;
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final squareSideLength = width / buttonSizeMultiplier;
    final buttonWidth = squareSideLength * (widget.isWide ? 2.2 : 1);
    final buttonSize = Size(buttonWidth, squareSideLength);

    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;

    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: Listener(
        onPointerUp: (_) => setState(() => isPressed = false),
        onPointerDown: (_) => setState(() => isPressed = true),
        child:
        AnimatedContainer(
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
              gradient: widget.hasGradient ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lightBackgroundColor,
                  gradientBottomButtonColor,
                ],
              ) : null,*/

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
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: widget.textSize / 1.25,
                fontWeight: FontWeight.w200,
                color: widget.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

}