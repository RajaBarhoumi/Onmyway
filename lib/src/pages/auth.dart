import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _selectedTab = 0; // 0 for Sign Up, 1 for Login
  bool _isOtpScreen = false; // To toggle between Sign Up and OTP
  double _progressValue = 0.5; // Progress bar starts at 50%

  void _onSignUpPressed() {
    setState(() {
      _isOtpScreen = true;
      _progressValue = 1.0; // Progress bar fully filled when moving to OTP
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Logo at the top
              Image.asset(
                'assets/images/logo.png',
                height: 60,
              ),
              const SizedBox(height: 32),

              // Horizontal Navigation Box
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                          _isOtpScreen = false;
                          _progressValue = 0.5;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.yellow[700] : Colors.grey[400],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'SIGN UP',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: _selectedTab == 0 ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                          _isOtpScreen = false;
                          _progressValue = 0.5;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.yellow[700] : Colors.grey[400],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: _selectedTab == 1 ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar (visible only during Sign Up/OTP flow)
              if (_selectedTab == 0)
                LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              const SizedBox(height: 32),

              // Dynamic Content based on tab and state
              Expanded(
                child: _selectedTab == 0
                    ? (_isOtpScreen ? _buildOtpContent() : _buildSignUpContent())
                    : _buildLoginContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign Up Content
  Widget _buildSignUpContent() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'FULL NAME',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'PHONE NUMBER',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'PASSWORD',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'CONFIRM PASSWORD',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Text(
              'I agree the terms of use and privacy policy',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.yellow[700]),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _onSignUpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'SIGN UP',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // OTP Content
  Widget _buildOtpContent() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isOtpScreen = false;
                  _progressValue = 0.5;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Verify OTP',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Please enter the code we sent you',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => SizedBox(
              width: 50,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Resend Code',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'VERIFY',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Login Content
  Widget _buildLoginContent() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'USERNAME OR EMAIL',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'PASSWORD',
            hintStyle: GoogleFonts.inter(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgotten your password?',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'LOG IN',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or sign in with',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.apple, size: 40),
            ),
            const SizedBox(width: 16),
            IconButton(
  onPressed: () {},
  icon: Image.network(
    'https://img.icons8.com/?size=100&id=qyRpAggnV0zH&format=png&color=000000',
    height: 40,
    //color: Colors.pink, // Apply pink color to the image
    colorBlendMode: BlendMode.srcIn, // Ensure the color applies correctly
  ),
),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.facebook, size: 40, color: Colors.blue),
            ),
          ],
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedTab = 0;
              _isOtpScreen = false;
              _progressValue = 0.5;
            });
          },
          child: Text(
            'CREATE AN ACCOUNT',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}