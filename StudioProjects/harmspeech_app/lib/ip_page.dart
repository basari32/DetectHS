import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main() {
  runApp(const SpeechAiApp());
}

class SpeechAiApp extends StatelessWidget {
  const SpeechAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Updated Global Theme for dark mode consistency
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00D4FF),
      ),
      home: const IpPage(),
    );
  }
}

class IpPage extends StatefulWidget {
  const IpPage({super.key});

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  TextEditingController ipcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? savedIp = sh.getString('ip_address');
    if (savedIp != null) {
      setState(() {
        ipcontroller.text = savedIp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Tactical Deep Black
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            width: 500, // Fixed width card
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117), // Lighter Box Grey
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.02),
                  blurRadius: 40,
                  spreadRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                const Center(
                  child: Icon(
                    Icons.lan_rounded,
                    size: 60,
                    color: Color(0xFF00D4FF),
                  ),
                ),
                const SizedBox(height: 30),

                // Header
                const Text(
                  "SERVER CONFIG",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  "ESTABLISH CONNECTION TO KERALA_HUB_PRIMARY",
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // IP Input Field
                const Text(
                  "IPV4 ADDRESS",
                  style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: ipcontroller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1),
                  decoration: InputDecoration(
                    hintText: 'e.g. 192.168.1.5',
                    hintStyle: const TextStyle(color: Colors.white10),
                    prefixIcon: const Icon(Icons.dns_outlined, color: Colors.white24, size: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00D4FF)),
                    ),
                    filled: true,
                    fillColor: Colors.black26,
                  ),
                ),

                const SizedBox(height: 35),

                // Connect Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: sendData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 10,
                      shadowColor: const Color(0xFF00D4FF).withOpacity(0.3),
                    ),
                    child: const Text(
                      'CONNECT TO HUB',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Server Hint
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text(
                      "PROTOCOL: HTTP // PORT: 8000 // STATUS: STANDBY",
                      style: TextStyle(fontSize: 8, color: Colors.white38, letterSpacing: 1),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendData() async {
    String ip = ipcontroller.text.trim();

    if (ip.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter the IP address');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();

    await sh.setString("ip_address", ip);
    await sh.setString("url", "http://$ip:8000/myapp");
    await sh.setString("img_url", "http://$ip:8000");

    Fluttertoast.showToast(msg: 'UAI Hub Connection Established');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}