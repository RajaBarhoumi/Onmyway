import 'package:flutter/material.dart';
import 'package:onmyway/src/pages/auth.dart';
import 'package:onmyway/src/routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Illustration
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset('assets/images/role_selection.png',
                width: MediaQuery.of(context).size.width),
          ),
          SizedBox(height: 30),

          // Title Text
          Text(
            "Who are you?",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20),

          // Buttons
          _buildRoleButton(context, "Car Owner", () {
            Navigator.pushNamed(context, AppRoutes.auth);
          }),
          _buildRoleButton(context, "Passenger", () {
            Navigator.pushNamed(context, AppRoutes.auth);
          }),
          _buildRoleButton(context, "Driver", () {
            Navigator.pushNamed(context, AppRoutes.auth);
          }),
        ],
      ),
    );
  }

  // Reusable Button Widget
  Widget _buildRoleButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 15), // Increased height
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child:
              Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
