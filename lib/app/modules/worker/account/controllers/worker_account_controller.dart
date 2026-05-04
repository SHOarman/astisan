import 'package:get/get.dart';

class WorkerAccountController extends GetxController {
  // User Profile Data
  final userName = 'Marcus Johnson'.obs;
  final profession = 'Certified Plumber'.obs;
  final experienceYears = '5+'.obs;
  final location = 'New York, NY'.obs;
  final joinYear = '2021'.obs;

  // Stats Data
  final jobsDone = 203.obs;
  final rating = 4.9.obs;
  final earnings = '4.2K'.obs;

  // Lists
  final skills = [
    'Plumbing',
    'Pipe Fitting',
    'Drain Cleaning',
    'Water Heater',
    'Faucet Repair',
    'Toilet Repair'
  ].obs;

  final serviceAreas = [
    'Manhattan',
    'Brooklyn',
    'Queens'
  ].obs;

  void signOut() {
    // Logic to sign out
    print("User signed out");
  }

// Example of how you would update this data from an API later:
/*
  void fetchUserData() async {
    var data = await api.getUserProfile();
    userName.value = data.name;
    jobsDone.value = data.jobsCompleted;
    // etc...
  }
  */
}