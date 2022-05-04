import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphism/main.dart';

import '../constants.dart';

class NeuIconButton extends StatefulWidget {
  NeuIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.secondaryIcon,
    required this.iconColor,
    this.isWide = false,
    this.isChosen = false,
  }) : super(key: key);

  final bool isWide;
  final bool isChosen;
  final VoidCallback onPressed;
  final Color iconColor;
  final IconData icon;
  final IconData secondaryIcon;
  _NeuIconButtonState createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
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
              /*
              border: Border.all(
                width: defaultPadding / 12,
                color: neutralBorderColor,
              ),*/
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
                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
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
            child: IconButton(
              color: widget.iconColor,
              onPressed: () {
              },
              icon: isDarkMode ? Icon(widget.icon) : Icon(widget.secondaryIcon),
            ),
          ),
        ),
      ),
    );
  }

}