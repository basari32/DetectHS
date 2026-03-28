// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewComplaintPage extends StatefulWidget {
//   const ViewComplaintPage({super.key});
//
//   @override
//   State<ViewComplaintPage> createState() => _ViewComplaintPageState();
// }
//
// class _ViewComplaintPageState extends State<ViewComplaintPage> {
//   List<dynamic> complaintList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchComplaints();
//   }
//
//   Future<void> fetchComplaints() async {
//     try {
//       final sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? "";
//
//       final response =
//       await http.get(Uri.parse('$url/view_complaint/'));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 'ok') {
//           setState(() {
//             complaintList = data['data'] ?? [];
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Fetch error: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF05070A),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           "GRIEVANCE LOGS",
//           style: TextStyle(
//             letterSpacing: 2,
//             fontSize: 14,
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF00D4FF),
//           ))
//           : complaintList.isEmpty
//           ? const Center(
//           child: Text(
//             "No complaints filed",
//             style: TextStyle(color: Colors.white24),
//           ))
//           : ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: complaintList.length,
//         itemBuilder: (context, index) {
//           return _buildComplaintBox(complaintList[index]);
//         },
//       ),
//     );
//   }
//
//   Widget _buildComplaintBox(dynamic item) {
//
//     String replyText = item['reply']?.toString() ?? "pending";
//     bool isReplied =
//         replyText.toLowerCase() != "pending" && replyText.isNotEmpty;
//
//     Color statusColor =
//     isReplied ? Colors.greenAccent : Colors.orangeAccent;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0D1117),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildStatusBadge(
//                   isReplied ? "RESOLVED" : "PENDING", statusColor),
//               Text(
//                 item['Date']?.toString() ?? "",
//                 style:
//                 const TextStyle(color: Colors.white10, fontSize: 10),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           const Text("COMPLAINT",
//               style: TextStyle(
//                   color: Colors.white24,
//                   fontSize: 8,
//                   letterSpacing: 2)),
//
//           const SizedBox(height: 5),
//
//           Text(
//             item['complaint']?.toString() ?? "No description",
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 14, height: 1.5),
//           ),
//
//           if (isReplied) ...[
//             const SizedBox(height: 20),
//             const Divider(color: Colors.white10),
//             const Text("AUTHORITY REPLY",
//                 style: TextStyle(
//                     color: Colors.greenAccent,
//                     fontSize: 8,
//                     letterSpacing: 2)),
//             const SizedBox(height: 5),
//             Text(
//               replyText,
//               style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 13,
//                   fontStyle: FontStyle.italic),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String label, Color color) {
//     return Container(
//       padding:
//       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: color.withValues(alpha: 0.3)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//             color: color,
//             fontSize: 8,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewComplaintPage extends StatefulWidget {
  const ViewComplaintPage({super.key});

  @override
  State<ViewComplaintPage> createState() => _ViewComplaintPageState();
}

class _ViewComplaintPageState extends State<ViewComplaintPage> {
  List complaintList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  // ================= FETCH =================
  Future<void> fetchComplaints() async {
    try {
      final sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      final response = await http.post(
        Uri.parse('$url/view_complaint/'),
        body: {"lid": lid},
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          complaintList = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= SEND REPLY =================
  Future<void> sendReply(String complaintId, String reply) async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "";

    final response = await http.post(
      Uri.parse('$url/send_reply/'),
      body: {
        "cid": complaintId,
        "reply": reply,
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      Navigator.pop(context);
      fetchComplaints();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reply sent successfully")),
      );
    }
  }

  // ================= REPLY DIALOG =================
  void openReplyDialog(String complaintId) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text("Send Reply", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter reply...",
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                sendReply(complaintId, controller.text);
              }
            },
            child: const Text("Send"),
          )
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("GRIEVANCE LOGS"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaintList.isEmpty
          ? const Center(child: Text("No complaints"))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: complaintList.length,
        itemBuilder: (context, index) {
          return buildComplaintCard(complaintList[index]);
        },
      ),
    );
  }

  // ================= CARD =================
  Widget buildComplaintCard(dynamic item) {
    String replyText = (item['reply'] ?? "pending").toString().trim();
    bool isReplied = replyText.toLowerCase() != "pending";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isReplied ? "RESOLVED" : "PENDING",
                  style: TextStyle(
                      color: isReplied ? Colors.green : Colors.orange)),
              Text(item['Date'] ?? "",
                  style: const TextStyle(color: Colors.white30))
            ],
          ),

          const SizedBox(height: 10),

          Text(item['complaint'],
              style: const TextStyle(color: Colors.white)),

          const SizedBox(height: 10),

          if (isReplied)
            Text("Reply: $replyText",
                style: const TextStyle(color: Colors.greenAccent))
          else
            ElevatedButton(
              onPressed: () {
                openReplyDialog(item['id']);
              },
              child: const Text("SEND REPLY"),
            )
        ],
      ),
    );
  }
}
