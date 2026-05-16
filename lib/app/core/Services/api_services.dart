class ApiServices {
  ApiServices._();

  static const String baseurl = "https://7b2k279j-80.aue.devtunnels.ms";

  // ========================== Auth - Client ==========================
  static const String client_sendotp = "$baseurl/api/user/client/register/initiate/";
  static const String client_reg = "$baseurl/api/user/client/register/verify/";
  static const String client_login = "$baseurl/api/user/client/login/";
  static const String client_google = "$baseurl/api/user/auth/google/";
  static const String client_apple = "$baseurl/api/user/auth/apple/";

  // ========================== Auth - Artisan ==========================
  static const String artisan_sendotp = "$baseurl/api/user/artisan/register/initiate/";
  static const String artisan_reg = "$baseurl/api/user/artisan/register/verify/";
  static const String artisan_login = "$baseurl/api/user/artisan/login/";
  static const String artisan_google = "$baseurl/api/user/auth/google/";
  static const String artisan_apple = "$baseurl/api/user/auth/apple/";

  // ========================== Auth - Shared ==========================
  static const String logout = "$baseurl/api/user/logout/";
  static const String change_password = "$baseurl/api/user/password/change/";
  static const String forgot_password_init = "$baseurl/api/user/password-reset/initiate/";
  static const String forgot_password_verify = "$baseurl/api/user/password-reset/verify/";
  static const String forgot_password_confirm = "$baseurl/api/user/password-reset/confirm/";

  // ========================== Profile - Artisan ==========================
  static const String artisan_profile = "$baseurl/api/user/artisan/profile/";
  static const String artisan_toggle_online = "$baseurl/api/user/artisan/profile/toggle-online/";
  static const String artisan_home_address = "$baseurl/api/user/artisan/profile/home-address/";
  static const String artisan_public_profile = "$baseurl/api/user/artisan/"; // + {id}/public/
  static const String referral_code = "$baseurl/api/user/referral/code/";
  static const String referral_history = "$baseurl/api/user/referral/history/";
  static const String user_settings = "$baseurl/api/user/settings/";

  // ========================== Profile - Client ==========================
  static const String client_profile = "$baseurl/api/user/client/profile/";
  static const String client_addresses = "$baseurl/api/user/client/addresses/";

  // ========================== Services - Artisan ==========================
  static const String artisan_my_services = "$baseurl/api/services/artisan/my-services/";
  static const String artisan_service_catalogue = "$baseurl/api/services/artisan/catalogue/";
  static const String artisan_service_categories = "$baseurl/api/services/artisan/catalogue/categories/";

  // ========================== Services - Shared ==========================
  static const String services_categories = "$baseurl/api/services/client/categories/";
  static const String category_services = "$baseurl/api/services/client/categories/"; // + {id}/services/
  static const String popular_services = "$baseurl/api/services/client/services/popular/";
  static const String recommended_artisans = "$baseurl/api/services/client/services/recommended-artisans/";

  // ========================== Bookings - Client ==========================
  static const String client_create_booking = "$baseurl/api/bookings/client/";
  static const String client_booking_history = "$baseurl/api/bookings/client/history/";
  static const String client_booking_detail = "$baseurl/api/bookings/client/"; // + {id}/
  static const String client_booking_cancel = "$baseurl/api/bookings/client/"; // + {id}/cancel/
  static const String client_respond_cost = "$baseurl/api/bookings/client/"; // + {id}/costs/{cost_id}/respond/

  // ========================== Bookings - Artisan ==========================
  static const String artisan_bookings = "$baseurl/api/bookings/artisan/";
  static const String artisan_incoming_bookings = "$baseurl/api/bookings/artisan/incoming/";
  static const String artisan_today_schedule = "$baseurl/api/bookings/artisan/today/";
  static const String artisan_booking_detail = "$baseurl/api/bookings/artisan/"; // + {id}/
  static const String artisan_update_status = "$baseurl/api/bookings/artisan/"; // + {id}/status/
  static const String artisan_report_issue = "$baseurl/api/bookings/artisan/"; // + {id}/issues/
  static const String artisan_request_cost = "$baseurl/api/bookings/artisan/"; // + {id}/costs/
  static const String artisan_upload_signature = "$baseurl/api/bookings/artisan/"; // + {id}/signature/
  static const String artisan_checklist = "$baseurl/api/bookings/artisan/"; // + {id}/checklist/

  // ========================== Chat ==========================
  static const String client_chat_rooms = "$baseurl/api/chat/client/";
  static const String client_chat_booking = "$baseurl/api/chat/client/booking/"; // + {booking_id}/
  static const String client_chat_messages = "$baseurl/api/chat/client/"; // + {id}/messages/
  static const String client_chat_read = "$baseurl/api/chat/client/"; // + {id}/messages/read/

  static const String artisan_chat_rooms = "$baseurl/api/chat/artisan/";
  static const String artisan_chat_booking = "$baseurl/api/chat/artisan/booking/"; // + {booking_id}/
  static const String artisan_chat_messages = "$baseurl/api/chat/artisan/"; // + {id}/messages/
  static const String artisan_chat_read = "$baseurl/api/chat/artisan/"; // + {id}/messages/read/

  // ========================== Notifications ==========================
  static const String client_notifications = "$baseurl/api/notification/client/";
  static const String client_notif_clear_read = "$baseurl/api/notification/client/clear-read/";
  static const String client_notif_mark_all_read = "$baseurl/api/notification/client/mark-all-read/";
  static const String client_notif_unread_count = "$baseurl/api/notification/client/unread-count/";

  static const String artisan_notifications = "$baseurl/api/notification/artisan/";
  static const String artisan_notif_clear_read = "$baseurl/api/notification/artisan/clear-read/";
  static const String artisan_notif_mark_all_read = "$baseurl/api/notification/artisan/mark-all-read/";
  static const String artisan_notif_unread_count = "$baseurl/api/notification/artisan/unread-count/";

  // ========================== Tracking ==========================
  static const String tracking_location = "$baseurl/api/tracking/client/"; // + {booking_id}/location/
  static const String tracking_session = "$baseurl/api/tracking/client/"; // + {booking_id}/session/

  // ========================== Reviews ==========================
  static const String public_reviews = "$baseurl/api/reviews/artisan/"; // + {artisan_id}/public/
  static const String client_submitted_reviews = "$baseurl/api/reviews/client/";
  static const String submit_review = "$baseurl/api/reviews/client/submit/";

  // ========================== Support ==========================
  static const String faqs = "$baseurl/api/supports/faqs/";
  static const String about_us = "$baseurl/api/supports/about-us/";
  static const String terms_conditions = "$baseurl/api/supports/terms/";
  static const String privacy_policy = "$baseurl/api/supports/privacy/";
  static const String submit_feedback = "$baseurl/api/supports/feedback/submit/";
  static const String my_feedbacks = "$baseurl/api/supports/feedback/my-feedbacks/";

  // ========================== AI Verification ==========================

  static const String ai_verification_base = "https://document-verification-ai-chatbot.onrender.com";
  static const String ai_verify = "$baseurl/api/verification/verify/";



  static String formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    String formattedUrl = url;
    final localhostRegex = RegExp(r'https?://(localhost|127\.0\.0\.1)(:\d+)?');
    
    if (localhostRegex.hasMatch(formattedUrl)) {
      formattedUrl = formattedUrl.replaceFirst(localhostRegex, baseurl);
    } else if (!formattedUrl.startsWith('http')) {
      String path = formattedUrl.startsWith('/') ? formattedUrl : '/$formattedUrl';
      formattedUrl = "$baseurl$path";
    }
    
    return formattedUrl;
  }
}
