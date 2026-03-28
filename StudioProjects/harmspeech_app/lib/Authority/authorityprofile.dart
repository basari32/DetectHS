import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AuthorityProfilePage extends StatefulWidget {
  const AuthorityProfilePage({super.key});

  @override
  State<AuthorityProfilePage> createState() => _AuthorityProfilePageState();
}

class _AuthorityProfilePageState extends State<AuthorityProfilePage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final posCtrl = TextEditingController();
  final dobCtrl = TextEditingController();

  String gender = "Male";
  String photoUrl = "";
  File? _selectedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";
    String imgUrl = sh.getString('img_url') ?? "";

    try {
      var res = await http.post(Uri.parse("$url/authorityProfile/"), body: {'lid': lid});
      var data = jsonDecode(res.body);

      if (data['status'] == 'ok' && mounted) {
        setState(() {
          nameCtrl.text = data['data']['name'].toString();
          phoneCtrl.text = data['data']['phoneNo'].toString();
          emailCtrl.text = data['data']['Email'].toString();
          posCtrl.text = data['data']['position'].toString();
          dobCtrl.text = data['data']['dob'].toString();
          gender = data['data']['gender'].toString();
          photoUrl = imgUrl + data['data']['photo'].toString();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      Fluttertoast.showToast(msg: "Fetch Error: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateProfile() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url')!;
    String lid = sh.getString('lid')!;

    var request = http.MultipartRequest('POST', Uri.parse("$url/AuthorityupdateProfile/"));
    request.fields['lid'] = lid;
    request.fields['name'] = nameCtrl.text;
    request.fields['phone'] = phoneCtrl.text;
    request.fields['email'] = emailCtrl.text;
    request.fields['position'] = posCtrl.text;
    request.fields['dob'] = dobCtrl.text;
    request.fields['gender'] = gender;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
      Navigator.pop(context, true); // Send 'true' back to indicate change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("OFFICER PROFILE", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: const Color(0xFF00D4FF).withValues(alpha: 0.2),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null) as ImageProvider?,
                    ),
                    const Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: Color(0xFF00D4FF), radius: 18, child: Icon(Icons.camera_alt, size: 18, color: Colors.black)))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildTacticalField("FULL NAME", nameCtrl, Icons.person_outline),
            _buildTacticalField("CONTACT", phoneCtrl, Icons.phone_android_outlined),
            _buildTacticalField("EMAIL", emailCtrl, Icons.alternate_email),
            _buildTacticalField("POSITION", posCtrl, Icons.work_outline),
            _buildTacticalField("DATE OF BIRTH", dobCtrl, Icons.calendar_month_outlined),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D4FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: updateProfile,
                child: const Text("SAVE CHANGES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTacticalField(String label, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
          TextField(
            controller: ctrl,
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