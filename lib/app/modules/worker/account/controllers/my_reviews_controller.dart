import 'package:get/get.dart';

class MyReviewsController extends GetxController {
  final avgRating = 4.9.obs;
  final totalReviews = 203.obs;
  
  final ratingBreakdown = {
    '5': 150,
    '4': 40,
    '3': 10,
    '2': 2,
    '1': 1,
  }.obs;

  final reviews = <Map<String, dynamic>>[
    {
      'name': 'James Wilson',
      'date': 'Oct 20, 2023',
      'rating': 5.0,
      'comment': 'Marcus did an amazing job fixing our kitchen sink. He was on time, professional, and very thorough. Highly recommend!',
      'service': 'Plumbing Repair',
      'payment': '\$75 PAID',
    },
    {
      'name': 'Sarah Jenkins',
      'date': 'Oct 15, 2023',
      'rating': 4.0,
      'comment': 'Very polite and skilled. The repair was done quickly. Only giving 4 stars because he arrived 10 mins late, but the work was perfect.',
      'service': 'AC Maintenance',
      'payment': '\$120 PAID',
    },
    {
      'name': 'Robert Taylor',
      'date': 'Oct 10, 2023',
      'rating': 5.0,
      'comment': 'Excellent service! Marcus explained everything clearly and even gave some tips on how to maintain the electrical panel.',
      'service': 'Electrical Checkup',
      'payment': '\$50 PAID',
    },
  ].obs;
}
