import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserViewAwarenessPage extends StatefulWidget {
  const UserViewAwarenessPage({super.key});

  @override
  State<UserViewAwarenessPage> createState() => _UserViewAwarenessPageState();
}

class _UserViewAwarenessPageState extends State<UserViewAwarenessPage> {
  List<dynamic> awarenessList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAwareness();
  }

  Future<void> fetchAwareness() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String imgBaseUrl = sh.getString('img_url') ?? "";

    try {
      final response = await http.get(Uri.parse('$url/UserViewAwarness/'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            awarenessList = data['data'].map((item) {
              item['file'] = imgBaseUrl + item['file']; // Construct full image URL
              return item;
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Awareness Fetch Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SAFETY BROADCASTS",
            style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.w300)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
          : awarenessList.isEmpty
          ? const Center(child: Text("No broadcasts found", style: TextStyle(color: Colors.white24)))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: awarenessList.length,
        itemBuilder: (context, index) {
          final item = awarenessList[index];
          return _buildAwarenessCard(item);
        },
      ),
    );
  }

  Widget _buildAwarenessCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BROADCAST IMAGE / INFOGRAPHIC
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Image.network(
              item['file'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.white10,
                child: const Icon(Icons.broken_image_outlined, color: Colors.white24),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['added_by'].toString().toUpperCase(),
                        style: const TextStyle(color: Color(0xFF00D4FF), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    Text(item['date'].toString().split('T')[0],
                        style: const TextStyle(color: Colors.white10, fontSize: 9)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'].toString().toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  item['description'],
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),

                // PUNISHMENT / LEGAL WARNING BOX
                if (item['punishment'] != null && item['punishment'].toString().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gavel_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("LEGAL CONSEQUENCE",
                                  style: TextStyle(color: Colors.redAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(item['punishment'],
                                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}