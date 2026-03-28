import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Ensure these paths match your project structure exactly
import 'user_registration.dart';
import 'Authority/home.dart';
import 'User/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController UsernameController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  bool _isObscured = true;
  bool _isLoading = false;

  // Custom Slider Variables
  double _dragPosition = 0.0;
  bool _isDragging = false;
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Tactical Deep Black
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            width: 500, // Pinterest-style fixed width card
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
                color: const Color(0xFF0D1117), // Lighter "Box" Grey
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.02),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  "OPERATOR LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  "URBAN ACOUSTIC INTELLIGENCE // SECURE ACCESS",
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 50),

                // Username Field
                _buildTacticalField(
                  label: "USERNAME",
                  controller: UsernameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 25),

                // Password Field
                _buildTacticalField(
                  label: "SECURITY PASSKEY",
                  controller: PasswordController,
                  icon: Icons.lock_outline,
                  isPass: true,
                ),
                const SizedBox(height: 50),

                // Custom Tactical Slider Auth
                _buildTacticalSliderAuth(),

                const SizedBox(height: 30),

                // Signup Redirect
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No credentials?",
                        style: TextStyle(color: Colors.white24, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00D4FF),
                              fontSize: 12,
                              letterSpacing: 1
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE TACTICAL FIELD ---
  Widget _buildTacticalField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPass = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white38, fontSize: 9, letterSpacing: 1.5)),
        TextField(
          controller: controller,
          obscureText: isPass && _isObscured,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white24, size: 18),
            suffixIcon: isPass
                ? IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.white24,
                size: 18,
              ),
              onPressed: () => setState(() => _isObscured = !_isObscured),
            )
                : null,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
          ),
        ),
      ],
    );
  }

  // --- CUSTOM TACTICAL SLIDER ---
  Widget _buildTacticalSliderAuth() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 60 is the height of the container, so we make the thumb a 60x60 square/circle
        const double thumbSize = 60.0;
        final double maxDragDistance = constraints.maxWidth - thumbSize;

        // Calculate percentage of slide (0.0 to 1.0) for fading text
        double dragRatio = maxDragDistance == 0 ? 0 : (_dragPosition / maxDragDistance).clamp(0.0, 1.0);

        return Container(
          height: thumbSize,
          decoration: BoxDecoration(
            color: const Color(0xFF00D4FF).withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
          ),
          child: Stack(
            children: [
              // 1. Fading Text Layer
              Center(
                child: Opacity(
                  // Text fades out as you drag
                  opacity: (1.0 - (dragRatio * 1.5)).clamp(0.0, 1.0),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00D4FF)))
                      : const Text(
                    "SLIDE TO AUTHENTICATE",
                    style: TextStyle(color: Color(0xFF00D4FF), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),

              // 2. The Draggable Thumb
              AnimatedPositioned(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                left: _dragPosition,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanStart: _isLoading ? null : (details) {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onPanUpdate: _isLoading ? null : (details) {
                    setState(() {
                      _dragPosition += details.delta.dx;
                      // Constrain the drag within the box
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxDragDistance) _dragPosition = maxDragDistance;

                      // Change icon to unlock when dragged past 85%
                      _isUnlocked = _dragPosition > (maxDragDistance * 0.85);
                    });
                  },
                  onPanEnd: _isLoading ? null : (details) {
                    setState(() {
                      _isDragging = false;
                      if (_isUnlocked) {
                        // Success! Lock it to the right and trigger login
                        _dragPosition = maxDragDistance;
                        sendData();
                      } else {
                        // Failed. Snap back to the beginning
                        _dragPosition = 0.0;
                      }
                    });
                  },
                  child: Container(
                    width: thumbSize,
                    decoration: BoxDecoration(
                        color: _isUnlocked ? Colors.greenAccent : const Color(0xFF00D4FF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isUnlocked ? Colors.greenAccent : const Color(0xFF00D4FF)).withOpacity(0.4),
                            blurRadius: 15,
                          )
                        ]
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                        key: ValueKey<bool>(_isUnlocked), // Key is required for AnimatedSwitcher
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LOGIN LOGIC ---
  Future<void> sendData() async {
    String username = UsernameController.text.trim();
    String password = PasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      // Reset Slider
      setState(() { _dragPosition = 0.0; _isUnlocked = false; });
      return;
    }

    setState(() { _isLoading = true; });

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null) {
      Fluttertoast.showToast(msg: 'Base URL not set');
      setState(() { _isLoading = false; _dragPosition = 0.0; _isUnlocked = false; });
      return;
    }

    final api = Uri.parse('$url/FlutterLogin/');

    try {
      final response = await http.post(api, body: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'User') {
          await sh.setString('lid', data['lid'].toString());
          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHome()));
        } else if (data['status'] == 'authority') {
          await sh.setString('lid', data['lid'].toString());
          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UAIHome()));
        } else {
          Fluttertoast.showToast(msg: 'Invalid credentials detected');
          setState(() { _dragPosition = 0.0; _isUnlocked = false; }); // Reset slider on failure
        }
      } else {
        Fluttertoast.showToast(msg: 'Server connection error');
        setState(() { _dragPosition = 0.0; _isUnlocked = false; }); // Reset slider on failure
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Network Error');
      setState(() { _dragPosition = 0.0; _isUnlocked = false; }); // Reset slider on failure
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }
}