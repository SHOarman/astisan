import 'dart:convert';
import 'package:artisan/app/core/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiSupportChatController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.replaceAll('"', '').trim();

      final response = await http.get(
        Uri.parse("${ApiServices.baseurl}/api/chat/ai/client/"),
        headers: {
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Reverse so the newest message is at index 0 for the reversed ListView
        messages.assignAll(data.cast<Map<String, dynamic>>().reversed.toList());
      }
    } catch (e) {
      print("Error fetching AI history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    messageController.clear();
    isSending.value = true;

    messages.insert(0, {
      "id": DateTime.now().toString(),
      "sender": "user",
      "content": text,
      "timestamp": DateTime.now().toIso8601String(),
    });
    _scrollToBottom();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.replaceAll('"', '').trim();

      final response = await http.post(
        Uri.parse("${ApiServices.baseurl}/api/chat/ai/client/"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: json.encode({"message": text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        messages.insert(0, {
          "id": DateTime.now().toString(),
          "sender": "ai",
          "content": data["reply"] ?? "No response",
          "timestamp": DateTime.now().toIso8601String(),
        });
        _scrollToBottom();
      } else {
        Get.snackbar("Error", "Failed to get response from AI.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error sending message to AI: $e");
      Get.snackbar("Error", "Something went wrong.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
