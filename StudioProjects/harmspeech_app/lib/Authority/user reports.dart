import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorityViewReportsPage extends StatefulWidget {
  const AuthorityViewReportsPage({super.key});

  @override
  State<AuthorityViewReportsPage> createState() => _AuthorityViewReportsPageState();
}

class _AuthorityViewReportsPageState extends State<AuthorityViewReportsPage> {
  List<dynamic> reportList = [];
  bool isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- FETCH REPORTS ---
  Future<void> fetchReports() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";
    String lid = sh.getString('lid') ?? "";
    String imgUrl = sh.getString('img_url') ?? "";

    try {
      final response = await http.post(
        Uri.parse('$url/view_user_report_authority/'),
        body: {'lid': lid},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            reportList = data['data'].map((item) {
              item['photo'] = imgUrl + item['photo'];
              item['Audio'] = imgUrl + item['Audio'];
              return item;
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Report Fetch Error: $e");
      setState(() => isLoading = false);
    }
  }

  // --- UPDATE STATUS TO REVIEWED ---
  Future<void> _markAsReviewed(String reportId, int index) async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";

    try {
      final response = await http.post(
        Uri.parse('$url/UpdateStatus/'),
        body: {'id': reportId},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          // Update the UI instantly without re-fetching everything
          setState(() {
            reportList[index]['status'] = 'Reviewed';
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("INCIDENT MARKED AS REVIEWED", style: TextStyle(fontSize: 10, letterSpacing: 1)),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                )
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Update Status Error: $e");
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
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        title: const Text("INCIDENT ARCHIVE", style: TextStyle(letterSpacing: 2, fontSize: 12)),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF)))
          : reportList.isEmpty
          ? const Center(child: Text("NO INCIDENTS LOGGED", style: TextStyle(color: Colors.white24, letterSpacing: 2)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reportList.length,
        itemBuilder: (context, index) {
          final item = reportList[index];
          return _buildReportCard(item, index);
        },
      ),
    );
  }

  Widget _buildReportCard(dynamic item, int index) {
    bool isPlaying = _playingIndex == index;
    bool isPending = item['status'].toString().toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: USER INFO & LOCATION
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item['photo']),
              backgroundColor: Colors.white10,
            ),
            title: Text(item['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text("Status: ${item['status']}".toUpperCase(),
                style: TextStyle(
                    color: isPending ? Colors.redAccent : Colors.greenAccent,
                    fontSize: 9,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold
                )),
            trailing: IconButton(
              icon: const Icon(Icons.location_on_outlined, color: Color(0xFF00D4FF)),
              onPressed: () => launchUrl(Uri.parse(item['loc']), mode: LaunchMode.externalApplication),
            ),
          ),

          // DETECTION OUTPUT WARNING
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orangeAccent.withOpacity(0.2))
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        "AI DETECTED: ${item['Detected'] ?? 'UNKNOWN'}".toUpperCase(),
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
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
                      const Text("ACOUSTIC EVIDENCE", style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
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

          // FOOTER: TIMESTAMP & REVIEW ACTION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['Date'], style: const TextStyle(color: Colors.white38, fontSize: 10)),

                // CONDITIONAL REVIEW BUTTON
                isPending
                    ? SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.withOpacity(0.1),
                      foregroundColor: Colors.greenAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(color: Colors.greenAccent.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _markAsReviewed(item['id'], index),
                    child: const Text("MARK REVIEWED", style: TextStyle(fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ),
                )
                    : const Text("SECURE LOG", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
              ],
            ),
          )
        ],
      ),
    );
  }
}