import 'package:flutter/material.dart';
import 'sign_up.dart'; // Import the SignUpScreen

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle back navigation
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Hey! Welcome back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sign In to your account",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // Added stroke
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // Added stroke
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign in
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade400),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or login with",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade400),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle sign in with Apple
                  },
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // Added stroke
                      foregroundColor: Colors.black),

                  icon: const Icon(Icons.apple, color: Colors.black,),
                  label: Text(
                    "Log In with Apple",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Made bold
                      fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle sign in with Google
                  },
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0), // Added stroke
                      foregroundColor: Colors.black),
                  icon: Image.asset('assets/google_icon.png', width: 24, height: 24),
                  label: Text(
                    "Log In with Google",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Made bold
                      fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to SignUpScreen without animation
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => SignUpScreen(),
                          transitionDuration: Duration.zero, // Remove transition animation
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600, // Made bold
                        fontFamily: 'HelveticaNeue', // Apply Helvetica Neue
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
