import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/emergency_support_controller.dart';

class EmergencySupport extends GetView<EmergencySupportController> {
  const EmergencySupport({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EmergencySupportController>()) {
      Get.put(EmergencySupportController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Admin'.tr,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  if (message.isUser) {
                    return _buildSenderMessage(message.text, message.time);
                  } else {
                    return _buildReceiverMessage(context, message.text, message.time);
                  }
                },
              );
            }),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          }),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildReceiverMessage(BuildContext context, String text, String time, {bool hasAction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, style: const TextStyle(fontSize: 14)),
                      if (hasAction) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("Planning & Prioritizing", style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("Do a 5-min Planning exercise now", style: TextStyle(color: Colors.black, fontSize: 12)),
                              Icon(Icons.arrow_forward, size: 16, color: Colors.black),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, top: 4),
            child: Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderMessage(String text, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C4373),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange,
                backgroundImage: controller.profilePicture.value.isNotEmpty
                    ? NetworkImage(controller.profilePicture.value)
                    : null,
                child: controller.profilePicture.value.isEmpty
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 45, top: 4),
            child: Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  hintText: 'write your message'.tr,
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: const Color(0xFF2C4373),
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => controller.sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}