import 'package:peak/UI/components/neumorphic/neumorphic_fab.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/widgets/quick_start_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:peak/UI/components/components.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Welcome back',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    fontSize: 28,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w900))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // _logWorkoutButton(context),
              _sectionCard(
                  title: '',
                  child: _placeholderWidget('', theme),
                  theme: theme),
              _sectionCard(
                  title: '',
                  child: _placeholderWidget('', theme),
                  theme: theme),
              _sectionCard(
                  title: '',
                  child: _placeholderWidget('', theme),
                  theme: theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NeumorphicNav(
        selectedIndex: 0,
      ),
      floatingActionButton: NeumorphicFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // TODO: Figure out what the hell to do with this card
  Widget _sectionCard(
      {required String title,
      required Widget child,
      required ThemeData theme}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // TODO: is it possible to remove the shadow of the card?
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  // Checks the theme type and renders a themed element accordingly
  Widget _placeholderWidget(String text, ThemeData theme) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeType theme = themeProvider.currentThemeType;

    switch (theme) {
      case ThemeType.defaultTheme:
        return Container();
      case ThemeType.dark:
        return Container();
      case ThemeType.light:
        final container = NeumorphicContainer(500, 150, context, text);
        return container.makeContainer();
      default:
        return Container();
    }
  }
}
