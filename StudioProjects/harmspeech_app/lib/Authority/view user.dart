import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String imgBaseUrl = sh.getString('img_url') ?? "";

    try {
      final response = await http.get(Uri.parse('$url/view_user_authority/'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            // Mapping full image URL
            allUsers = data['data'].map((user) {
              user['photo'] = imgBaseUrl + user['photo'];
              return user;
            }).toList();
            filteredUsers = allUsers;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredUsers = allUsers
          .where((user) =>
      user['name'].toLowerCase().contains(query.toLowerCase()) ||
          user['Email'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("PERSONNEL DIRECTORY",
            style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.w300)),
      ),
      body: Column(
        children: [
          // TACTICAL SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search by name or email...",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00D4FF), size: 20),
                filled: true,
                fillColor: const Color(0xFF0D1117),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // USER GRID
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
                : filteredUsers.isEmpty
                ? const Center(child: Text("No users found", style: TextStyle(color: Colors.white24)))
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _buildUserPinterestCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPinterestCard(dynamic user) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER PHOTO
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                image: DecorationImage(
                  image: NetworkImage(user['photo']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // USER DETAILS
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'].toString().toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 4),
                Text(
                  user['Email'],
                  style: const TextStyle(color: Colors.white38, fontSize: 10, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user['Gender'],
                        style: const TextStyle(color: Color(0xFF00D4FF), fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}