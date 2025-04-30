// In custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 20, // Shadow intensity
      shadowColor: Colors.black38, // Shadow color
      borderRadius: BorderRadius.circular(0), // No curve
      child: ConvexAppBar(
        items: [
          TabItem(
            icon: Icon(Icons.local_taxi, size: 28, color: Colors.black54),
            title: 'Taxi',
          ),
          TabItem(
            icon: Icon(Icons.people_alt, size: 28, color: Colors.black54),
            title: 'Drivers',
          ),
          TabItem(
            icon: Icon(Icons.home, size: 28, color: Colors.black54),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(Icons.calendar_today, size: 28, color: Colors.black54),
            title: 'Agenda',
          ),
          TabItem(
            icon: Icon(Icons.person, size: 28, color: Colors.black54),
            title: 'Profile',
          ),
        ],
        initialActiveIndex: currentIndex,
        onTap: onTap,
        style: TabStyle.reactCircle,
        backgroundColor: const Color.fromARGB(255, 224, 224, 224),
        activeColor: Colors.amber,
        color: Colors.black54,
        height: 55,
        curveSize: 100,
        top: -20,
        elevation: 5, // Keep for ConvexAppBar's internal shadow
      ),
    );
  }
}
