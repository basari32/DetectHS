import 'package:flutter/material.dart';

class UAIReplyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Deep tactical black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00D4FF), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("COMMUNICATION TERMINAL",
            style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w300)),
      ),
      body: Row(
        children: [
          // LEFT SIDE: COMPLAINT SUMMARY BOX
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117), // Slightly lighter tactical box
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge("PENDING_RESPONSE"),
                  const SizedBox(height: 30),
                  const Text("ORIGINAL FEEDBACK",
                      style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  const Text(
                    "High noise levels detected near Malappuram Market Sector 4. AI accuracy seems lower than usual in this zone.",
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                  ),
                  const Spacer(),
                  const Divider(color: Colors.white12),
                  _buildMetadataRow("OPERATOR ID", "ADMIN_ALPHA_77"),
                  _buildMetadataRow("LOCATION", "KERALA_HUB_MAL"),
                ],
              ),
            ),
          ),

          // RIGHT SIDE: REPLY INPUT BOX
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 24, 24),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117).withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00D4FF).withOpacity(0.02), blurRadius: 40)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SEND RESPONSE",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 40),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(color: Colors.white, height: 1.5),
                      decoration: InputDecoration(
                        hintText: "Enter official response for user terminal...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSendButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00D4FF), Color(0xFF9D00FF)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00D4FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("TRANSMIT REPLY", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1)),
            SizedBox(width: 10),
            Icon(Icons.send_rounded, color: Colors.black, size: 18),
          ],
        ),
      ),
    );
  }
}