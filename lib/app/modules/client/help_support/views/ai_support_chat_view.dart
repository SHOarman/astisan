import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/components/custom_chat_bubble.dart';
import '../controllers/ai_support_chat_controller.dart';

class AiSupportChatView extends StatelessWidget {
  const AiSupportChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiSupportChatController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.support_agent, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.aiAssistant.tr,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppStrings.emergencySupport.tr,
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(child: _buildMessageList(controller)),
          _buildInput(controller),
        ],
      ),
    );
  }

  Widget _buildMessageList(AiSupportChatController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.support_agent, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                AppStrings.howCanIHelpToday.tr,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          bool isMe = msg['sender'] == 'user';
          
          DateTime time = DateTime.now();
          if (msg['timestamp'] != null) {
            try {
               time = DateTime.parse(msg['timestamp']).toLocal();
            } catch (_) {}
          }
          final timeStr = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

          return CustomChatBubble(
            message: msg['content'] ?? '',
            time: timeStr,
            isMe: isMe,
            isRead: true,
            showAvatar: !isMe,
          );
        },
      );
    });
  }

  Widget _buildInput(AiSupportChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: AppStrings.typeAMessage.tr,
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.poppins(fontSize: 14.0),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Obx(() => GestureDetector(
              onTap: controller.isSending.value ? null : controller.sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: controller.isSending.value ? Colors.grey : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: controller.isSending.value 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, color: Colors.white, size: 20.0),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
