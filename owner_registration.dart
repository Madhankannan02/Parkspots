import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For converting coordinates to address

class OwnerRegistrationPage extends StatefulWidget {
  final String username;
  final String email;

  OwnerRegistrationPage({this.username = '', this.email = ''});

  @override
  _OwnerRegistrationPageState createState() => _OwnerRegistrationPageState();
}

class _OwnerRegistrationPageState extends State<OwnerRegistrationPage> {
  String? selectedIdProof;
  String? selectedParkingSlot;
  final _idNumberController = TextEditingController();
  final _addressController = TextEditingController();
  File? _image;

  final List<String> idProofs = [
    'Aadhar Card',
    'Passport',
    'Driving License',
    'Voter ID',
    'PAN Card'
  ];

  final List<String> parkingSlots = [
    'Parallel Parking Slots',
    'Perpendicular Parking Slots',
    'Diagonal/Angled Slots',
    'Stack Parking Slots'
  ];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          actions: [
            TextButton(
              child: Text("Camera"),
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            TextButton(
              child: Text("Gallery"),
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(List<String> options, String title, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              ...options.map((option) => ListTile(
                title: Text(option),
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time stay the denied
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      Geolocator.openAppSettings();
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _addressController.text = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } else {
      setState(() {
        _addressController.text = "No address found for these coordinates.";
      });
    }

  }


  @override
  void initState() {
    super.initState();
    // DO NOT precacheImage HERE
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the image here
    precacheImage(AssetImage('assets/default_dp.png'), context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 43.95,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Register Your Parking Space",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HelveticaNeue',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "List your parking lot and start earning today!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'HelveticaNeue',
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImageSourceDialog();
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/default_dp.png') as ImageProvider,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                /// Personal Information Section
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.username),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.email),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                /// ID Proof Section
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _showBottomSheet(idProofs, "Select ID Proof", (value) {
                            setState(() => selectedIdProof = value);
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF49454F).withOpacity(0.04),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                            ),
                            elevation: 0, // Remove shadow
                            shadowColor: Colors.transparent, // remove shadow
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedIdProof ?? "ID Proof",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500), // Black text
                                ),
                                Icon(Icons.expand_more, color: Colors.black), // Accordion Icon
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2, // Make this input bigger
                      child: SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _idNumberController,
                          decoration: InputDecoration(
                            hintText: "ID Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                /// Parking Slot Selection
                SizedBox(
                  height: 56,
                  width: double.infinity, // Take up full screen width
                  child: ElevatedButton(
                    onPressed: () => _showBottomSheet(parkingSlots, "Select Parking Slot Layout", (value) {
                      setState(() => selectedParkingSlot = value);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF49454F).withOpacity(0.04),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      elevation: 0, // Remove shadow
                      shadowColor: Colors.transparent, // remove shadow

                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedParkingSlot ?? "Select Parking Slot Layout",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500), // Black text
                          ),
                          Icon(Icons.expand_more, color: Colors.black), // Accordion Icon
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                /// Address Section
                Text(
                  "Parking Lot Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _getCurrentLocation,
                  child: Text("Select from Location"),
                ),
                SizedBox(height: 16),

                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Parking Registration Submitted!")),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0, // Remove shadow
                      shadowColor: Colors.transparent, // remove shadow

                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'HelveticaNeue',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
