import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/camera_controller.dart';

class CameraView extends GetView<CameraController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera native background
      body: SafeArea(
        child: Stack(
          children: [
            // Black background imitating viewfinder
            Positioned.fill(child: Container(color: const Color(0xFF111111))),

            // Top App Bar Controls
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28.0),
                onPressed: () => Get.back(),
              ),
            ),
            Positioned(
              top: 28.0,
              left: 0,
              right: 0,
              child: Text(
                'Take a Photo',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Bottom Controls Area
            Positioned(
              bottom: 40.0,
              left: 24.0,
              right: 24.0,
              child: Obx(() {
                if (controller.isCaptured.value) {
                  return _buildCapturedControls();
                } else {
                  return _buildCaptureControls();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Flash toggle equivalent
        IconButton(
          icon: const Icon(Icons.flash_off, color: Colors.white, size: 28.0),
          onPressed: () {},
        ),
        // Main Shutter Button
        GestureDetector(
          onTap: controller.capturePhoto,
          child: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.0),
            ),
            child: Center(
              child: Container(
                width: 68.0,
                height: 68.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        // Camera Flip Toggle
        IconButton(
          icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28.0),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCapturedControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Retake functionality
        GestureDetector(
          onTap: controller.retakePhoto,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh, color: Colors.white, size: 28.0),
              const SizedBox(height: 8.0),
              Text(
                'Retake',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Next Gradient Button imitating the provided design
        GestureDetector(
          onTap: controller.proceedToNext,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8A2387),
                  Color(0xFFE94057),
                  Color(0xFFF27121),
                ], // Warm instagram-like gradient seen in design
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              'Next',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
