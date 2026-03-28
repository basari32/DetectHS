// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:harmspeech_app/User/send%20complaint.dart';
// import 'package:harmspeech_app/User/send%20feedback.dart';
// import 'package:harmspeech_app/User/view%20authority.dart';
// import 'package:harmspeech_app/User/view%20reply.dart';
// import 'package:harmspeech_app/login.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'awareness details.dart';
//
//
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   String name = "User";
//   String photo = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }
//
//   Future<void> fetchUserProfile() async {
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//     String? imgUrl = sh.getString('img_url');
//
//     try {
//       // Create a profile view function in Django if not already done
//       final response = await http.post(
//         Uri.parse('$url/userProfileView/'),
//         body: {'lid': lid},
//       );
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             name = data['data']['name'];
//             photo = imgUrl! + data['data']['photo'];
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Profile Fetch Error: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF05070A),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildUserHeader(),
//               const SizedBox(height: 40),
//
//               // PRIMARY ACTION: EMERGENCY REPORT
//               _buildMainReportCard(),
//               const SizedBox(height: 25),
//
//               // SECONDARY ACTIONS GRID
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildMenuCard(
//                           title: "COMPLAINT",
//                           desc: "File a grievance",
//                           icon: Icons.gavel_rounded,
//                           color: Colors.orangeAccent,
//                           height: 180,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAuthority()));
//                           },
//                         ),  _buildMenuCard(
//                           title: "REPLY",
//                           desc: "File a grievance",
//                           icon: Icons.gavel_rounded,
//                           color: Colors.orangeAccent,
//                           height: 180,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => ViewComplaintReplies()));
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         _buildMenuCard(
//                           title: "AWARENESS",
//                           desc: "Safety tips",
//                           icon: Icons.lightbulb_outline,
//                           color: Colors.yellowAccent,
//                           height: 140,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const UserViewAwarenessPage()));
//                           },
//                         ),
//
//                         const SizedBox(height: 20),
//                         _buildMenuCard(
//                           title: "LOGOUT",
//                           desc: "Logout Session",
//                           icon: Icons.logout,
//                           color: Colors.red,
//                           height: 140,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildMenuCard(
//                           title: "FEEDBACK",
//                           desc: "Rate system",
//                           icon: Icons.star_outline_rounded,
//                           color: Colors.greenAccent,
//                           height: 140,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSendFeedbackPage()));
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         _buildMenuCard(
//                           title: "MY LOGS",
//                           desc: "Report history",
//                           icon: Icons.history_rounded,
//                           color: const Color(0xFF9D00FF),
//                           height: 180,
//                           onTap: () {
//                             // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLogsPage()));
//                           },
//                         ),
//
//
//
//
//
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("SAFETY HUB",
//                 style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
//             const SizedBox(height: 5),
//             Text("WELCOME, ${name.toUpperCase()}",
//                 style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfilePage()));
//           },
//           child: CircleAvatar(
//             radius: 25,
//             backgroundColor: const Color(0xFF0D1117),
//             backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
//             child: photo.isEmpty ? const Icon(Icons.person, color: Colors.white24) : null,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMainReportCard() {
//     return InkWell(
//       onTap: () {
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSendReportPage(authorityId: '1')));
//       },
//       borderRadius: BorderRadius.circular(28),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(25),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.redAccent.withValues(alpha: 0.8), Colors.red.withValues(alpha: 0.5)],
//           ),
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(color: Colors.redAccent.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
//           ],
//         ),
//         child: const Row(
//           children: [
//             Icon(Icons.mic_none_rounded, color: Colors.white, size: 40),
//             SizedBox(width: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("TRANSMIT INCIDENT",
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//                 Text("Audio evidence & GPS tagging",
//                     style: TextStyle(color: Colors.white70, fontSize: 11)),
//               ],
//             ),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 15),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuCard({
//     required String title,
//     required String desc,
//     required IconData icon,
//     required Color color,
//     required double height,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(28),
//       child: Container(
//         width: double.infinity,
//         height: height,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF0D1117),
//           borderRadius: BorderRadius.circular(28),
//           border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 28),
//             const Spacer(),
//             Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//             const SizedBox(height: 5),
//             Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 9)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _UserSendComplaintPageState {
//   const _UserSendComplaintPageState();
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harmspeech_app/User/audio.dart';
import 'package:harmspeech_app/User/send%20complaint.dart';
import 'package:harmspeech_app/User/send%20feedback.dart';
import 'package:harmspeech_app/User/userprofile.dart';
import 'package:harmspeech_app/User/view%20authority.dart';
import 'package:harmspeech_app/User/view%20reply.dart';
import 'package:harmspeech_app/User/view_history.dart';
import 'package:harmspeech_app/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'awareness details.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String name = "User";
  String photo = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');
    String? imgUrl = sh.getString('img_url');

    try {
      final response = await http.post(
        Uri.parse('$url/userProfileView/'),
        body: {'lid': lid},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok' && mounted) {
          setState(() {
            name = data['data']['name'];
            photo = imgUrl! + data['data']['photo'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Profile Fetch Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 40),

              // PRIMARY ACTION: EMERGENCY REPORT
              _buildMainReportCard(),
              const SizedBox(height: 30),

              const Text("SERVICES",
                  style: TextStyle(color: Color(0xFF00D4FF), fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // STAGGERED GRID
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT COLUMN ---
                  Expanded(
                    child: Column(
                      children: [
                        _buildMenuCard(
                          title: "COMPLAINT",
                          desc: "File a grievance",
                          icon: Icons.gavel_rounded,
                          color: Colors.orangeAccent,
                          height: 180,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAuthority()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuCard(
                          title: "AWARENESS",
                          desc: "Safety tips",
                          icon: Icons.lightbulb_outline,
                          color: Colors.yellowAccent,
                          height: 140,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserViewAwarenessPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuCard(
                          title: "LOGOUT",
                          desc: "End session",
                          icon: Icons.logout_rounded,
                          color: Colors.redAccent,
                          height: 140,
                          onTap: () async {
                            final sh = await SharedPreferences.getInstance();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                    (route) => false
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // --- RIGHT COLUMN ---
                  Expanded(
                    child: Column(
                      children: [
                        _buildMenuCard(
                          title: "REPLY",
                          desc: "View status",
                          icon: Icons.quickreply_outlined,
                          color: const Color(0xFF00D4FF),
                          height: 140,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewComplaintReplies()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuCard(
                          title: "FEEDBACK",
                          desc: "Rate system",
                          icon: Icons.star_outline_rounded,
                          color: Colors.greenAccent,
                          height: 140,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSendFeedbackPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuCard(
                          title: "MY LOGS",
                          desc: "Report history",
                          icon: Icons.history_rounded,
                          color: const Color(0xFF9D00FF),
                          height: 180,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserReportHistoryPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SAFETY HUB",
                style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
            const SizedBox(height: 5),
            Text("WELCOME, ${name.toUpperCase()}",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00D4FF).withValues(alpha: 0.3), width: 2),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF0D1117),
              backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
              child: photo.isEmpty ? const Icon(Icons.person, color: Colors.white24) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainReportCard() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AudioUploadPage()));
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent.withValues(alpha: 0.9), Colors.red.withValues(alpha: 0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.redAccent.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.mic_none_rounded, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TRANSMIT INCIDENT",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Audio evidence & GPS tagging",
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required double height,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 5),
            Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
