import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/Services/api_services.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class EmergencySupportController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  final isLoading = false.obs;
  final profilePicture = ''.obs;
  String? conversationId;

  @override
  void onInit() {
    super.onInit();
    _loadProfilePicture();
    _initChat();
  }

  Future<void> _initChat() async {
    await loadChatHistory();
    if (messages.isEmpty) {
      _addSystemMessage(
        "Hi! 👋 I'm here to support your practice. What's on your mind today?".tr,
      );
    }
  }

  Future<void> _loadProfilePicture() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? storedPic = prefs.getString('user_profile_pic');
      if (storedPic != null && storedPic.isNotEmpty) {
        profilePicture.value = storedPic;
        return;
      }

      // Fallback: fetch from artisan profile API
      String? token = prefs.getString('token');
      if (token != null) {
        token = token.trim().replaceAll('"', '');
        final response = await http.get(
          Uri.parse(ApiServices.artisan_profile),
          headers: { 'Accept-Language': ApiServices.currentLanguage, 
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          String? pic = data['profile_picture']?.toString();
          if (pic != null && pic.isNotEmpty && pic != 'null') {
            pic = ApiServices.formatImageUrl(pic);
            profilePicture.value = pic;
            // Save for future use
            await prefs.setString('user_profile_pic', pic);
          }
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  void _addSystemMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: false, time: _currentTime()));
  }

  void _addUserMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: true, time: _currentTime()));
  }

  String _currentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  Future<void> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) return;
      token = token.trim().replaceAll('"', '');

      final String? role = prefs.getString('role');
      final bool isClient = role == 'client';
      final String endpoint = isClient ? '${ApiServices.baseurl}/api/chat/ai/client/' : '${ApiServices.baseurl}/api/chat/ai/artisan/';

      final response = await http.get(
        Uri.parse(endpoint),
        headers: ApiServices.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> history = json.decode(response.body);
        if (history.isNotEmpty) {
          messages.clear();
          for (final msg in history) {
            final content = msg['content']?.toString() ?? '';
            final sender = msg['sender']?.toString() ?? '';
            final timestamp = msg['timestamp']?.toString() ?? '';
            String time = _currentTime();
            if (timestamp.isNotEmpty) {
              try {
                final dt = DateTime.parse(timestamp).toLocal();
                time = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
              } catch (_) {}
            }
            messages.add(ChatMessage(
              text: content,
              isUser: sender == 'user',
              time: time,
            ));
          }
        }
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    textController.clear();

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) token = token.trim().replaceAll('"', '');

      final String? role = prefs.getString('role');
      final bool isClient = role == 'client';
      final String endpoint = isClient ? '${ApiServices.baseurl}/api/chat/ai/client/' : '${ApiServices.baseurl}/api/chat/ai/artisan/';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: ApiServices.getHeaders(token: token),
        body: jsonEncode({
          'message': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply =
            data['reply'] ??
            data['message'] ??
            data['response'] ??
            data['content'] ??
            'Sorry, I could not understand that.';
        if (data['conversation_id'] != null) {
          conversationId = data['conversation_id'];
        }
        _addSystemMessage(reply);
      } else {
        print('AI Chat error: ${response.statusCode} ${response.body}');
        _addSystemMessage('Sorry, the server returned an error.'.tr);
      }
    } catch (e) {
      print('Error sending message: $e');
      _addSystemMessage(
        'Sorry, there was an error connecting to the support chat.'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
