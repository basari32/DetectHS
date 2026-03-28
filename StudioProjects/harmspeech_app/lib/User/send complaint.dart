import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSendComplaintPage extends StatefulWidget {
  const UserSendComplaintPage({super.key});

  @override
  State<UserSendComplaintPage> createState() => _UserSendComplaintPageState();
}

class _UserSendComplaintPageState extends State<UserSendComplaintPage> {
  final complaintController = TextEditingController();
  List<dynamic> authorityList = [];
  String? selectedAuthorityId;
  bool _isLoading = false;
  bool _isFetchingAuth = true;

  @override
  void initState() {
    super.initState();
    // fetchAuthorities();
  }

  // Fetching authorities to route the complaint correctly
  // Future<void> fetchAuthorities() async {
  //   final sh = await SharedPreferences.getInstance();
  //   String url = sh.getString('url') ?? "";
  //   try {
  //     final response = await http.get(Uri.parse('$url/view_authorities_user/'));
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       setState(() {
  //         authorityList = data['data'];
  //         _isFetchingAuth = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() => _isFetchingAuth = false);
  //     debugPrint("Auth Fetch Error: $e");
  //   }
  // }

  // --- YOUR DJANGO LOGIC INTEGRATION ---
  Future<void> submitComplaint() async {
    if (complaintController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please select an authority and enter details");
      return;
    }

    setState(() => _isLoading = true);
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";
    String aid = sh.getString('aid') ?? "";

    try {
      final response = await http.post(
        Uri.parse('$url/SendComplaint/'),
        body: {
          'lid': lid,
          'authority': aid,
          'complaint': complaintController.text,
        },
      );

      if (jsonDecode(response.body)['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Grievance Transmitted Successfully");
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("FILE COMPLAINT", style: TextStyle(letterSpacing: 2, fontSize: 12)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildSectionHeader("RECIPIENT UNIT"),
            // const SizedBox(height: 15),

            // Authority Dropdown Box
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF0D1117),
            //     borderRadius: BorderRadius.circular(15),
            //     border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            //   ),
            //   child: _isFetchingAuth
            //       ? const LinearProgressIndicator(color: Colors.orangeAccent)
            //       : DropdownButtonHideUnderline(
            //     child: DropdownButton<String>(
            //       dropdownColor: const Color(0xFF0D1117),
            //       value: selectedAuthorityId,
            //       hint: const Text("Select Department", style: TextStyle(color: Colors.white24, fontSize: 13)),
            //       isExpanded: true,
            //       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.orangeAccent),
            //       items: authorityList.map((auth) {
            //         return DropdownMenuItem<String>(
            //           value: auth['id'].toString(),
            //           child: Text(auth['name'], style: const TextStyle(color: Colors.white, fontSize: 14)),
            //         );
            //       }).toList(),
            //       onChanged: (val) => setState(() => selectedAuthorityId = val),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 40),
            _buildSectionHeader("COMPLAINT CONTENT"),
            const SizedBox(height: 15),

            // Tactical Input Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: TextField(
                controller: complaintController,
                maxLines: 8,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Enter the details of the incident or grievance...",
                  hintStyle: TextStyle(color: Colors.white10),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : submitComplaint,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("SUBMIT COMPLAINT",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
        Container(width: 3, height: 12, color: Colors.orangeAccent),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 2)),
      ],
    );
  }
}