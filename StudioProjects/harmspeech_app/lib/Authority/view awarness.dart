import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harmspeech_app/Authority/send%20awarness.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAwarenessPage extends StatefulWidget {
  const ViewAwarenessPage({super.key});

  @override
  State<ViewAwarenessPage> createState() => _ViewAwarenessPageState();
}

class _ViewAwarenessPageState extends State<ViewAwarenessPage> {

  List<dynamic> awarenessList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAwareness();
  }

  // ==============================
  // FETCH AWARENESS
  // ==============================
  Future<void> fetchAwareness() async {
    try {
      final sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      final response = await http.post(
        Uri.parse('$url/view_awarness/'),
        body: {'lid': lid},
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          awarenessList = data['data'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Awareness fetch error: $e");
      setState(() => isLoading = false);
    }
  }

  // ==============================
  // DELETE AWARENESS
  // ==============================
  Future<void> deleteAwareness(String id) async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";

    final response = await http.post(
      Uri.parse('$url/delete_awarness/'),
      body: {'id': id},
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      fetchAwareness(); // refresh list
    }
  }

  // ==============================
  // OPEN FILE
  // ==============================
  Future<void> openFile(String fileUrl) async {
    if (fileUrl.isEmpty) return;
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Awareness")),

      // ===== FLOATING ADD BUTTON =====
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to add awareness page
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddAwarenessPage()));
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : awarenessList.isEmpty
          ? const Center(child: Text("No awareness posts"))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: awarenessList.length,
        itemBuilder: (context, index) {
          final item = awarenessList[index];
          return buildCard(item);
        },
      ),
    );
  }

  // ==============================
  // CARD
  // ==============================
  Widget buildCard(dynamic item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['title']?.toString() ?? "",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // ===== DELETE BUTTON =====
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete"),
                        content: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteAwareness(item['id']);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),

            const SizedBox(height: 6),

            Text(item['description'] ?? ""),

            const SizedBox(height: 6),

            Text(
              "Punishment: ${item['punishment'] ?? ''}",
              style: const TextStyle(color: Colors.red),
            ),

            const SizedBox(height: 6),

            Text("Date: ${item['date'] ?? ''}",
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 10),

            if (item['file'] != null && item['file'] != "")
              ElevatedButton(
                onPressed: () => openFile(item['file']),
                child: const Text("View File"),
              ),
          ],
        ),
      ),
    );
  }
}

