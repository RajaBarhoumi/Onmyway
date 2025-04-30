import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onmyway/src/routes.dart';
import 'package:onmyway/src/widgets/custom_bottom_nav.dart';
import 'dart:io';

class NewDriverScreen extends StatefulWidget {
  const NewDriverScreen({super.key});

  @override
  State<NewDriverScreen> createState() => _NewDriverScreenState();
}

class _NewDriverScreenState extends State<NewDriverScreen> {
  int _currentIndex = 1; // Default to 'Drivers' tab (index 1)
  int _currentStep = 0; // For the stepper progress

  String? _selectedTimeSlot;
  List<String> _selectedShifts = [];
  String? _selectedWorkArea;

  // Controllers for form fields
  final _fullNameController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _expiringDateController = TextEditingController();

  // Document upload status and image files
  bool _driverLicenseUploaded = false;
  bool _taxiLicenseUploaded = false;
  bool _personalPictureUploaded = false;
  File? _driverLicenseImage;
  File? _taxiLicenseImage;
  File? _personalPictureImage;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Validation for Step 1
  bool _validateStep1() {
    return _fullNameController.text.isNotEmpty &&
        _licenseNoController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _dateOfBirthController.text.isNotEmpty &&
        _expiringDateController.text.isNotEmpty;
  }

  void _handleTabChange(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0: // Home
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

  // Show dialog to choose between camera and gallery
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

  // Pick image using image_picker
  Future<void> _pickImage(String documentType, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (documentType == 'driverLicense') {
            _driverLicenseImage = File(image.path);
            _driverLicenseUploaded = true;
          } else if (documentType == 'taxiLicense') {
            _taxiLicenseImage = File(image.path);
            _taxiLicenseUploaded = true;
          } else if (documentType == 'personalPicture') {
            _personalPictureImage = File(image.path);
            _personalPictureUploaded = true;
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
    _fullNameController.dispose();
    _licenseNoController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _expiringDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Driver'),
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
                if (_currentStep == 0 && !_validateStep1()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill all fields in Step 1')),
                  );
                  return;
                }
                if (_currentStep < 2) {
                  setState(() => _currentStep += 1);
                  // Step 2 (Documents Upload) is opened when _currentStep becomes 1 (from Step 1)
                  // Step 3 (Choose Work Hours) is opened when _currentStep becomes 2 (from Step 2)
                } else {
                  // Handle save action
                  Navigator.pop(context); // Go back after saving
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
                      // Show "Back" button for Steps 1 and 2
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
                        const SizedBox(), // Empty space when no "Back" button
                      // Show "Continue" for Steps 0 and 1, "Save" for Step 2
                      if (_currentStep < 2)
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
                          child: const Text('CONTINUE'),
                        )
                      else
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
                          child: const Text('SAVE'),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                // Step 1: Personal Info
                Step(
                  title: const Text(''),
                  content: Column(
                    children: [
                      const SizedBox(height: 5),
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _licenseNoController,
                        decoration: InputDecoration(
                          labelText: 'License no',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dateOfBirthController,
                        decoration: InputDecoration(
                          labelText: 'Date of birth',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateOfBirthController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _expiringDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiring date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _expiringDateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                // Step 2: Documents Upload (Updated with image_picker)
                Step(
                  title: const Text(''),
                  content: Column(
                    children: [
                      ListTile(
                        leading: _driverLicenseUploaded &&
                                _driverLicenseImage != null
                            ? Image.file(
                                _driverLicenseImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Center(
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.grey),
                                ),
                              ),
                        title: const Text("Driver's License"),
                        trailing: _driverLicenseUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('driverLicense'),
                      ),
                      const Divider(),
                      ListTile(
                        leading:
                            _taxiLicenseUploaded && _taxiLicenseImage != null
                                ? Image.file(
                                    _taxiLicenseImage!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.camera_alt,
                                          color: Colors.grey),
                                    ),
                                  ),
                        title: const Text("Taxi License"),
                        trailing: _taxiLicenseUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('taxiLicense'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: _personalPictureUploaded &&
                                _personalPictureImage != null
                            ? Image.file(
                                _personalPictureImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Center(
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.grey),
                                ),
                              ),
                        title: const Text("Personal Picture"),
                        trailing: _personalPictureUploaded
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.upload),
                        onTap: () => _showImageSourceDialog('personalPicture'),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),

                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: _selectedWorkArea,
                        decoration: InputDecoration(
                          labelText: 'WORK AREA',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        items: ['Tafela city', 'Other city']
                            .map((area) => DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedWorkArea = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('SHIFTS:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map((day) => ChoiceChip(
                                      label: Text(day),
                                      selected: _selectedShifts.contains(day),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedShifts.add(day);
                                          } else {
                                            _selectedShifts.remove(day);
                                          }
                                        });
                                      },
                                    ))
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text('AVAILABLE TIME SLOTS:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RadioListTile<String>(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('8:00 AM - 12:00 PM',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('123 TUN 4567'),
                            Text('567 TUN 1238'),
                            Text('Taken by: You'),
                          ],
                        ),
                        value: '8:00 AM - 12:00 PM',
                        groupValue: _selectedTimeSlot,
                        onChanged: (value) {
                          setState(() => _selectedTimeSlot = value!);
                        },
                      ),
                      RadioListTile<String>(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('2:00 PM - 6:00 PM',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('123 TUN 4567'),
                            Text('567 TUN 1238'),
                            Text('Taken by: You'),
                          ],
                        ),
                        value: '2:00 PM - 6:00 PM',
                        groupValue: _selectedTimeSlot,
                        onChanged: (value) {
                          setState(() => _selectedTimeSlot = value!);
                        },
                      ),
                      RadioListTile<String>(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('6:00 PM - 10:00 PM',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('123 TUN 4567'),
                            Text('567 TUN 1238'),
                            Text('Taken by: You'),
                          ],
                        ),
                        value: '6:00 PM - 10:00 PM',
                        groupValue: _selectedTimeSlot,
                        onChanged: (value) {
                          setState(() => _selectedTimeSlot = value!);
                        },
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
