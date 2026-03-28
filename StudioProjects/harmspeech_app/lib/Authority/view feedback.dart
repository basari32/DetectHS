import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewFeedbackPage extends StatefulWidget {
  const ViewFeedbackPage({super.key});

  @override
  State<ViewFeedbackPage> createState() => _ViewFeedbackPageState();
}

class _ViewFeedbackPageState extends State<ViewFeedbackPage> {
  List<dynamic> feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";

    try {
      final response = await http.get(Uri.parse('$url/view_feedback/'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            feedbackList = data['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Feedback Error: $e");
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
        centerTitle: true,
        title: const Text("SYSTEM OPTIMIZATION LOGS",
            style: TextStyle(letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
          : feedbackList.isEmpty
          ? const Center(child: Text("No feedback recorded", style: TextStyle(color: Colors.white24)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          return _buildFeedbackCard(feedbackList[index]);
        },
      ),
    );
  }

  Widget _buildFeedbackCard(dynamic item) {
    // Parse rating and determine color
    int rating = int.tryParse(item['rating'].toString()) ?? 0;
    Color accentColor = rating >= 4 ? Colors.greenAccent : (rating <= 2 ? Colors.redAccent : const Color(0xFF00D4FF));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStars(rating, accentColor),
              Text(item['date'] ?? "", style: const TextStyle(color: Colors.white10, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            item['feedback'] ?? "No description",
            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.hub_outlined, size: 12, color: accentColor.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                "TARGET NODE: ${item['authority_name']}".toUpperCase(),
                style: TextStyle(color: accentColor.withValues(alpha: 0.5), fontSize: 9, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 15),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                child: Icon(Icons.person_outline, size: 14, color: accentColor),
              ),
              const SizedBox(width: 12),
              Text(
                item['user_name'] ?? "External User",
                style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(int rating, Color color) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: color,
          size: 18,
        );
      }),
    );
  }
}