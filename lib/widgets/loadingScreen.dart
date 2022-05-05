import 'package:flutter/material.dart';

import '../constants.dart';

Widget linearLoadingScreen(bool _isloading) {
  return _isloading ? Container(
    alignment: Alignment.topCenter,
    child: const LinearProgressIndicator(
      color: mainButtonColor,
      backgroundColor: neutralButtonColor,
    ),
  ): const SizedBox.shrink();
}