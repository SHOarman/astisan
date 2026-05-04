import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();

  final messages = <Map<String, dynamic>>[
    {
      'isMe': false,
      'text': "Hello! I'm on my way to your location.",
      'time': "10:02 AM",
    },
    {
      'isMe': true,
      'text': "Great! I'll be home in 10 minutes.",
      'time': "10:04 AM",
    },
    {
      'isMe': false,
      'text': "No problem. I'll wait at the door. Do you have any specific instructions?",
      'time': "10:05 AM",
    },
    {
      'isMe': true,
      'text': "Yes please check the kitchen sink first, it has been leaking since last week.",
      'time': "10:07 AM",
    },
    {
      'isMe': false,
      'text': "Understood! I have all the tools needed. See you soon ðŸ‘",
      'time': "10:09 AM",
    },
    {
      'isMe': true,
      'text': "Perfect, thank you!",
      'time': "10:10 AM",
    },
  ].obs;

  // Add typing indicator observable
  final isTyping = true.obs;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add({
        'isMe': true,
        'text': messageController.text.trim(),
        'time': '10:11 AM', // Mock time
      });
      messageController.clear();
    }
  }

  void trackJob() {
    Get.toNamed(Routes.TRACKINGSCREEN);
  }
}

