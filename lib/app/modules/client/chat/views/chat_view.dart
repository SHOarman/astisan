import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/components/custom_chat_bubble.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../worker/chat/controllers/worker_chat_controller.dart';

class ClientChatView extends GetView<UniversalChatController> {
  const ClientChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UniversalChatController());

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
            Obx(() => CircleAvatar(
              radius: 18,
              backgroundImage: controller.otherUserProfile.value.isNotEmpty
                  ? NetworkImage(controller.otherUserProfile.value)
                  : null,
              child: controller.otherUserProfile.value.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey, size: 20)
                  : null,
            )),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                    controller.otherUserName.value,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )),
                  Obx(() => Text(
                    controller.isOnline.value ? AppStrings.activeNow.tr : AppStrings.offline.tr,
                    style: GoogleFonts.poppins(
                      color: controller.isOnline.value ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(child: _buildSharedMessageList(controller)),
          _buildSharedInput(controller),
        ],
      ),
    );
  }

  Widget _buildSharedMessageList(UniversalChatController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Text(
            AppStrings.noMessagesYet.tr,
            style: const TextStyle(color: Colors.grey),
          ),
        );
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
                  decoration: const InputDecoration(
                    hintText: "Aa",
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.poppins(fontSize: 14.0),
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