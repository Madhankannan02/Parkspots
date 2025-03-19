import 'package:flutter/material.dart';
import 'owner_cancelled.dart';
import 'owner_home_screen.dart';// Import the cancelled screen

class OwnerCompletedScreen extends StatefulWidget {
  const OwnerCompletedScreen({Key? key}) : super(key: key);

  @override
  State<OwnerCompletedScreen> createState() => _OwnerCompletedScreenState();
}

class _OwnerCompletedScreenState extends State<OwnerCompletedScreen> {
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
                        itemCount: completedBookings.length,
                        itemBuilder: (context, index) {
                          return CompletedBookingCard(
                            name: completedBookings[index]['name']!,
                            licensePlate: completedBookings[index]['licensePlate']!,
                            address: completedBookings[index]['address']!,
                            timeRange: completedBookings[index]['timeRange']!,
                            imageUrl: completedBookings[index]['imageUrl']!,
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
              Navigator.pushReplacement( // Use pushReplacement for no transition
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Upcoming", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Completed"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement( // Use pushReplacement for no transition
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const OwnerCancelledScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontFamily: 'Helvetica Neue'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("Cancelled", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class CompletedBookingCard extends StatelessWidget {
  final String name;
  final String licensePlate;
  final String address;
  final String timeRange;
  final String imageUrl;

  const CompletedBookingCard({
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
const List<Map<String, String>> completedBookings = [
  {
    'name': "Jane Smith",
    'licensePlate': "DL 12 AB 1234",
    'address': "Connaught Place, New Delhi",
    'timeRange': "Tomorrow at 10:00 AM",
    'imageUrl': "https://randomuser.me/api/portraits/women/75.jpg",
  },
  {
    'name': "Robert Johnson",
    'licensePlate': "MH 04 CD 5678",
    'address': "Bandra West, Mumbai",
    'timeRange': "Next week at 02:30 PM",
    'imageUrl': "https://randomuser.me/api/portraits/men/76.jpg",
  },
];
