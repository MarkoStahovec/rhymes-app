import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//const Color lightRightBackgroundColor = Color(0xFFEFF6F8);
const Color lightRightBackgroundColor = Color(0xFFE3EDF7);
const Color lightLeftBackgroundColor = Color(0xFFEFF8FE);
const Color darkRightBackgroundColor = Color(0xFF2F333B);
const Color darkLeftBackgroundColor = Color(0xFF202328);

const Color lightLeftShadow = Color(0xFFFAFAFA);
const Color darkLeftShadow = Color(0xFF35393F);

const Color lightRightShadow = Color(0xFFC7C9CF);
const Color darkRightShadow = Color(0xFF1D1F22);

//const Color mainButtonColor = Color(0xFFb95eea);
//const Color secondaryButtonColor = Color(0xFF8A82EC);
const Color mainButtonColor = Color(0xFFfc427b);
const Color secondaryButtonColor = Color(0xFF8854d0);
const Color darkButtonColor = Color(0xFF1A122C);
const Color lightButtonColor = Color(0xFFFFFFFF);
const Color neutralButtonColor = Color(0xFFB2B5D2);
const Color altButtonColor = Color(0xFFce6ab6);

const Color lightBorderColor = Color(0xFFDEE8F2);
const Color neutralBorderColor = Color(0xFFDEE8F2);
const Color darkBorderColor = Color(0xFF2F333B);

const Color lightMainTextColor = Color(0xFF3A3A5A);
const Color darkMainTextColor = Color(0xFFE2EAF6);
const Color secondaryTextColor = Color(0xFFA2A5C2);

const Color lightSnackbarColor = Color(0xFFE4EFF8);
const Color darkSnackbarColor = Color(0xFF15181D);



Gradient darkButtonGradient = LinearGradient(colors: [
  Colors.black.withOpacity(0.7),
  darkButtonColor,
],
begin: Alignment.centerLeft,
end: Alignment.centerRight,);

Gradient lightButtonGradient = LinearGradient(colors: [
  Colors.white.withOpacity(0.7),
  neutralButtonColor,
],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,);

Gradient beatGradient = LinearGradient(colors: [
  mainButtonColor,
  secondaryButtonColor,
],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,);

Gradient altBeatGradient = LinearGradient(colors: [
  mainButtonColor,
  altButtonColor,
],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,);


const defaultPadding = 16.0;
Offset offsetPress = const Offset(6, 6);
Offset offsetNonPress = const Offset(5, 5);
double blurButton = 5.0;

const animationTime = 200;
const defRadius = 20.0;
const defTextSize = 20.0;
const buttonSizeMultiplier = 6.4;