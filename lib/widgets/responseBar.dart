import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../main.dart';

responseBar(String text, Color? color, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isDarkMode ? darkSnackbarColor : lightSnackbarColor,
      content: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: defTextSize * 0.7,
          fontWeight: FontWeight.w400,
          color: isDarkMode ? darkMainTextColor : lightMainTextColor,
        ),
      ),
    ),
  );
}