import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  String gender = "Male";
  bool isLoading = false;
  Uint8List? webImage;
  XFile? pickedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (kIsWeb) webImage = await pickedImage!.readAsBytes();
      setState(() {});
    }
  }

  Future<void> selectDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00D4FF),
              onPrimary: Colors.black,
              surface: Color(0xFF0D1117),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> registerUser() async {
    // --- COMPREHENSIVE VALIDATION ---
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String uname = usernameController.text.trim();
    String pwd = passwordController.text.trim();

    if (pickedImage == null) {
      Fluttertoast.showToast(msg: "ID Photo Required");
      return;
    }
    if (name.isEmpty || email.isEmpty || phone.isEmpty || uname.isEmpty || pwd.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Fluttertoast.showToast(msg: "Invalid Email Format");
      return;
    }
    if (phone.length < 10) {
      Fluttertoast.showToast(msg: "Invalid Phone Number");
      return;
    }

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString("url");

    try {
      var uri = Uri.parse("$baseUrl/user_registration/");
      var request = http.MultipartRequest("POST", uri);

      request.fields['name'] = name;
      request.fields['Gender'] = gender;
      request.fields['dob'] = dobController.text;
      request.fields['Email'] = email;
      request.fields['username'] = uname;
      request.fields['password'] = pwd;
      request.fields['phone'] = phone;

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes('photo', webImage!, filename: "photo.jpg"));
      } else {
        request.files.add(await http.MultipartFile.fromPath('photo', pickedImage!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        Fluttertoast.showToast(msg: 'Registration Successful');
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      } else if (data['status'] == 'username_exists') {
        Fluttertoast.showToast(msg: 'Username already taken');
      } else {
        Fluttertoast.showToast(msg: 'Registration Failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildImagePicker(),
                const SizedBox(height: 25),
                _buildTacticalField("FULL NAME", nameController, Icons.person_outline),
                _buildGenderSelector(),
                _buildTacticalField("DATE OF BIRTH", dobController, Icons.event, readOnly: true, onTap: selectDOB),
                _buildTacticalField("EMAIL ADDRESS", emailController, Icons.email_outlined, type: TextInputType.emailAddress),
                _buildTacticalField("PHONE NO", phoneController, Icons.phone_android, type: TextInputType.phone),
                _buildTacticalField("USERNAME", usernameController, Icons.alternate_email),
                _buildTacticalField("SECURITY PASSKEY", passwordController, Icons.lock_outline, isPass: true),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("NODE REGISTRATION", style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
        SizedBox(height: 5),
        Text("URBAN ACOUSTIC INTELLIGENCE // INITIALIZE", style: TextStyle(color: Color(0xFF00D4FF), fontSize: 8, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: pickImage,
        child: Container(
          height: 90, width: 90,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
          ),
          child: (pickedImage == null)
              ? const Icon(Icons.camera_enhance_outlined, color: Color(0xFF00D4FF), size: 28)
              : ClipRRect(borderRadius: BorderRadius.circular(19), child: kIsWeb ? Image.memory(webImage!, fit: BoxFit.cover) : Image.file(File(pickedImage!.path), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const Text("GENDER: ", style: TextStyle(color: Colors.white38, fontSize: 9)),
          Radio(value: "Male", groupValue: gender, activeColor: const Color(0xFF00D4FF), onChanged: (v) => setState(() => gender = v!)),
          const Text("M", style: TextStyle(color: Colors.white70, fontSize: 12)),
          Radio(value: "Female", groupValue: gender, activeColor: const Color(0xFF00D4FF), onChanged: (v) => setState(() => gender = v!)),
          const Text("F", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : registerUser,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D4FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : const Text("ACTIVATE ACCOUNT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTacticalField(String label, TextEditingController ctrl, IconData icon, {bool isPass = false, bool readOnly = false, VoidCallback? onTap, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1.5)),
          TextField(
            controller: ctrl,
            obscureText: isPass,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: type,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white24, size: 18),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D4FF))),
            ),
          ),
        ],
      ),
    );
  }
}