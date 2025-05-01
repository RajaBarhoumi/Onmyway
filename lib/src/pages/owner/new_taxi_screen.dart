import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';
import 'dart:io';

class NewTaxiScreen extends StatefulWidget {
  const NewTaxiScreen({super.key});

  @override
  State<NewTaxiScreen> createState() => _NewTaxiScreenState();
}

class _NewTaxiScreenState extends State<NewTaxiScreen> {
  int _currentIndex = 0; // Taxi tab is active
  int _currentStep = 0; // For the stepper progress

  // Form controllers
  final _chassisNumberController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _brandController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _odometerController = TextEditingController();
  final _powerController = TextEditingController();
  final _locationController = TextEditingController();
  final _techVisitDateController = TextEditingController();
  final _insuranceExpiryController = TextEditingController();

  // Document upload status
  bool _registrationCardUploaded = false;
  bool _taxiOperatingCardUploaded = false;
  bool _municipalAuthUploaded = false;
  File? _registrationCardImage;
  File? _taxiOperatingCardImage;
  File? _municipalAuthImage;

  final ImagePicker _picker = ImagePicker();

  void _handleTabChange(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Taxi
        Navigator.pushNamed(context, AppRoutes.taxiList);
        break;
      case 1: // Drivers
        Navigator.pushNamed(context, AppRoutes.driverRatings);
        break;
      case 2: // Home
        Navigator.pushNamed(context, AppRoutes.dashboard);
        break;
      case 3: // Agenda
        Navigator.pushNamed(context, '/agenda');
        break;
      case 4: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _showImageSourceDialog(String documentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(documentType, ImageSource.camera);
            },
            child: const Text('Take Photo'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(documentType, ImageSource.gallery);
            },
            child: const Text('Pick from Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(String documentType, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (documentType == 'registration') {
            _registrationCardImage = File(image.path);
            _registrationCardUploaded = true;
          } else if (documentType == 'operating') {
            _taxiOperatingCardImage = File(image.path);
            _taxiOperatingCardUploaded = true;
          } else if (documentType == 'municipal') {
            _municipalAuthImage = File(image.path);
            _municipalAuthUploaded = true;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _chassisNumberController.dispose();
    _licensePlateController.dispose();
    _brandController.dispose();
    _fuelTypeController.dispose();
    _odometerController.dispose();
    _powerController.dispose();
    _locationController.dispose();
    _techVisitDateController.dispose();
    _insuranceExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Taxi'),
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
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / 3,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_currentStep + 1} of 3',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep += 1);
                } else {
                  // Save and navigate back
                  Navigator.pushNamed(context, AppRoutes.taxiDetails);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: const Text('BACK'),
                        )
                      else
                        const SizedBox(),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: Text(_currentStep < 2 ? 'CONTINUE' : 'SAVE'),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                // Step 1: Vehicle Identification
                Step(
                  title: const Text('Vehicle Identification'),
                  content: Column(
                    children: [
                      const SizedBox(height: 5),
                      TextField(
                        controller: _chassisNumberController,
                        decoration: InputDecoration(
                          labelText: 'Chassis number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licensePlateController,
                        decoration: InputDecoration(
                          labelText: 'License Plate Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _brandController,
                        decoration: InputDecoration(
                          labelText: 'Brand',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _fuelTypeController,
                        decoration: InputDecoration(
                          labelText: 'Fuel Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                // Step 2: Vehicle Condition
                Step(
                  title: const Text('Vehicle Condition'),
                  content: Column(
                    children: [
                      const SizedBox(height: 5),
                      TextField(
                        controller: _odometerController,
                        decoration: InputDecoration(
                          labelText: 'Odometer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _powerController,
                        decoration: InputDecoration(
                          labelText: 'Power',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _techVisitDateController,
                        decoration: InputDecoration(
                          labelText: 'Technical Visit Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _techVisitDateController.text =
                                  "${date.day}/${date.month}/${date.year}";
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _insuranceExpiryController,
                        decoration: InputDecoration(
                          labelText: 'Insurance Expiry',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _insuranceExpiryController.text =
                                  "${date.day}/${date.month}/${date.year}";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
                // Step 3: Vehicle Documents
                Step(
                  title: const Text('Vehicle Documents'),
                  content: Column(
                    children: [
                      ListTile(
                        leading: _registrationCardUploaded &&
                                _registrationCardImage != null
                            ? Image.file(_registrationCardImage!,
                                width: 50, height: 50)
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.grey),
                              ),
                        title: const Text('Registration Card'),
                        trailing: _registrationCardUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('registration'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: _taxiOperatingCardUploaded &&
                                _taxiOperatingCardImage != null
                            ? Image.file(_taxiOperatingCardImage!,
                                width: 50, height: 50)
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.grey),
                              ),
                        title: const Text('Taxi Operating Card'),
                        trailing: _taxiOperatingCardUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('operating'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: _municipalAuthUploaded &&
                                _municipalAuthImage != null
                            ? Image.file(_municipalAuthImage!,
                                width: 50, height: 50)
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.grey),
                              ),
                        title: const Text('Municipal Authorization'),
                        trailing: _municipalAuthUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('municipal'),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                ),
              ],
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
