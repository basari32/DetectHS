// import 'package:flutter/material.dart';
//
// class UAIAuthorityPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF05070A), // Deepest tactical black base
//       body: Row(
//         children: [
//           // MINIMAL TACTICAL SIDEBAR
//           _buildAuthoritySidebar(),
//
//           // MAIN AUTHORITY WORKSPACE
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionHeader(),
//                   const SizedBox(height: 40),
//
//                   Expanded(
//                     child: Row(
//                       children: [
//                         // LEFT BOX: AUTHORITY GRID (Pinterest Style)
//                         Expanded(
//                           flex: 7,
//                           child: GridView.count(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 20,
//                             mainAxisSpacing: 20,
//                             childAspectRatio: 1.5,
//                             children: [
//                               _buildAuthorityCard("STATE POLICE HQ", "KERALA_POLICE_DEPT", Icons.shield_outlined, Colors.blueAccent),
//                               _buildAuthorityCard("MUNICIPAL OVERSIGHT", "MALAPPURAM_GOVT", Icons.gavel_rounded, Colors.orangeAccent),
//                               _buildAuthorityCard("LEGAL AUDIT WING", "UAI_COMPLIANCE", Icons.verified_user_outlined, Colors.greenAccent),
//                               _buildAuthorityCard("FEDERAL LIAISON", "MINISTRY_SURVEILLANCE", Icons.account_balance_outlined, Colors.purpleAccent),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 30),
//                         // RIGHT BOX: CLEARANCE STATUS TERMINAL
//                         Expanded(
//                           flex: 3,
//                           child: _buildClearanceTerminal(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAuthoritySidebar() {
//     return Container(
//       width: 100,
//       color: const Color(0xFF0D1117), // Slightly lighter "Box" gray
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _navIcon(Icons.grid_view_rounded, false),
//           const SizedBox(height: 35),
//           _navIcon(Icons.policy_outlined, true), // Active: Authority View
//           const SizedBox(height: 35),
//           _navIcon(Icons.history_edu_rounded, false),
//           const SizedBox(height: 35),
//           _navIcon(Icons.vpn_key_outlined, false),
//         ],
//       ),
//     );
//   }
//
//   Widget _navIcon(IconData icon, bool isActive) {
//     return Icon(icon, color: isActive ? const Color(0xFF00D4FF) : Colors.white24, size: 26);
//   }
//
//   Widget _buildSectionHeader() {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("OVERSIGHT AUTHORITIES", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w300)),
//         SizedBox(height: 8),
//         Text("LEGISLATIVE & LAW ENFORCEMENT ACCESS PERMISSIONS", style: TextStyle(color: Color(0xFF00D4FF), fontSize: 9, letterSpacing: 2.5)),
//       ],
//     );
//   }
//
//   Widget _buildAuthorityCard(String name, String tag, IconData icon, Color accent) {
//     return Container(
//       padding: const EdgeInsets.all(30),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D1117), // The requested different box color
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(icon, color: accent, size: 28),
//               const Icon(Icons.lock_open_rounded, color: Colors.white10, size: 16),
//             ],
//           ),
//           const Spacer(),
//           Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),
//           Text(tag, style: TextStyle(color: accent.withOpacity(0.5), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClearanceTerminal() {
//     return Container(
//       padding: const EdgeInsets.all(30),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D1117).withOpacity(0.6),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
//         boxShadow: [BoxShadow(color: const Color(0xFF00D4FF).withOpacity(0.02), blurRadius: 40)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("SYSTEM STATUS", style: TextStyle(color: Color(0xFF00D4FF), fontSize: 10, letterSpacing: 2)),
//           const SizedBox(height: 30),
//           _terminalRow("CURRENT_HUB", "MALAPPURAM_NORTH"),
//           _terminalRow("ENCRYPTION", "AES_256_ACTIVE"),
//           _terminalRow("AUDIT_LOG", "CLEARED"),
//           const Spacer(),
//           const Divider(color: Colors.white12),
//           const SizedBox(height: 20),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [const Color(0xFF00D4FF), const Color(0xFF9D00FF).withOpacity(0.8)]),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Center(child: Text("GENERATE SECURITY TOKEN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10))),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _terminalRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1.5)),
//           const SizedBox(height: 4),
//           Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harmspeech_app/User/send%20complaint.dart';
import 'package:harmspeech_app/User/send%20feedback.dart';
import 'package:harmspeech_app/User/send%20report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewAuthority extends StatelessWidget {
  const ViewAuthority({super.key});

  Future<List<Map<String, dynamic>>> fetchAuthority() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final imgUrl = pref.getString('img_url') ?? "";

    // 🔹 call new Django API
    final response = await http.post(Uri.parse("$ip/UserViewAuthority/"));
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      return List<Map<String, dynamic>>.from(jsonData['data']).map((user) {
        user['photo'] =
        user['photo'] != null ? imgUrl + user['photo'] : null;
        return user;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Authority")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAuthority(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No authority found"));
          }

          final users = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: user['photo'] != null
                        ? NetworkImage(user['photo'])
                        : const AssetImage('assets/default_user.png')
                    as ImageProvider,
                  ),

                  // 🔹 updated field name
                  title: Text(
                    user['auth_name'] ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // 🔹 show more details if needed
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Position: ${user['position'] ?? ''}"),
                      Text("Phone: ${user['phoneNo'] ?? ''}"),
                      Text("Email: ${user['Email'] ?? ''}"),
                      
                      
                      ElevatedButton(onPressed: () async {

                        final sh = await SharedPreferences.getInstance();
                        sh.setString("aid", user['id'].toString());

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSendComplaintPage()));





                      }, child: Text("Complaints")),

                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: () async {

                        final sh = await SharedPreferences.getInstance();
                        sh.setString("aid", user['id'].toString());

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSendReportPage()));





                      }, child: Text("Report")),

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

