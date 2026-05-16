import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/custom_chat_bubble.dart';
import '../controllers/worker_chat_controller.dart';

class WorkerChatView extends GetView<UniversalChatController> {
  const WorkerChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UniversalChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),

              Obx(() => CircleAvatar(
                radius: 22,
                backgroundImage: controller.otherUserProfile.value.isNotEmpty
                    ? NetworkImage(controller.otherUserProfile.value)
                    : null,
                child: controller.otherUserProfile.value.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              )),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                      controller.otherUserName.value,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Obx(() => Text(
                      controller.isOnline.value ? 'Active now' : 'Offline',
                      style: GoogleFonts.poppins(color: controller.isOnline.value ? Colors.white : Colors.white70, fontSize: 12),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildWorkerBanner(),
          Expanded(child: _buildSharedMessageList(controller)),
          _buildSharedInput(controller),
        ],
      ),
    );
  }


  Widget _buildWorkerBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            "Job in Progress",
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }

  Widget _buildSharedMessageList(UniversalChatController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          bool isMe = msg.sender.id == controller.myUserId;
          if (controller.myUserId.isEmpty) {
            isMe = msg.sender.fullName != controller.otherUserName.value;
          }

          return CustomChatBubble(
            message: msg.content,
            time: "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
            isMe: isMe,
            isRead: msg.isRead,
            showAvatar: !isMe,
          );
        },
      );
    });
  }

  Widget _buildSharedInput(UniversalChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  decoration: const InputDecoration(
                    hintText: "Write message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}