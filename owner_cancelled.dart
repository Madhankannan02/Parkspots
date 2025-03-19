import 'package:flutter/material.dart';
import 'owner_home_screen.dart';
import 'owner_completed.dart'; // Import the completed screen

class OwnerCancelledScreen extends StatefulWidget {
  const OwnerCancelledScreen({Key? key}) : super(key: key);

  @override
  State<OwnerCancelledScreen> createState() => _OwnerCancelledScreenState();
}

class _OwnerCancelledScreenState extends State<OwnerCancelledScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Section
            Container(
              color: const Color(0xFFF3EDF7),
              padding: const EdgeInsets.all(16.0),
              child: _buildTopNavSection(),
            ),

            // Main Content Section (Cancelled Bookings)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Now your bookings by",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryButtons(context),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cancelledBookings.length,
                        itemBuilder: (context, index) {
                          return CancelledBookingCard(
                            name: cancelledBookings[index]['name']!,
                            licensePlate: cancelledBookings[index]['licensePlate']!,
                            address: cancelledBookings[index]['address']!,
                            timeRange: cancelledBookings[index]['timeRange']!,
                            imageUrl: cancelledBookings[index]['imageUrl']!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF3EDF7),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Helvetica Neue',
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Helvetica Neue',
          ),
          showUnselectedLabels: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        elevation: 0,
        splashColor: Colors.transparent,
        highlightElevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- Helper Function to Build the Top Navigation Section ---
  Widget _buildTopNavSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            "https://randomuser.me/api/portraits/men/46.jpg",
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hi, Welcome Back",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Helvetica Neue',
                color: Colors.grey,
              ),
            ),
            Text(
              "John Doe",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Helper Function to Build Category Buttons ---
  Widget _buildCategoryButtons(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 4.0,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                // Use pushReplacement for no transition
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                  const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Upcoming",
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                // Use pushReplacement for no transition
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                  const OwnerCompletedScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Completed",
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Cancelled"),
          ),
        ],
      ),
    );
  }
}

class CancelledBookingCard extends StatelessWidget {
  final String name;
  final String licensePlate;
  final String address;
  final String timeRange;
  final String imageUrl;

  const CancelledBookingCard({
    Key? key,
    required this.name,
    required this.licensePlate,
    required this.address,
    required this.timeRange,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl), // Use image URL
                ),
                const SizedBox(width: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
                const Spacer(),
                Text(
                  licensePlate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.location_on, color: Colors.yellow, size: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                      Text(
                        timeRange,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica Neue',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Fake Data List for Cancelled Bookings
const List<Map<String, String>> cancelledBookings = [
  {
    'name': "Alice Brown",
    'licensePlate': "KA 05 EF 4567",
    'address': "MG Road, Bangalore",
    'timeRange': "Tomorrow at 03:15 PM",
    'imageUrl': "https://randomuser.me/api/portraits/women/77.jpg",
  },
  {
    'name': "David Lee",
    'licensePlate': "AP 16 GH 8901",
    'address': "Gachibowli, Hyderabad",
    'timeRange': "Next week at 09:00 AM",
    'imageUrl': "https://randomuser.me/api/portraits/men/78.jpg",
  },
  {
    'name': "Sarah Wilson",
    'licensePlate': "TN 01 IJ 2345",
    'address': "Adyar, Chennai",
    'timeRange': "This Friday at 06:45 PM",
    'imageUrl': "https://randomuser.me/api/portraits/women/79.jpg",
  },
];
