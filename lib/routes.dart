import 'package:flutter/material.dart';
import 'package:shift_manager/screens/availability.dart';
import 'package:shift_manager/screens/settings.dart';
import 'package:shift_manager/shared/bottom_nav.dart';
import 'package:shift_manager/screens/schedule.dart';

class RoutesClass {
  static const initial = '/';
  static const authIntro = '/auth';
  static const home = '/home';
  static const settings = '/settings';
  static const intro = '/intro';
  static const availability = '/availability';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesClass.initial:
        return MaterialPageRoute(builder: (context) => const BottomNavigation());
      case RoutesClass.availability:
        {
          return MaterialPageRoute(
              builder: (context) => const AvailabilityScreen());
        }
      case RoutesClass.home:
        {
          return MaterialPageRoute(
              builder: (context) => const ScheduleScreen());
        }
      case RoutesClass.settings:
        {
          return MaterialPageRoute(
              builder: (context) => const SettingsScreen());
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}