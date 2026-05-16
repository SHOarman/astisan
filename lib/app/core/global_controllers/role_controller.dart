import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleController extends GetxController {
  // Observable role, defaults to 'client'
  final RxString currentRole = 'client'.obs;
  
  // Role-specific language settings
  final RxString clientLanguage = 'en'.obs;
  final RxString workerLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    currentRole.value = prefs.getString('current_role') ?? 'client';
    clientLanguage.value = prefs.getString('client_lang') ?? 'en';
    workerLanguage.value = prefs.getString('worker_lang') ?? 'en';
    
    // Set initial locale based on current role
    _updateLocale();
  }

  void setRole(String role) async {
    if (role == 'client' || role == 'worker') {
      currentRole.value = role;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_role', role);
      _updateLocale();
    }
  }

  void setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    if (isClient) {
      clientLanguage.value = lang;
      await prefs.setString('client_lang', lang);
    } else {
      workerLanguage.value = lang;
      await prefs.setString('worker_lang', lang);
    }
    _updateLocale();
  }

  void _updateLocale() {
    String lang = isClient ? clientLanguage.value : workerLanguage.value;
    Locale locale = lang == 'fr' ? const Locale('fr', 'FR') : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  bool get isClient => currentRole.value == 'client';
  bool get isWorker => currentRole.value == 'worker';
}

