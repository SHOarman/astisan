import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../../../core/routes/app_routes.dart';

class CameraController extends GetxController {
  final isCaptured = false.obs;
  final ImagePicker _picker = ImagePicker();
  final imagePath = ''.obs;
  
  @override
  void onReady() {
    super.onReady();
    capturePhoto();
  }
  
  Future<void> capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (photo != null) {
        imagePath.value = photo.path;
        isCaptured.value = true;
        
        final bookingController = Get.find<BookingController>();
        bookingController.capturedImagePath.value = photo.path;
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar('Error', 'Could not open camera.');
    }
  }

  void retakePhoto() {
    isCaptured.value = false;
    imagePath.value = '';
  }

  void proceedToNext() {
    try {
      // Navigate to Confirm Booking summary page
      Get.toNamed(Routes.CONFIRM_BOOKING, arguments: {
        'service': Get.arguments != null ? Get.arguments['service'] : {},
        'image': imagePath.value,
      });
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong.');
    }
  }
}
