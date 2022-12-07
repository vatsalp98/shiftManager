import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shift_manager/screens/home.dart';
import 'package:shift_manager/screens/schedule.dart';
import 'package:shift_manager/screens/settings.dart';

import '../routes.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late PersistentTabController tabController;

  @override
  void initState() {
    tabController = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      // const HomeScreen(),
      const ScheduleScreen(),
      const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // PersistentBottomNavBarItem(
      //     icon: const Icon(Icons.home),
      //     title: "Home",
      //     textStyle: const TextStyle(fontWeight: FontWeight.w500),
      //     activeColorSecondary: Colors.black,
      //     activeColorPrimary: Colors.red.shade700,
      //     inactiveColorPrimary: Colors.grey.shade500,
      //     routeAndNavigatorSettings: const RouteAndNavigatorSettings(
      //         initialRoute: '/',
      //         onGenerateRoute: RouteGenerator.generateRoute)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.calendar_month_rounded),
          title: "Shifts",
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
          activeColorSecondary: Colors.black,
          activeColorPrimary: Colors.red.shade700,
          inactiveColorPrimary: Colors.grey.shade500,
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings_rounded),
          title: "Settings",
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
          activeColorSecondary: Colors.black,
          inactiveColorPrimary: Colors.grey.shade500,
          activeColorPrimary: Colors.red.shade700,
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: tabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarHeight: 65,
        stateManagement: true,
        confineInSafeArea: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 75),
          curve: Curves.ease,
        ),
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        popActionScreens: PopActionScreensType.all,
        backgroundColor: Colors.white,
        popAllScreensOnTapOfSelectedTab: true,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        hideNavigationBarWhenKeyboardShows: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
