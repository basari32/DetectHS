import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class AudioUploadPage extends StatefulWidget {
  const AudioUploadPage({Key? key}) : super(key: key);

  @override
  State<AudioUploadPage> createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> {
  File? _selectedFile;
  String? _fileName;
  bool _loading = false;

  // Location variables
  String? latitude;
  String? longitude;
  bool _isLocating = true;

  String currentDate = DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // ---------- FETCH GPS LOCATION ----------
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnack("Location services are disabled.");
      setState(() => _isLocating = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnack("Location permissions are denied.");
        setState(() => _isLocating = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnack("Location permissions are permanently denied.");
      setState(() => _isLocating = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        _isLocating = false;
      });
    } catch (e) {
      showSnack("Failed to acquire GPS lock");
      setState(() => _isLocating = false);
    }
  }

  // ---------- PICK AUDIO ----------
  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      showSnack("Acoustic selection failed");
    }
  }

  // ---------- UPLOAD AUDIO ----------
  Future<void> uploadAudio() async {
    if (_selectedFile == null) {
      showSnack("Please select an audio file to analyze");
      return;
    }

    if (latitude == null || longitude == null) {
      showSnack("Cannot initiate analysis without a secure GPS lock");
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString("url");
      final lid = prefs.getString("lid");

      if (baseUrl == null || lid == null) {
        showSnack("System Error: Server URL or Node ID missing");
        setState(() => _loading = false);
        return;
      }

      final uri = Uri.parse("$baseUrl/audioupload/");
      var request = http.MultipartRequest("POST", uri);

      // Sending ID and Location data
      request.fields['lid'] = lid;
      request.fields['latitude'] = latitude!;
      request.fields['longitude'] = longitude!;

      // Sending Audio File
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _selectedFile!.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData["status"] == "ok") {
          if (!mounted) return;
          showResultDialog(
            jsonData["result"].toString(),
            jsonData["confidence"].toString(),
          );
        } else {
          showSnack("AI Prediction failed");
        }
      } else {
        showSnack("Server transmission error");
      }
    } catch (e) {
      showSnack("Server connection failed");
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ---------- RESULT DIALOG ----------
  void showResultDialog(String result, String confidence) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
            "ANALYSIS COMPLETE",
            style: TextStyle(color: Colors.redAccent, letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.bold)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow("PREDICTION MODEL OUTPUT", result.toUpperCase(), Colors.white),
            const SizedBox(height: 10),
            _buildResultRow("CONFIDENCE LEVEL", "$confidence%", Colors.greenAccent),
            const SizedBox(height: 15),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            Text("TIMESTAMP: $currentDate", style: const TextStyle(color: Colors.white24, fontSize: 10)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ACKNOWLEDGE", style: TextStyle(color: Colors.white38, letterSpacing: 1)),
          )
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: valColor, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------- SNACKBAR HELPER ----------
  void showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
        )
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("ACOUSTIC ANALYSIS", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // TOP STATUS BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          color: _isLocating ? Colors.orangeAccent : Colors.greenAccent,
                          shape: BoxShape.circle
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                        _isLocating ? "ACQUIRING GPS LOCK..." : "SYSTEM: ACTIVE",
                        style: TextStyle(
                            color: _isLocating ? Colors.orangeAccent : Colors.greenAccent,
                            fontSize: 9,
                            letterSpacing: 1
                        )
                    ),
                  ],
                ),
                Text(currentDate, style: const TextStyle(color: Colors.white24, fontSize: 9)),
              ],
            ),

            // Location Display (Optional, for visual confirmation)
            if (!_isLocating && latitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.white24, size: 10),
                    const SizedBox(width: 5),
                    Text("LAT: $latitude  LON: $longitude", style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // CENTRAL ANALYSIS BOX
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Visual "Waveform" Icon changes based on state
                    Icon(
                      _loading
                          ? Icons.memory
                          : (_selectedFile != null ? Icons.graphic_eq : Icons.mic_none_rounded),
                      size: 80,
                      color: _loading
                          ? Colors.orangeAccent
                          : (_selectedFile != null ? Colors.redAccent : Colors.white10),
                    ),
                    const SizedBox(height: 20),
                    if (_loading)
                      const Text("ANALYZING ACOUSTIC SIGNATURE...", style: TextStyle(color: Colors.orangeAccent, fontSize: 10, letterSpacing: 2))
                    else if (_fileName != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _fileName!.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      const Text("NO AUDIO DATA SELECTED", style: TextStyle(color: Colors.white10, fontSize: 10, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ACTION BUTTONS
            _buildTacticalButton(
              label: "SELECT AUDIO SOURCE",
              onPressed: _loading ? null : pickAudio,
              color: const Color(0xFF161B22),
              textColor: Colors.white,
              icon: Icons.folder_open,
            ),
            const SizedBox(height: 15),
            _buildTacticalButton(
              label: "INITIALIZE ANALYSIS",
              onPressed: _loading || _isLocating ? null : uploadAudio,
              color: Colors.redAccent,
              textColor: Colors.white,
              icon: Icons.analytics_outlined,
              showLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTacticalButton({
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    required Color textColor,
    required IconData icon,
    bool showLoading = false
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          disabledBackgroundColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: showLoading ? const SizedBox() : Icon(icon, size: 20),
        label: showLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13)),
      ),
    );
  }
}