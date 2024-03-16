import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/services/database_service/firebase_db_service.dart';
import 'package:peak/services/logger/logger.dart';
import 'package:peak/UI/themes.dart';
import 'package:provider/provider.dart';

abstract class ThemedContainer {
  final double width;
  final double height;
  final BuildContext context;
  final String text;

  ThemedContainer(this.width, this.height, this.context, this.text);

  Widget makeContainer();
}

class NeumorphicContainer extends ThemedContainer {
  NeumorphicContainer(
      double width, double height, BuildContext context, String text)
      : super(width, height, context, text);

  @override
  Widget makeContainer() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width / 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
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
