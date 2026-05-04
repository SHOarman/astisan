import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class WorkerChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <Map<String, dynamic>>[
    {
      'text': 'Hello! I\'m on my way to your location.',
      'time': '10:02 AM',
      'isMe': false, // James Wilson (Client) sent this
    },
    {
      'text': 'Great! I\'ll be home in 10 minutes.',
      'time': '10:04 AM',
      'isMe': true, // I (Worker) sent this
    },
    {
      'text': 'No problem. I\'ll wait at the door. Do you have any specific instructions?',
      'time': '10:05 AM',
      'isMe': false,
    },
    {
      'text': 'Yes please check the kitchen sink first, it has been leaking since last week.',
      'time': '10:07 AM',
      'isMe': true,
    },
    {
      'text': 'Understood! I have all the tools needed. See you soon ðŸ‘',
      'time': '10:09 AM',
      'isMe': false,
    },
    {
      'text': 'Perfect, thank you!',
      'time': '10:10 AM',
      'isMe': true,
    },
  ].obs;

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add({
        'text': messageController.text.trim(),
        'time': '10:11 AM',
        'isMe': true,
      });
      messageController.clear();
      
      // Basic simulation
      Future.delayed(const Duration(seconds: 2), () {
        messages.add({
          'text': '...',
          'time': '10:11 AM',
          'isMe': false,
        });
        
        Future.delayed(const Duration(seconds: 1), () {
          messages.removeLast();
          messages.add({
            'text': 'Great, see you soon!',
            'time': '10:11 AM',
            'isMe': false,
          });
        });
      });
    }
  }

  void trackJob() {
    Get.toNamed(Routes.WORKER_JOB_STATUS);
  }

  void completeJob() {
    Get.toNamed(Routes.JOB_COMPLETION);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}

