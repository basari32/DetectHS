import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSendFeedbackPage extends StatefulWidget {
  const UserSendFeedbackPage({super.key});

  @override
  State<UserSendFeedbackPage> createState() => _UserSendFeedbackPageState();
}

class _UserSendFeedbackPageState extends State<UserSendFeedbackPage> {

  final feedbackController = TextEditingController();

  List<dynamic> authorityList = [];
  String? selectedAuthorityId;
  int _currentRating = 0;

  bool _isLoading = false;
  bool _isFetchingAuth = true;

  @override
  void initState() {
    super.initState();
    fetchAuthorities();
  }

  // ===============================
  // FETCH AUTHORITIES
  // ===============================
  Future<void> fetchAuthorities() async {
    try {
      final sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";

      final response =
      await http.get(Uri.parse('$url/UserViewAuthority/'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          authorityList = data['data'] ?? [];
          _isFetchingAuth = false;
        });
      } else {
        setState(() => _isFetchingAuth = false);
      }
    } catch (e) {
      setState(() => _isFetchingAuth = false);
      debugPrint("Authority fetch error: $e");
    }
  }

  // ===============================
  // SUBMIT FEEDBACK
  // ===============================
  Future<void> submitFeedback() async {

    if (selectedAuthorityId == null ||
        feedbackController.text.trim().isEmpty ||
        _currentRating == 0) {
      Fluttertoast.showToast(
          msg: "Please complete rating and feedback");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      final response = await http.post(
        Uri.parse('$url/SendFeedback/'),
        body: {
          'lid': lid,
          'authority': selectedAuthorityId,
          'feedback': feedbackController.text.trim(),
          'rating': _currentRating.toString(),
        },
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Feedback submitted successfully");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Submission failed");
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }

    setState(() => _isLoading = false);
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text(
          "SYSTEM FEEDBACK",
          style: TextStyle(letterSpacing: 2, fontSize: 12),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildSectionHeader("SYSTEM PERFORMANCE RATING"),
            const SizedBox(height: 20),
            _buildRatingStars(),

            const SizedBox(height: 40),
            _buildSectionHeader("RECIPIENT UNIT"),
            const SizedBox(height: 15),
            _buildAuthorityDropdown(),

            const SizedBox(height: 40),
            _buildSectionHeader("PERFORMANCE FEEDBACK"),
            const SizedBox(height: 15),
            _buildFeedbackInput(),

            const SizedBox(height: 50),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ===============================
  // STAR RATING
  // ===============================
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => setState(() => _currentRating = index + 1),
          icon: Icon(
            index < _currentRating
                ? Icons.bolt_rounded
                : Icons.bolt_outlined,
            color: index < _currentRating
                ? Colors.greenAccent
                : Colors.white10,
            size: 40,
          ),
        );
      }),
    );
  }

  // ===============================
  // AUTHORITY DROPDOWN
  // ===============================
  Widget _buildAuthorityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),

      child: _isFetchingAuth
          ? const Padding(
        padding: EdgeInsets.all(10),
        child: LinearProgressIndicator(
            color: Colors.greenAccent),
      )
          : DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF0D1117),
          value: selectedAuthorityId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Colors.greenAccent),

          hint: const Text(
            "Select Authority",
            style: TextStyle(
                color: Colors.white24, fontSize: 13),
          ),

          items: authorityList
              .map<DropdownMenuItem<String>>((auth) {
            return DropdownMenuItem<String>(
              value: auth['id'].toString(),
              child: Text(
                auth['auth_name']?.toString() ?? 'Unknown',
                style: const TextStyle(
                    color: Colors.white, fontSize: 14),
              ),
            );
          }).toList(),

          onChanged: (val) =>
              setState(() => selectedAuthorityId = val),
        ),
      ),
    );
  }

  // ===============================
  // FEEDBACK TEXT FIELD
  // ===============================
  Widget _buildFeedbackInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: feedbackController,
        maxLines: 6,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Write your feedback...",
          hintStyle: TextStyle(color: Colors.white10),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  // ===============================
  // SUBMIT BUTTON
  // ===============================
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoading ? null : submitFeedback,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : const Text(
          "SUBMIT FEEDBACK",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // ===============================
  // SECTION HEADER
  // ===============================
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 3, height: 12, color: Colors.greenAccent),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white38, fontSize: 9, letterSpacing: 2),
        ),
      ],
    );
  }
}
