import 'package:flutter/material.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';

class TaxiDetailsScreen extends StatefulWidget {
  const TaxiDetailsScreen({super.key});

  @override
  State<TaxiDetailsScreen> createState() => _TaxiDetailsScreenState();
}

class _TaxiDetailsScreenState extends State<TaxiDetailsScreen> {
  int _currentIndex = 0; // Taxi tab is active

  void _handleTabChange(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.taxiList);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.driverRatings);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.dashboard);
        break;
      case 3:
        Navigator.pushNamed(context, '/agenda');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/taxi_details.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.addTaxi);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '123 TUN 456',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
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
                        'Taxi #2 - Plate: 123 TUN 456',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Brand: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('BMW',
                              style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Panne',
                              style: TextStyle(color: Colors.red.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Fuel Type:', 'Diesel'),
                      _buildDetailRow('Power:', '75 HP'),
                      _buildDetailRow('Chassis Number:', 'VF3ABCD1234567890'),
                      _buildDetailRow('Odometer:', '85,200 km'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDocumentRow('Technical Visit Date:', '15/10/2024'),
                      _buildDocumentRow('Insurance Expiry:', '20/12/2024'),
                      _buildDocumentRow('Taxi Operating Card:', 'PDF',
                          isDocument: true),
                      _buildDocumentRow(
                          'Municipal Authorization:', '10/06/2025'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleTabChange,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String label, String value,
      {bool isDocument = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isDocument
                ? InkWell(
                    onTap: () {
                      // Open document
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
          ),
        ],
      ),
    );
  }
}
