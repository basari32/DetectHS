// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:harmspeech_app/Authority/send%20awarness.dart';
// import 'package:harmspeech_app/Authority/user%20reports.dart';
// import 'package:harmspeech_app/Authority/view%20awarness.dart';
// import 'package:harmspeech_app/Authority/view%20complaint.dart';
// import 'package:harmspeech_app/Authority/view%20feedback.dart';
// import 'package:harmspeech_app/Authority/view%20user.dart';
// import 'package:harmspeech_app/login.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'authorityprofile.dart';
//
//
//
// class UAIHome extends StatefulWidget {
//   const UAIHome({super.key});
//
//   @override
//   State<UAIHome> createState() => _UAIHomeState();
// }
//
// class _UAIHomeState extends State<UAIHome> {
//   String name = "Loading...";
//   String photo = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }
//
//   Future<void> fetchProfile() async {
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//     String? imgUrl = sh.getString('img_url');
//
//     try {
//       final response = await http.post(
//         Uri.parse('$url/authorityProfile/'),
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
//       debugPrint("Error fetching profile: $e");
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
//               _buildHeader(),
//               const SizedBox(height: 40),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildPinterestCard(
//                           title: "VIEW USERS",
//                           desc: "Personnel directory",
//                           icon: Icons.people_alt_outlined,
//                           color: const Color(0xFF00D4FF),
//                           height: 200,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewUserPage()));
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         _buildPinterestCard(
//                           title: "FEEDBACK",
//                           desc: "Optimization logs",
//                           icon: Icons.chat_bubble_outline_rounded,
//                           color: Colors.greenAccent,
//                           height: 160,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewFeedbackPage()));
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildPinterestCard(
//                           title: "REPORTS",
//                           desc: "Audio incident archive",
//                           icon: Icons.assessment_outlined,
//                           color: const Color(0xFF9D00FF),
//                           height: 160,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewReportPage()));
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         _buildPinterestCard(
//                           title: "COMPLAINTS",
//                           desc: "Priority grievances",
//                           icon: Icons.warning_amber_rounded,
//                           color: Colors.orangeAccent,
//                           height: 200,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewComplaintPage()));
//                           },
//                         ),
//
//
//                         const SizedBox(height: 20),
//                         _buildPinterestCard(
//                           title: "LOGOUT",
//                           desc: "Logout session",
//                           icon: Icons.logout,
//                           color: Colors.red,
//                           height: 200,
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildPinterestCard(
//                 title: "AWARENESS",
//                 desc: "Community safety guidelines & broadcasts",
//                 icon: Icons.lightbulb_outline_rounded,
//                 color: Colors.yellowAccent,
//                 height: 120,
//                 isFullWidth: true,
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewAwarenessPage()));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "COMMAND HUB",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w300,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "OFFICER: ${name.toUpperCase()}",
//               style: TextStyle(color: const Color(0xFF00D4FF), fontSize: 10, letterSpacing: 2),
//             ),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthorityProfilePage()));
//           },
//           child: Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: const Color(0xFF00D4FF), width: 1.5),
//             ),
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: const Color(0xFF0D1117),
//               backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
//               child: photo.isEmpty ? const Icon(Icons.person, color: Colors.white24) : null,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPinterestCard({
//     required String title,
//     required String desc,
//     required IconData icon,
//     required Color color,
//     required double height,
//     required VoidCallback onTap,
//     bool isFullWidth = false,
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
//           border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//           boxShadow: [
//             BoxShadow(
//               color: color.withValues(alpha: 0.1),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: Icon(icon, color: color, size: 24),
//             ),
//             const Spacer(),
//             Text(
//               title,
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               desc,
//               style: const TextStyle(color: Colors.white38, fontSize: 10, height: 1.3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Your Actual Page Imports
import 'package:harmspeech_app/Authority/send%20awarness.dart';
import 'package:harmspeech_app/Authority/user%20reports.dart';
import 'package:harmspeech_app/Authority/view%20awarness.dart';
import 'package:harmspeech_app/Authority/view%20complaint.dart';
import 'package:harmspeech_app/Authority/view%20feedback.dart';
import 'package:harmspeech_app/Authority/view%20user.dart';
import 'package:harmspeech_app/login.dart';
import 'authorityprofile.dart';

class UAIHome extends StatefulWidget {
  const UAIHome({super.key});

  @override
  State<UAIHome> createState() => _UAIHomeState();
}

class _UAIHomeState extends State<UAIHome> {
  String name = "Loading...";
  String photo = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');
    String? imgUrl = sh.getString('img_url');

    try {
      final response = await http.post(
        Uri.parse('$url/authorityProfile/'),
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
      debugPrint("Error fetching profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A), // Deep Tactical Black
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),

              const Text("SYSTEM MODULES",
                  style: TextStyle(color: Color(0xFF00D4FF), fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT COLUMN ---
                  Expanded(
                    child: Column(
                      children: [
                        _buildPinterestCard(
                          title: "VIEW USERS",
                          desc: "Personnel directory",
                          icon: Icons.people_alt_outlined,
                          color: const Color(0xFF00D4FF),
                          height: 200,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewUserPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildPinterestCard(
                          title: "FEEDBACK",
                          desc: "Optimization logs",
                          icon: Icons.chat_bubble_outline_rounded,
                          color: Colors.greenAccent,
                          height: 160,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewFeedbackPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildPinterestCard(
                          title: "ADD AWARENESS",
                          desc: "Broadcast tips",
                          icon: Icons.add_alert_rounded,
                          color: Colors.cyanAccent,
                          height: 150,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAwarenessPage()));
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
                        _buildPinterestCard(
                          title: "REPORTS",
                          desc: "Incident archive",
                          icon: Icons.assessment_outlined,
                          color: const Color(0xFF9D00FF),
                          height: 160,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthorityViewReportsPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildPinterestCard(
                          title: "COMPLAINTS",
                          desc: "Priority grievances",
                          icon: Icons.warning_amber_rounded,
                          color: Colors.orangeAccent,
                          height: 200,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewComplaintPage()));
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildPinterestCard(
                          title: "LOGOUT",
                          desc: "End session",
                          icon: Icons.logout_rounded,
                          color: Colors.redAccent,
                          height: 150,
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
                ],
              ),
              const SizedBox(height: 20),
              // Full Width Awareness View
              _buildPinterestCard(
                title: "VIEW BROADCASTS",
                desc: "Review community safety guidelines & hub broadcasts",
                icon: Icons.visibility_outlined,
                color: Colors.yellowAccent,
                height: 110,
                isFullWidth: true,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewAwarenessPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("COMMAND HUB",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w300, letterSpacing: -0.5)),
            const SizedBox(height: 5),
            Text("OFFICER: ${name.toUpperCase()}",
                style: const TextStyle(color: Color(0xFF00D4FF), fontSize: 10, letterSpacing: 2)),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthorityProfilePage()));
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00D4FF).withValues(alpha: 0.5), width: 1.5),
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

  Widget _buildPinterestCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required double height,
    required VoidCallback onTap,
    bool isFullWidth = false,
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
            BoxShadow(color: color.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.topRight, child: Icon(icon, color: color, size: 24)),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 5),
            Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 10, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
