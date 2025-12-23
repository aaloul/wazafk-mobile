import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/rating/rate_app_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class GiveFeedbackController extends GetxController {
  final _repository = RateAppRepository();

  final feedbackController = TextEditingController();

  var rating = 3.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> submitFeedback() async {
    if (!_validateFields()) {
      return;
    }

    try {
      isLoading.value = true;

      final data = {
        'rating': rating.value.toString(),
        'comment': feedbackController.text.trim(),
      };

      final response = await _repository.rateApp(data);

      if (response.success == true) {
        constants.showSnackBar(
            response.message ?? 'Feedback submitted successfully',
            SnackBarStatus.SUCCESS);
        Get.back();
      } else {
        constants.showSnackBar(
            response.message ?? 'Failed to submit feedback',
            SnackBarStatus.ERROR);
      }
    } catch (e) {
      constants.showSnackBar(
          'Error submitting feedback: $e', SnackBarStatus.ERROR);
      print('Error submitting feedback: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateFields() {
    if (feedbackController.text
        .trim()
        .isEmpty) {
      constants.showSnackBar(
          'Please enter your feedback', SnackBarStatus.ERROR);
      return false;
    }
    if (rating.value == 0) {
      constants.showSnackBar(Resources
          .of(Get.context!)
          .strings
          .pleaseSelectRating, SnackBarStatus.ERROR);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
