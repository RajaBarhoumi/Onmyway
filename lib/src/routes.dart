import 'package:flutter/material.dart';
import 'package:onmyway/src/pages/auth.dart';
import 'package:onmyway/src/pages/owner/dashboard.dart';
import 'package:onmyway/src/pages/owner/driver_profile_screen.dart';
import 'package:onmyway/src/pages/owner/new_driver_screen.dart';
import 'package:onmyway/src/pages/owner/new_taxi_screen.dart';
import 'package:onmyway/src/pages/owner/taxi_list.dart';
import 'package:onmyway/src/pages/role_selection_screen.dart';
import 'package:onmyway/src/pages/splashscreen.dart';
import 'package:onmyway/src/pages/owner/driver_list.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String driverRatings = '/driver_list';
  static const String roleSelection = '/role_selection';
  static const String auth = '/auth';
  static const String addDriver = '/add_driver';
  static const String driverProfile = '/driver_profile';
  static const String taxiList = '/taxi_list';
  static const String addTaxi = '/add_taxi';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => SplashScreen(),
      dashboard: (context) => const TaxiOwnerDashboard(),
      driverRatings: (context) => const DriverRatingsScreen(),
      roleSelection: (context) => const RoleSelectionScreen(),
      auth: (context) => const AuthScreen(),
      addDriver: (context) => const NewDriverScreen(),
      driverProfile: (context) => const DriverProfileScreen(),
      taxiList: (context) => const TaxiListScreen(),
      addTaxi: (context) =>
          const NewTaxiScreen(), // Placeholder for add taxi screen
    };
  }
}
