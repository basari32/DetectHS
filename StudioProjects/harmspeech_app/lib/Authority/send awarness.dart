import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAwarenessPage extends StatefulWidget {
  const AddAwarenessPage({super.key});

  @override
  State<AddAwarenessPage> createState() => _AddAwarenessPageState();
}

class _AddAwarenessPageState extends State<AddAwarenessPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final punishmentController = TextEditingController();

  File? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadAwareness() async {
    if (titleController.text.isEmpty || _selectedFile == null) {
      Fluttertoast.showToast(msg: "Please fill required fields and select a file");
      return;
    }

    setState(() => _isUploading = true);
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";

    try {
      var request = http.MultipartRequest('POST', Uri.parse("$url/AddAwarness/"));
      request.fields['lid'] = lid;
      request.fields['title'] = titleController.text;
      request.fields['description'] = descController.text;
      request.fields['punishment'] = punishmentController.text;

      // Adding the image/document file
      request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Awareness Broadcasted");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("CREATE AWARENESS", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("BROADCAST DETAILS"),
            const SizedBox(height: 30),

            _buildTacticalField("CAMPAIGN TITLE", titleController, Icons.campaign_outlined),
            _buildTacticalField("DESCRIPTION", descController, Icons.description_outlined, maxLines: 4),
            _buildTacticalField("LEGAL PUNISHMENT / FINE", punishmentController, Icons.gavel_outlined),

            const SizedBox(height: 20),
            const Text("ATTACHMENT (IMAGE/INFOGRAPHIC)",
                style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF00D4FF).withValues(alpha: 0.2)),
                ),
                child: _selectedFile == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Color(0xFF00D4FF), size: 40),
                    SizedBox(height: 10),
                    Text("Tap to select file", style: TextStyle(color: Colors.white24, fontSize: 12)),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(_selectedFile!, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isUploading ? null : uploadAwareness,
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("BROADCAST TO HUB",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 15, color: const Color(0xFF00D4FF)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildTacticalField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF00D4FF).withValues(alpha: 0.4), size: 18),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
            ),
          ),
        ],
      ),
    );
  }
}