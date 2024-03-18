import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ThemedFAB extends StatelessWidget {
  const ThemedFAB({Key? key}) : super(key: key);

  ThemeData getThemeData(BuildContext context);

  void showModalWithTheme(
      BuildContext context, Widget Function(BuildContext, ThemeData) builder) {
    ThemeData theme = getThemeData(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.background,
      builder: (BuildContext context) => builder(context, theme),
    );
  }

  @override
  Widget build(BuildContext context);
}
