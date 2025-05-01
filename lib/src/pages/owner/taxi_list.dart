import 'package:flutter/material.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';

class TaxiListScreen extends StatefulWidget {
  const TaxiListScreen({super.key});

  @override
  State<TaxiListScreen> createState() => _TaxiListScreenState();
}

class _TaxiListScreenState extends State<TaxiListScreen> {
  int _currentIndex = 0; // Taxi tab is active
  bool _showAddOptions = false;

  void _handleTabChange(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Home
        Navigator.pushNamed(context, '/taxi_list');
        break;
      case 1: // Drivers
        Navigator.pushNamed(context, '/driver_list');
        break;
      case 2: // Agenda
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 3: // Taxi
        Navigator.pushNamed(context, '/agenda');
        break;
      case 4: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Taxis'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          // Main content
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTaxiCard('123 TUN 456', '25 Mar 2025', '20 May 2025'),
              const SizedBox(height: 16),
              _buildTaxiCard('123 TUN 456', '25 Mar 2025', '20 May 2025'),
              const SizedBox(height: 16),
              _buildTaxiCard('123 TUN 456', '25 Mar 2025', '20 May 2025'),
              const SizedBox(height: 80), // Space for floating button
            ],
          ),

          // Add/Buy Taxi Options (shown when _showAddOptions is true)
          if (_showAddOptions)
            Positioned(
              right: 16,
              bottom: 150, // Above the FAB
              child: Column(
                children: [
                  _buildOptionButton('Add Taxi', Icons.add, Colors.orange),
                  const SizedBox(height: 8),
                  _buildOptionButton(
                      'Buy Taxi', Icons.shopping_cart, Colors.green),
                ],
              ),
            ),

          // Floating Action Button
          Positioned(
            right: 16,
            bottom: 80 + MediaQuery.of(context).padding.bottom,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showAddOptions = !_showAddOptions;
                });
              },
              backgroundColor: Colors.black,
              child: Icon(
                _showAddOptions ? Icons.add : Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleTabChange,
      ),
    );
  }

  Widget _buildTaxiCard(String plate, String techDate, String insuranceDate) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plate,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.car_repair, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Technical Visit Date: ',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: techDate,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.security, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Insurance Expiry: ',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: insuranceDate,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider line
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            // Action icons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addTaxi);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.green),
                  onPressed: () {
                    // Handle user/driver assignment
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.orange),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.taxiDetails);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, Color color) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          setState(() => _showAddOptions = false);
          // Handle button tap
          if (text == 'Add Taxi') {
            Navigator.pushNamed(context, AppRoutes.addTaxi);
          } else {
            // Navigate to buy taxi screen
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
