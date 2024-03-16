import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/services/database_service/firebase_db_service.dart';
import 'package:peak/services/logger/logger.dart';
import 'package:peak/UI/themes.dart';
import 'package:provider/provider.dart';

abstract class ThemedContainer {
  final double width;
  final double height;

  ThemedContainer(this.width, this.height);

  Widget makeContainer();
}

class NeumorphicContainer extends ThemedContainer {
  NeumorphicContainer(double width, double height, Color color)
      : super(width, height);

  @override
  Widget makeContainer() {
    return Container();
  }
}
