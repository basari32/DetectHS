import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewComplaintReplies extends StatelessWidget {
  const ViewComplaintReplies({super.key});

  Future<List<Map<String, dynamic>>> fetchReplies() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final lid = pref.getString('lid') ?? "";

    final response = await http.post(
      Uri.parse("$ip/UserViewComplaintResponse/"),
      body: {'lid': lid},
    );

    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Replies")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReplies(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No replies found"));
          }

          final replies = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) {
              final item = replies[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Authority Name
                      Text(
                        item['auth_name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// Date
                      Text(
                        "Date: ${item['Date']}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const Divider(),

                      /// Complaint
                      const Text(
                        "Complaint:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item['complaint'] ?? ''),

                      const SizedBox(height: 10),

                      /// Reply
                      const Text(
                        "Reply:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item['reply'] != null && item['reply'] != ""
                            ? item['reply']
                            : "No reply yet",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
