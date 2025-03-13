import 'package:flutter/material.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF2196F3),
        ),
        useMaterial3: true,
      ),
      home: const UserSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'WELCOME TO\nPARKSPOT',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily: 'Helvetica Neue',
                    height: 1.125, // Line height of 45px (40px * 1.125)
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose your role to access the right features',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'Helvetica Neue',
                    height: 1.2, // Line height of 24px (20px * 1.2)
                  ),
                ),
                const Spacer(),
                _buildRoleCard(
                  context,
                  title: 'I Need Parking',
                  backgroundColor: const Color(0xFFEEEEEE),
                  textColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildRoleCard(
                  context,
                  title: 'I Have Parking',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required String title,
        required Color backgroundColor,
        required Color textColor,
        required VoidCallback onTap,
      }) {
    return SizedBox(
      height: 61,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
