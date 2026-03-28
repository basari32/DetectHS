import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSendReportPage extends StatefulWidget {
  const UserSendReportPage({super.key});

  @override
  State<UserSendReportPage> createState() => _UserSendReportPageState();
}

class _UserSendReportPageState extends State<UserSendReportPage> {
  String? latitude, longitude;
  File? audioFile;
  bool isLoading = false;
  bool isLocationFetching = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // --- FETCHING GPS COORDINATES ---
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please enable location services");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      isLocationFetching = false;
    });
  }

  // --- PICKING AUDIO EVIDENCE ---
  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });
    }
  }

  // --- TRANSMITTING TO DJANGO ---
  Future<void> _sendIncidentReport() async {
    if (audioFile == null || latitude == null) {
      Fluttertoast.showToast(msg: "Location or Audio evidence missing");
      return;
    }

    setState(() => isLoading = true);
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";
    String aid = sh.getString('aid') ?? ""; // Authority ID from SharedPref

    try {
      var request = http.MultipartRequest("POST", Uri.parse('$url/SendReport/'));
      request.fields['lid'] = lid;
      request.fields['Authority'] = aid;
      request.fields['latitude'] = latitude!;
      request.fields['longitude'] = longitude!;

      request.files.add(await http.MultipartFile.fromPath('Audio', audioFile!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Incident Transmitted to Command Center");
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Transmission Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("INCIDENT TERMINAL", style: TextStyle(letterSpacing: 2, fontSize: 12)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 30),
            _buildAudioPicker(),
            const Spacer(),
            _buildTransmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
              const SizedBox(width: 10),
              Text(isLocationFetching ? "ACQUIRING GPS..." : "LOCATION SECURED",
                  style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5)),
            ],
          ),
          if (!isLocationFetching) ...[
            const SizedBox(height: 15),
            Text("LAT: $latitude", style: const TextStyle(color: Colors.white24, fontSize: 12)),
            Text("LON: $longitude", style: const TextStyle(color: Colors.white24, fontSize: 12)),
          ]
        ],
      ),
    );
  }

  Widget _buildAudioPicker() {
    return InkWell(
      onTap: _pickAudio,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: audioFile != null ? Colors.greenAccent : Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(audioFile != null ? Icons.audiotrack : Icons.mic_none,
                color: audioFile != null ? Colors.greenAccent : Colors.white24, size: 40),
            const SizedBox(height: 10),
            Text(audioFile != null ? "AUDIO RECORDING ATTACHED" : "ATTACH AUDIO EVIDENCE",
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: isLoading ? null : _sendIncidentReport,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("INITIALIZE TRANSMISSION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}