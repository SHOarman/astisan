import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/static/app_colors.dart';
import '../../../../core/constants/static/app_strings.dart';
import '../../../../core/constants/static/app_images.dart';
import '../../../../core/components/custom_chat_bubble.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 18.0),
                ),
              ),
              SizedBox(width: 16.0),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.asset(
                      AppImages.homeMarcusJohnson,
                      width: 44.0,
                      height: 44.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: BoxDecoration(
                        color: AppColors.statusCompletedText,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'James Wilson',
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Row(
                      children: [
                        Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: AppColors.statusCompletedText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          AppStrings.onlineOnTheWay.tr,
                          style: GoogleFonts.poppins(
                            color: AppColors.white.withAlpha(200),
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTopBanner(),
          SizedBox(height: 16.0),
          _buildDateDivider(),
          SizedBox(height: 16.0),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length && controller.isTyping.value) {
                    return _buildTypingIndicator();
                  }

                  final msg = controller.messages[index];
                  // Simple check: show avatar if it's the first message from artisan or previous was from me
                  bool showAvatar = false;
                  if (!msg['isMe']) {
                    if (index == 0) {
                      showAvatar = true;
                    } else if (controller.messages[index - 1]['isMe'] == true) {
                      showAvatar = true;
                    }
                  }
                  
                  return CustomChatBubble(
                    message: msg['text'],
                    time: msg['time'],
                    isMe: msg['isMe'],
                    showAvatar: showAvatar,
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    return GestureDetector(
      onTap: controller.trackJob,
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.primary.withAlpha(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: AppColors.primary, size: 28.0),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.jobInProgress.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.rateAfterService.tr,
                    style: GoogleFonts.poppins(
                      color: AppColors.greyText,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'Track ', // using string but handling arrow specifically
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.primary, size: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Today, April 7',
              style: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 12.0,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(10), // Light blue tint
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: AppStrings.writeMessage.tr,
                    hintStyle: GoogleFonts.poppins(color: AppColors.greyText.withAlpha(150), fontSize: 14.0),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.poppins(color: AppColors.textColor, fontSize: 14.0),
                ),
              ),
            ),
            SizedBox(width: 12.0),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: AppColors.white, size: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                AppImages.placeholderAvatar,
                width: 32.0,
                height: 32.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: AppColors.chatBubbleReceived,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.greyText.withAlpha(100), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.greyText.withAlpha(100), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.greyText.withAlpha(100), shape: BoxShape.circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

