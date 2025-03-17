import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_switch/flutter_switch.dart';

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

  // Parking Input fields controllers
  final _gpsCoordinateController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _totalSpacesController = TextEditingController();
  String? _selectedPlotType;

  // Time for Working Hours and Peak Hours, default value set to null.
  TimeOfDay? _workingHoursFrom;
  TimeOfDay? _workingHoursTo;
  TimeOfDay? _peakHoursFrom;
  TimeOfDay? _peakHoursTo;

  bool _shelterIncluded = false;
  bool _undergroundParking = false;
  bool _evCharging = false;
  bool _cctvIncluded = false;
  bool _securityGuards = false;
  bool _restroomAvailability = false;

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

  List<String> plotTypes = [
    'Open Lot',
    'Covered Garage',
    'Street Parking',
    'Private Driveway'
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

  void _showBottomSheet(
      List<String> options, String title, Function(String) onSelect) {
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
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Future<void> _selectTime(
      BuildContext context, String whichTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        switch (whichTime) {
          case 'workingFrom':
            _workingHoursFrom = pickedTime;
            break;
          case 'workingTo':
            _workingHoursTo = pickedTime;
            break;
          case 'peakFrom':
            _peakHoursFrom = pickedTime;
            break;
          case 'peakTo':
            _peakHoursTo = pickedTime;
            break;
        }
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
                // Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                  ),
                ),
                SizedBox(height: 24),

                // Title and Subtitle
                Text(
                  "Register Your Parking Space",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HelveticaNeue',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "List your parking lot and start earning today!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'HelveticaNeue',
                    color: Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 24),

                // Profile Image
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

                // Personal Information Section
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
                SizedBox(height: 8),

                // Full Name
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.username),
                  ),
                ),
                SizedBox(height: 10),

                // Email
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.email),
                  ),
                ),
                SizedBox(height: 10),

                // Phone Number
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // ID Proof Section
                Row(
                  children: [
                    // ID Proof Dropdown
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _showBottomSheet(
                              idProofs, "Select ID Proof", (value) {
                            setState(() => selectedIdProof = value);
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Color(0xFF49454F).withOpacity(0.04),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedIdProof ?? "ID Proof",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.expand_more, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // ID Number Input
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _idNumberController,
                          decoration: InputDecoration(
                            hintText: "ID Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Parking Slot Selection
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showBottomSheet(
                        parkingSlots, "Select Parking Slot Layout", (value) {
                      setState(() => selectedParkingSlot = value);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF49454F).withOpacity(0.04),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedParkingSlot ?? "Select Parking Slot Layout",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.expand_more, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Address Section
                Text(
                  "Parking Lot Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
                SizedBox(height: 8),

                // Address Input
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // **************************** START INPUT FIELDS FROM PREVIOUS RESPONSE ****************************
                // GPS Coordinate
                TextFormField(
                  controller: _gpsCoordinateController,
                  decoration: InputDecoration(
                    hintText: "GPS Coordinate (Optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 16),

                // Working Hours
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeSelector(
                          "From", _workingHoursFrom, () {
                        _selectTime(context, 'workingFrom');
                      }),
                    ),
                    const SizedBox(width: 8),
                    const Text("To"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeSelector(
                          "To", _workingHoursTo, () {
                        _selectTime(context, 'workingTo');
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Peak Hours
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeSelector(
                          "From", _peakHoursFrom, () {
                        _selectTime(context, 'peakFrom');
                      }),
                    ),
                    const SizedBox(width: 8),
                    const Text("To"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeSelector(
                          "To", _peakHoursTo, () {
                        _selectTime(context, 'peakTo');
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Length and Width of Plot
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lengthController,
                        decoration: InputDecoration(
                          hintText: "Length of the Plot",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _widthController,
                        decoration: InputDecoration(
                          hintText: "Width of the Plot",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Number of Parking Spaces
                TextFormField(
                  controller: _totalSpacesController,
                  decoration: InputDecoration(
                    hintText: "Total Number of Parking Spaces",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // **************************** END INPUT FIELDS FROM PREVIOUS RESPONSE ****************************

                // Plot Type Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Plot Type",
                      ),
                      value: _selectedPlotType,
                      items: plotTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPlotType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Switch Tiles
                _buildSwitchTile("Shelter Included", _shelterIncluded, (value) {
                  setState(() => _shelterIncluded = value);
                }),
                _buildSwitchTile("Underground Parking", _undergroundParking, (value) {
                  setState(() => _undergroundParking = value);
                }),
                _buildSwitchTile("EV Charging", _evCharging, (value) {
                  setState(() => _evCharging = value);
                }),
                _buildSwitchTile("CCTV Included", _cctvIncluded, (value) {
                  setState(() => _cctvIncluded = value);
                }),
                _buildSwitchTile("Security Guards", _securityGuards, (value) {
                  setState(() => _securityGuards = value);
                }),
                _buildSwitchTile("Restroom Availability", _restroomAvailability, (value) {
                  setState(() => _restroomAvailability = value);
                }),

                const SizedBox(height: 16),

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

  Widget _buildTimeSelector(String label, TimeOfDay? selectedTime, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              selectedTime == null
                  ? "Select Time"
                  : selectedTime.format(context), //format TimeOfDay to a string.
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          FlutterSwitch(
            width: 50.0,
            height: 25.0,
            valueFontSize: 12.0,
            toggleSize: 20.0,
            value: value,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _addressController.dispose();

    _gpsCoordinateController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _totalSpacesController.dispose();

    super.dispose();
  }
}
