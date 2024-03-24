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
import 'package:peak/services/logger/logger.dart';
import 'package:peak/UI/themes.dart';
import 'package:provider/provider.dart';

abstract class ThemedContainer extends StatelessWidget {
  final double width;
  final double height;
  final String text;

  const ThemedContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context);
}
