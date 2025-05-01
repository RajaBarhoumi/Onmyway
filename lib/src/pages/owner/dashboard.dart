import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TaxiOwnerDashboard extends StatefulWidget {
  const TaxiOwnerDashboard({super.key});

  @override
  State<TaxiOwnerDashboard> createState() => _TaxiOwnerDashboardState();
}

class _TaxiOwnerDashboardState extends State<TaxiOwnerDashboard> {
  int _currentIndex = 2;
  String _selectedTimeFrame = 'Daily';
  final List<String> _timeFrames = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  Map<String, dynamic>? _selectedDriver;

  final LatLng _sousseCenter = const LatLng(35.8254, 10.6084);
  final List<Map<String, dynamic>> _drivers = [
    {
      'name': 'Ahmed B.',
      'chassis': '123 TUN 456',
      'location': const LatLng(35.8300, 10.6150)
    },
    {
      'name': 'Mohamed S.',
      'chassis': '789 TUN 012',
      'location': const LatLng(35.8200, 10.6000)
    },
    {
      'name': 'Fatma K.',
      'chassis': '345 TUN 678',
      'location': const LatLng(35.8350, 10.6200)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            // Map Section
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _sousseCenter,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: _drivers
                            .map((driver) => Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: driver['location'],
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDriver = driver;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.local_taxi,
                                      color: Colors.amber,
                                      size: 30,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  if (_selectedDriver != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _selectedDriver!['chassis'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _selectedDriver!['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Time Frame Selector
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _timeFrames
                    .map((frame) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTimeFrame = frame;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: _selectedTimeFrame == frame
                                  ? Colors.amber
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              frame,
                              style: TextStyle(
                                color: _selectedTimeFrame == frame
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Drivers Chart in Grey Box
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                color: Colors.grey[200],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Drivers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: SfCircularChart(
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: [
                                ChartData('Online', 8, Colors.teal),
                                ChartData('Offline', 4, Colors.pink[200]!),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              innerRadius: '70%',
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                useSeriesColor: true,
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                connectorLineSettings: ConnectorLineSettings(
                                  length: '10%',
                                  type: ConnectorType.curve,
                                ),
                              ),
                            ),
                          ],
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const Text(
                        'Total: 12',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fleet Chart in Grey Box
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                color: Colors.grey[200],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Fleet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200,
                        child: SfCircularChart(
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: [
                                ChartData('Maintenance', 35,
                                    const Color.fromARGB(255, 255, 80, 138)),
                                ChartData('Available', 20,
                                    const Color.fromARGB(255, 119, 216, 206)),
                                ChartData('On Ride', 45,
                                    const Color.fromARGB(255, 1, 173, 136)),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              innerRadius: '70%',
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                useSeriesColor: true,
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                connectorLineSettings: ConnectorLineSettings(
                                  length: '10%',
                                  type: ConnectorType.curve,
                                ),
                              ),
                            ),
                          ],
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const Text(
                        'Total: 12',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Rides Progress Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Text(
                            'Rides',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '18 Completed',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '8 Canceled',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 18 / (18 + 8),
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'EARNINGS: 29007 TND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.taxiList);
        break;
      case 1: // Drivers
        Navigator.pushNamed(context, AppRoutes.driverRatings);
        break;
      case 2: // Home
        break;
      case 3: // Agenda
        break;
      case 4: // Profile
        break;
    }
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, [this.color = Colors.blue]);
}
