import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class UserReportHistoryPage extends StatefulWidget {
  const UserReportHistoryPage({super.key});

  @override
  State<UserReportHistoryPage> createState() => _UserReportHistoryPageState();
}

class _UserReportHistoryPageState extends State<UserReportHistoryPage> {
  List<dynamic> historyList = [];
  bool isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- FETCH USER REPORT HISTORY ---
  Future<void> fetchHistory() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";
    String imgUrl = sh.getString('img_url') ?? "";

    try {
      final response = await http.post(
        Uri.parse('$url/UserViewReportHistory/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            historyList = data['data'].map((item) {
              // Construct full URL for the audio playback
              item['Audio'] = imgUrl + item['Audio'];
              return item;
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("History Fetch Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- AUDIO CONTROLS ---
  Future<void> _playAudio(String url, int index) async {
    if (_playingIndex == index) {
      await _audioPlayer.pause();
      setState(() => _playingIndex = null);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _playingIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Tactical Background
      appBar: AppBar(
        title: const Text("MY TRANSMISSIONS", style: TextStyle(letterSpacing: 2, fontSize: 12)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
          : historyList.isEmpty
          ? const Center(child: Text("NO INCIDENTS TRANSMITTED", style: TextStyle(color: Colors.white24, letterSpacing: 2)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return _buildHistoryCard(item, index);
        },
      ),
    );
  }

  Widget _buildHistoryCard(dynamic item, int index) {
    bool isPlaying = _playingIndex == index;
    String status = item['status'].toString().toLowerCase();

    // Determine dynamic status colors
    Color statusColor;
    if (status == 'pending') {
      statusColor = Colors.orangeAccent;
    } else if (status == 'reviewed' || status == 'resolved') {
      statusColor = Colors.greenAccent;
    } else {
      statusColor = const Color(0xFF00D4FF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117), // Command Center Card color
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: AUTHORITY & TIMESTAMP
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white10,
              child: Icon(Icons.account_balance_outlined, color: Colors.white54, size: 20),
            ),
            title: Text("TARGET: ${item['authority']}".toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            subtitle: Text(item['Date'], style: const TextStyle(color: Colors.white38, fontSize: 10)),
            trailing: IconButton(
              icon: const Icon(Icons.map_outlined, color: Color(0xFF00D4FF), size: 20),
              onPressed: () => launchUrl(Uri.parse(item['loc']), mode: LaunchMode.externalApplication),
            ),
          ),

          // DETECTION OUTPUT & STATUS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.05))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("CLASSIFICATION", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(
                            item['Detected'].toString().toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.2))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NETWORK STATUS", style: TextStyle(color: statusColor.withOpacity(0.5), fontSize: 8, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(
                            status.toUpperCase(),
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.white10, indent: 20, endIndent: 20),

          // AUDIO PLAYER SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _playAudio(item['Audio'], index),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPlaying ? const Color(0xFF00D4FF).withOpacity(0.1) : Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? const Color(0xFF00D4FF) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("MY ACOUSTIC EVIDENCE", style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: isPlaying ? null : 0.0,
                        backgroundColor: Colors.white10,
                        color: const Color(0xFF00D4FF),
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