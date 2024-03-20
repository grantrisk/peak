import 'package:flutter/material.dart';
import 'package:peak/UI/components/components.dart';
import 'package:peak/providers/navigation_provider.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class ScreenView extends StatefulWidget {
  @override
  _ScreenViewState createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NavigationProvider>(context, listen: false);

    // Here, we attach a listener to the provider. However, instead of directly jumping to pages
    // within the listener (which can be unsafe), we schedule a post-frame callback to ensure
    // operations occur at a safe time.
    provider.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(provider.selectedIndex);
        }
      });
    });
  }

  void _onPageChanged(int index) {
    // This method is called when the page is changed by swiping.
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setSelectedIndex(index);
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
    final provider = Provider.of<NavigationProvider>(context);
    provider.setSelectedIndex(
        selectedIndex); // Ensure this is the correct place to update.
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 5,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomeScreen(), // Example screen
          ExerciseScreen(), // Example screen
          Container(color: Theme.of(context).colorScheme.background),
          ProfileScreen() // Example screen
        ],
      ),
      bottomNavigationBar: _navigationWidget(provider.selectedIndex),
      floatingActionButton: _fabWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navigationWidget(int selectedIndex) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeType currentThemeType = themeProvider.currentThemeType;

    return ThemedWidgetFactory.createNav(
        selectedIndex, currentThemeType, _onItemTapped);
  }

  Widget _fabWidget() {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeType currentThemeType = themeProvider.currentThemeType;

    return ThemedWidgetFactory.createFab(currentThemeType);
  }
}
