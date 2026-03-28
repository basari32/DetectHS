import 'package:flutter/material.dart';

class UAIRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Deepest tactical black base
      body: Row(
        children: [
          // LEFT SIDE: REGISTRATION HUB VISUALS
          Expanded(
            flex: 5,
            child: Container(
              color: const Color(0xFF05070A),
              child: Stack(
                children: [
                  // Tactical Grid Background
                  const TacticalGridPainter(),

                  // Floating HUD for Hub Info
                  Positioned(
                    top: 60,
                    left: 60,
                    child: _buildHubTelemetry(),
                  ),

                  // Center Graphic: Personnel Onboarding Icon
                  Center(
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      color: const Color(0xFF00D4FF).withOpacity(0.1),
                      size: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT SIDE: THE REGISTRATION BOX
          Expanded(
            flex: 5,
            child: Container(
              color: const Color(0xFF0D1117), // Slightly lighter "Box" gray-black
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 50),

                    // Registration Fields
                    _buildInputField("FULL NAME", "e.g. Rahul Sharma"),
                    const SizedBox(height: 25),
                    _buildInputField("OFFICIAL EMAIL", "personnel@uai.gov.in"),
                    const SizedBox(height: 25),
                    _buildInputField("PERSONNEL ID", "ID_KOT_XXXX"),
                    const SizedBox(height: 25),
                    _buildInputField("ASSIGNED SECTOR", "Select Sector"),
                    const SizedBox(height: 25),
                    _buildInputField("ENCRYPTION KEY", "••••••••", isPassword: true),

                    const SizedBox(height: 50),

                    // Submit Action
                    _buildRegisterButton(),

                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("ALREADY REGISTERED? LOG IN",
                            style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PERSONNEL ONBOARDING",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w300, letterSpacing: -1)),
        SizedBox(height: 8),
        Text("ESTABLISH NEW OPERATOR CREDENTIALS // MALAPPURAM UNIT",
            style: TextStyle(color: Color(0xFF00D4FF), fontSize: 9, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white12),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF00D4FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00D4FF).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: const Center(
        child: Text("INITIALIZE ACCOUNT",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
      ),
    );
  }

  Widget _buildHubTelemetry() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFF00D4FF), width: 3)),
        color: Colors.black45,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("REGISTRATION NODE", style: TextStyle(color: Color(0xFF00D4FF), fontSize: 8, letterSpacing: 2)),
          Text("HUB // KERALA_NORTH_01", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }
}

class TacticalGridPainter extends StatelessWidget {
  const TacticalGridPainter({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: Container(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white.withOpacity(0.02)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}