import 'dart:io';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peak/UI/components/abstract/themed_container.dart';
import 'package:peak/UI/components/components.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';

class NeumorphicContainer extends ThemedContainer {
  const NeumorphicContainer(Key? key, double width, double height, String text)
      : super(key: key, width: width, height: height, text: text);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(106, 103, 87, 122),
            offset: Offset(2, 2),
            blurRadius: 3,
            spreadRadius: 1,
            inset: true,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 254, 255, 255),
            offset: Offset(-2, -2),
            blurRadius: 3,
            spreadRadius: 1,
            inset: true,
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
