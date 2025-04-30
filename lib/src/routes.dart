import 'package:flutter/material.dart';
import 'package:onmyway/src/pages/owner/dashboard.dart';
import 'package:onmyway/src/pages/splashscreen.dart';
import 'package:onmyway/src/pages/owner/driver_list.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String driverRatings = '/driver_list';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      dashboard: (context) => const TaxiOwnerDashboard(),
      driverRatings: (context) => const DriverRatingsScreen(),
    };
  }
}
