import 'package:flutter/material.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';

class DriverRatingsScreen extends StatefulWidget {
  const DriverRatingsScreen({super.key});

  @override
  State<DriverRatingsScreen> createState() => _DriverRatingsScreenState();
}

class _DriverRatingsScreenState extends State<DriverRatingsScreen> {
  int _currentIndex = 1; // Default to 'Drivers' tab (index 1)

  final List<Map<String, dynamic>> drivers = [
    {
      'name': 'Michael Schumacher',
      'rating': 4.4,
      'image': 'assets/images/driver_img.png'
    },
    {
      'name': 'Lewis Hamilton',
      'rating': 4.4,
      'image': 'assets/images/driver_img.png'
    },
    {
      'name': 'Lando Norris',
      'rating': 4.4,
      'image': 'assets/images/driver_img.png'
    },
    {
      'name': 'Carlos Sainz',
      'rating': 4.4,
      'image': 'assets/images/driver_img.png'
    },
  ];

  void _handleTabChange(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Home
      Navigator.pushNamed(context, '/taxi_list');
        break;
      case 1: // Drivers
        // Already here
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
        title: const Text('Driver Ratings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search drivers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.driverProfile);
                      },
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(driver['image']),
                                child: driver['image'] == null
                                    ? const Icon(Icons.person,
                                        color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  driver['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    driver['rating'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 30,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addDriver);
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
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
}
