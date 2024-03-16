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
