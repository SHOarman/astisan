import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final selectedCity = 'Detecting...'.obs;
  final selectedAddress = 'Fetching location...'.obs;
  final currentPosition = Rxn<Position>();
  final isLocationLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    isLocationLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        selectedCity.value = 'Location Disabled';
        selectedAddress.value = 'Please enable location services';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          selectedCity.value = 'Permission Denied';
          selectedAddress.value = 'Location permission is required';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        selectedCity.value = 'Permission Denied';
        selectedAddress.value = 'Enable permissions in settings';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      currentPosition.value = position;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        selectedCity.value = place.locality ?? place.subAdministrativeArea ?? place.name ?? 'Unknown City';
        
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.postalCode != null && place.postalCode!.isNotEmpty) addressParts.add(place.postalCode!);
        
        selectedAddress.value = addressParts.isEmpty ? 'Address not found' : addressParts.join(', ');
      }
    } catch (e) {
      print("Location Error Detail: $e");
      selectedCity.value = 'Error';
      selectedAddress.value = 'Could not fetch location';
    } finally {
      isLocationLoading.value = false;
    }
  }

  void updateLocation(String city, String address) {
    selectedCity.value = city;
    selectedAddress.value = address;
  }
}
