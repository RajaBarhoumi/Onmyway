import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD2DDDB), // Light background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Illustration
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset('assets/images/role_selection.png', width: 280),
          ),
          SizedBox(height: 30),
          
          // Title Text
          Text(
            "Who are you?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20),

          // Buttons
          _buildRoleButton(context, "Car Owner", Color.fromARGB(255, 101, 141, 136), () {
            // TODO: Navigate to Car Owner Screen
          }),
          _buildRoleButton(context, "Passenger", Color.fromARGB(255, 101, 141, 136), () {
            // TODO: Navigate to Passenger Screen
          }),
          _buildRoleButton(context, "Driver", const Color.fromARGB(255, 101, 141, 136), () {
            // TODO: Navigate to Driver Screen
          }),
        ],
      ),
    );
  }

  // Reusable Button Widget
 Widget _buildRoleButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: SizedBox(
        width: double.infinity, 
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 15), // Increased height
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
