import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../main.dart';

class Labels extends StatefulWidget {
  final String trackname;

  Labels({
    required this.trackname,
  });
  @override
  _LabelsState createState() => _LabelsState();
}

class _LabelsState extends State<Labels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.12,
      child: Column(
        children: [
          Text(
            widget.trackname,
            style: GoogleFonts.poppins(
              fontSize: defTextSize * 1.3,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? darkMainTextColor : lightMainTextColor,
            ),
          ),
          const SizedBox(height: defaultPadding / 8,),
          Text(
            "Marko Stahovec",
            style: GoogleFonts.poppins(
              fontSize: defTextSize * 0.9,
              fontWeight: FontWeight.w400,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}