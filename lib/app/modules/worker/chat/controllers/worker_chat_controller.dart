// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/routes/app_routes.dart';
//
// class WorkerChatController extends GetxController {
//   final messageController = TextEditingController();
//   final messages = <Map<String, dynamic>>[
//     {
//       'text': 'Hello! I\'m on my way to your location.',
//       'time': '10:02 AM',
//       'isMe': false, // James Wilson (Client) sent this
//     },
//     {
//       'text': 'Great! I\'ll be home in 10 minutes.',
//       'time': '10:04 AM',
//       'isMe': true, // I (Worker) sent this
//     },
//     {
//       'text': 'No problem. I\'ll wait at the door. Do you have any specific instructions?',
//       'time': '10:05 AM',
//       'isMe': false,
//     },
//     {
//       'text': 'Yes please check the kitchen sink first, it has been leaking since last week.',
//       'time': '10:07 AM',
//       'isMe': true,
//     },
//     {
//       'text': 'Understood! I have all the tools needed. See you soon ðŸ‘',
//       'time': '10:09 AM',
//       'isMe': false,
//     },
//     {
//       'text': 'Perfect, thank you!',
//       'time': '10:10 AM',
//       'isMe': true,
//     },
//   ].obs;
//
//   void sendMessage() {
//     if (messageController.text.trim().isNotEmpty) {
//       messages.add({
//         'text': messageController.text.trim(),
//         'time': '10:11 AM',
//         'isMe': true,
//       });
//       messageController.clear();
//
//       // Basic simulation
//       Future.delayed(const Duration(seconds: 2), () {
//         messages.add({
//           'text': '...',
//           'time': '10:11 AM',
//           'isMe': false,
//         });
//
//         Future.delayed(const Duration(seconds: 1), () {
//           messages.removeLast();
//           messages.add({
//             'text': 'Great, see you soon!',
//             'time': '10:11 AM',
//             'isMe': false,
//           });
//         });
//       });
//     }
//   }
//
//   void trackJob() {
//     Get.toNamed(Routes.WORKER_JOB_STATUS);
//   }
//
//   void completeJob() {
//     Get.toNamed(Routes.JOB_COMPLETION);
//   }
//
//   @override
//   void onClose() {
//     messageController.dispose();
//     super.onClose();
//   }
// }
//


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart'; // Add this for IOWebSocketChannel
import '../../../../core/Services/api_services.dart';
import '../../job_details/controllers/worker_job_details_controller.dart'; // import models

class UniversalChatController extends GetxController {
  String baseurl="https://7b2k279j-80.aue.devtunnels.ms";
  final messageController = TextEditingController();
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  WebSocketChannel? channel;

  late String roomId;
  late bool isClient;
  var otherUserName = "User".obs;
  var otherUserProfile = "".obs;
  var isOnline = false.obs;
  String myUserId = "";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    roomId = args['id']?.toString() ?? "";
    isClient = args['isClient'] ?? false;
    otherUserName.value = args['name'] ?? "User";
    otherUserProfile.value = ApiServices.formatImageUrl(args['profile']?.toString());
    isOnline.value = args['isOnline'] ?? true; // Default to true if not provided

    _initUserDataAndChat();
  }

  Future<void> _initUserDataAndChat() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('user_id') ?? prefs.getString('id') ?? '';
    
    await loadChatHistory();
    connectWebSocket();
    markMessagesAsRead();
  }

  Future<void> loadChatHistory() async {
    if (roomId.isEmpty) {
      print("DEBUG: Room ID is empty. Skipping history fetch.");
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')?.replaceAll('"', '') ?? '';
      String role = isClient ? "client" : "artisan";

      // First, try to get the actual chat room using the booking ID
      String roomUrl = "$baseurl/api/chat/$role/booking/$roomId/";
      final roomResponse = await http.get(Uri.parse(roomUrl), headers: { 
        'Accept-Language': ApiServices.currentLanguage, 
        "Authorization": "Bearer $token",
        'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true' // Skip phishing page
      });
      
      String realRoomId = roomId;
      if (roomResponse.statusCode == 200 || roomResponse.statusCode == 201) {
        final roomData = jsonDecode(roomResponse.body);
        realRoomId = roomData['id']?.toString() ?? roomId;
        roomId = realRoomId; // Update global roomId for WebSocket
        
        // If messages are returned directly with the room
        if (roomData['messages'] != null) {
          final list = (roomData['messages'] as List).map((e) => ChatMessageModel.fromJson(e)).toList();
          list.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
          messages.assignAll(list);
          return;
        }
      }

      // If messages weren't included, fetch them using the real room ID
      String url = "$baseurl/api/chat/$role/$realRoomId/messages/";
      final response = await http.get(Uri.parse(url), headers: { 
        'Accept-Language': ApiServices.currentLanguage, 
        "Authorization": "Bearer $token",
        'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true'
      });
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['results'] as List).map((e) => ChatMessageModel.fromJson(e)).toList();
        list.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
        messages.assignAll(list);
      } else {
        print("DEBUG: Messages fetch failed with ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("DEBUG: Error in loadChatHistory: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void connectWebSocket() async {
    if (roomId.isEmpty) {
      print("DEBUG: Room ID is empty. Skipping websocket connection.");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')?.replaceAll('"', '') ?? '';
    
    final wsBaseUrl = baseurl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
    final wsUrl = "$wsBaseUrl/ws/chat/$roomId/?token=$token";

    print("DEBUG: Connecting to WebSocket: $wsUrl");

    try {
      // Use IOWebSocketChannel to pass custom headers required for DevTunnels
      channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {
          'X-Tunnel-Skip-Anti-Phishing-Threshold': 'true',
          'Origin': baseurl,
        },
      );
      
      channel!.stream.listen((event) {
        print("DEBUG: WebSocket Received: $event");
        final data = jsonDecode(event);
        if (data['type'] == 'user_status') {
           isOnline.value = data['is_online'] == true || data['status'] == 'online';
        } else if (data['type'] == 'new_message' || data['message'] != null) {
          final msgData = data['message'] ?? data;
          final newMsg = ChatMessageModel.fromJson(msgData);
          
          messages.removeWhere((m) => m.id.startsWith('temp_') && m.content == newMsg.content);
          
          // Add the real message from the server
          messages.insert(0, newMsg);
        }
      }, onError: (error) {
        print("DEBUG: WebSocket Error: $error");
        // Auto-reconnect or show error
      }, onDone: () {
        print("DEBUG: WebSocket Connection Closed. Code: ${channel!.closeCode}, Reason: ${channel!.closeReason}");
      });
    } catch (e) {
      print("DEBUG: WebSocket Exception: $e");
    }
  }

  void sendMessage() {
    String text = messageController.text.trim();
    if (text.isNotEmpty) {
      // 1. Optimistic UI Update (Shows instantly on screen)
      final optimisticMsg = ChatMessageModel(
        id: "temp_${DateTime.now().millisecondsSinceEpoch}",
        content: text,
        timestamp: DateTime.now(),
        sender: Sender(id: myUserId, fullName: "Me", profilePicture: ""),
        isRead: false,
      );
      messages.insert(0, optimisticMsg);
      messageController.clear();

      // 2. Send to Backend
      if (channel != null) {
        final payload = {"action": "send_message", "content": text};
        final encodedPayload = jsonEncode(payload);
        
        print("DEBUG: Sending WebSocket Message: $encodedPayload");
        channel!.sink.add(encodedPayload);
      } else {
        print("DEBUG: Cannot send message to server. Channel is null.");
      }
    }
  }

  Future<void> markMessagesAsRead() async {
    if (roomId.isEmpty) return;
    
    try {
      if (channel != null) {
        channel!.sink.add(jsonEncode({"action": "mark_read"}));
      }
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')?.replaceAll('"', '') ?? '';
      String role = isClient ? "client" : "artisan";
      
      final response = await http.post(
        Uri.parse("$baseurl/api/chat/$role/$roomId/messages/read/"),
        headers: { 'Accept-Language': ApiServices.currentLanguage, "Authorization": "Bearer $token"},
      );
      
      if (response.statusCode == 404) {
        print("DEBUG: markMessagesAsRead returned 404. Endpoint might be different or not implemented yet.");
      }
    } catch (e) {
      print("DEBUG: markMessagesAsRead error: $e");
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    channel?.sink.close();
    super.onClose();
  }
}