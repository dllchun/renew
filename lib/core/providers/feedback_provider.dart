import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/services/feedback_service.dart';

final feedbackProvider = Provider<FeedbackService>((ref) {
  return FeedbackService();
});
