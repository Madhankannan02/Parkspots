import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'upload_media.dart';

class OwnerRegistrationPage extends StatefulWidget {
  final String username;
  final String email;

  const OwnerRegistrationPage({Key? key, this.username = '', this.email = ''}) : super(key: key);

  @override
  _OwnerRegistrationPageState createState() => _OwnerRegistrationPageState();
}

class _OwnerRegistrationPageState extends State<OwnerRegistrationPage> {
  // General Information
  String? selectedIdProof;
  String? selectedParkingSlot;
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _image;

  // Pricing Details Controllers
  final TextEditingController _hourlyPriceController = TextEditingController();
  final TextEditingController _peakHoursPriceController = TextEditingController();
  final TextEditingController _dailyPriceController = TextEditingController();

  // Parking Input fields controllers
  final TextEditingController _gpsCoordinateController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _totalSpacesController = TextEditingController();
  String? _selectedPlotType;

  // Time Selection
  TimeOfDay? _workingHoursFrom;
  TimeOfDay? _workingHoursTo;
  TimeOfDay? _peakHoursFrom;
  TimeOfDay? _peakHoursTo;

  // Features
  bool _shelterIncluded = false;
  bool _undergroundParking = false;
  bool _evCharging = false;
  bool _cctvIncluded = false;
  bool _securityGuards = false;
  bool _restroomAvailability = false;

  // Agreements
  bool _confirmOwnership = false;
  bool _agreeTerms = false;

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
  final List<String> plotTypes = [
    'Open Lot',
    'Covered Garage',
    'Street Parking',
    'Private Driveway'
  ];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(List<String> options, String title, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ...options.map((option) => TextButton(
                onPressed: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, String whichTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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

  void _showPlotTypeBottomSheet(BuildContext context, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Plot Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ...plotTypes.map((option) => TextButton(
                onPressed: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  // Reusable Widgets
  Widget _buildTimeButton(BuildContext context, String label, TimeOfDay? selectedTime, String whichTime) {
    return InkWell(
      onTap: () {
        _selectTime(context, whichTime);
      },
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF49454F).withOpacity(0.04),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Text(selectedTime == null ? label : selectedTime.format(context)),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal)),
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

  Widget _buildPriceInput(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal)),
        Container(
          width: 100,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "(in Rs)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 24),

                // Title and Subtitle
                const Text("Register Your Parking Space", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'HelveticaNeue', color: Colors.black)),
                const SizedBox(height: 8),
                const Text("List your parking lot and start earning today!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontFamily: 'HelveticaNeue', color: Color(0xFF718096))),
                const SizedBox(height: 24),

                // Profile Image
                Center(
                  child: InkWell(
                    onTap: () => _showImageSourceDialog(),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/default_dp.png') as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Personal Information Section
                const Text("Personal Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'HelveticaNeue')),
                const SizedBox(height: 8),

                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.username),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    controller: TextEditingController(text: widget.email),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 56,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ID Proof Section
                Row(
                  children: [
                    // ID Proof Dropdown
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _showBottomSheet(idProofs, "Select ID Proof", (value) {
                            setState(() => selectedIdProof = value);
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF49454F).withOpacity(0.04),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide(color: Color(0xFFE2E8F0))),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedIdProof ?? "ID Proof", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                const Icon(Icons.expand_more, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ID Number Input
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _idNumberController,
                          decoration: InputDecoration(
                            hintText: "ID Number",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Parking Slot Selection
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showBottomSheet(parkingSlots, "Select Parking Slot Layout", (value) {
                      setState(() => selectedParkingSlot = value);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF49454F).withOpacity(0.04),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0), side: const BorderSide(color: Color(0xFFE2E8F0))),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedParkingSlot ?? "Select Parking Slot Layout", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                          const Icon(Icons.expand_more, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Address Section
                const Text("Parking Lot Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'HelveticaNeue')),
                const SizedBox(height: 8),

                // Address Input
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Parking Details
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _gpsCoordinateController,
                    decoration: InputDecoration(
                      hintText: "GPS Coordinate (Optional)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Working Hours
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Working Hours", style: TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal)),
                      Row(
                        children: [
                          _buildTimeButton(context, "From", _workingHoursFrom, "workingFrom"),
                          const SizedBox(width: 8),
                          const Text("–"), // En Dash
                          const SizedBox(width: 8),
                          _buildTimeButton(context, "To", _workingHoursTo, "workingTo"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Peak Hours
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Peak Hours", style: TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal)),
                      Row(
                        children: [
                          _buildTimeButton(context, "From", _peakHoursFrom, "peakFrom"),
                          const SizedBox(width: 8),
                          const Text("–"), // En Dash
                          const SizedBox(width: 8),
                          _buildTimeButton(context, "To", _peakHoursTo, "workingTo"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Length and Width of Plot
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _lengthController,
                          decoration: InputDecoration(
                            hintText: "Length of the Plot",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _widthController,
                          decoration: InputDecoration(
                            hintText: "Width of the Plot",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Number of Parking Spaces
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _totalSpacesController,
                    decoration: InputDecoration(
                      hintText: "Total Number of Parking Spaces",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 16),

                // Plot Type Dropdown
                GestureDetector(
                  onTap: () => _showPlotTypeBottomSheet(context, (value) {
                    setState(() => _selectedPlotType = value);
                  }),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF49454F).withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedPlotType ?? "Plot Type", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                        const Icon(Icons.expand_more, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Features
                _buildSwitchTile("Shelter Included", _shelterIncluded, (value) => setState(() => _shelterIncluded = value)),
                _buildSwitchTile("Underground Parking", _undergroundParking, (value) => setState(() => _undergroundParking = value)),
                _buildSwitchTile("EV Charging", _evCharging, (value) => setState(() => _evCharging = value)),
                _buildSwitchTile("CCTV Included", _cctvIncluded, (value) => setState(() => _cctvIncluded = value)),
                _buildSwitchTile("Security Guards", _securityGuards, (value) => setState(() => _securityGuards = value)),
                _buildSwitchTile("Restroom Availability", _restroomAvailability, (value) => setState(() => _restroomAvailability = value)),

                // Pricing Details
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: const Text("Pricing Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'HelveticaNeue')),
                ),
                const SizedBox(height: 16),

                _buildPriceInput("Hourly Price", _hourlyPriceController),
                const SizedBox(height: 8),
                _buildPriceInput("Peak Hours Price", _peakHoursPriceController),
                const SizedBox(height: 8),
                _buildPriceInput("Daily Price", _dailyPriceController),
                const SizedBox(height: 16),

                // Upload Media - Now Navigates to UploadMediaScreen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadMediaScreen()));
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Upload Media",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'HelveticaNeue')),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Options - Modified to match Upload Media Button
                GestureDetector(
                  onTap: () {
                    // TODO: Implement Payment Options functionality here
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Payment Options",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'HelveticaNeue')),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _confirmOwnership,
                        onChanged: (bool? value) => setState(() => _confirmOwnership = value!),
                        checkColor: Colors.white,
                        fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.black : Colors.transparent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal, height: 24 / 14),
                            children: <TextSpan>[
                              TextSpan(text: "I confirm that I am the rightful owner of "),
                              TextSpan(text: "this parking lot ", style: TextStyle(color: Color(0xFF1A202C), fontWeight: FontWeight.bold)),
                              TextSpan(text: "and have the legal authority to list it on this platform. I accept full responsibility for the accuracy of the provided information, and I acknowledge that "),
                              TextSpan(text: "ParkSpot ", style: TextStyle(color: Color(0xFF1A202C), fontWeight: FontWeight.bold)),
                              TextSpan(text: "is not liable for any legal disputes regarding ownership or usage rights."),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        onChanged: (bool? value) => setState(() => _agreeTerms = value!),
                        checkColor: Colors.white,
                        fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.black : Colors.transparent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Color(0xFF718096), fontSize: 14, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal, height: 24 / 14),
                            children: <TextSpan>[
                              TextSpan(text: "I agree to the "),
                              TextSpan(text: "Terms and Conditions ", style: TextStyle(color: Color(0xFF1A202C), fontWeight: FontWeight.bold)),
                              TextSpan(text: "and confirm that all provided information is accurate."),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Submit action
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Parking Registration Submitted!")));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'HelveticaNeue',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
