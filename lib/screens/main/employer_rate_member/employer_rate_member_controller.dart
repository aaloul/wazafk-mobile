import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/model/RatingCriteriaResponse.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/repository/rating/rate_member_repository.dart';
import 'package:wazafak_app/repository/rating/rating_criteria_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class EmployerRateMemberController extends GetxController {
  final RatingCriteriaRepository _ratingCriteriaRepository =
      RatingCriteriaRepository();
  final RateMemberRepository _rateMemberRepository = RateMemberRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  var isLoadingCriteria = false.obs;
  var isLoadingProfile = false.obs;
  var isSubmitting = false.obs;
  var criteria = <RatingCriteria>[].obs;
  var criteriaRatings = <String, double>{}.obs; // Map of hashcode to rating
  var overallRating = 0.0.obs;
  var memberHashcode = ''.obs;
  var memberName = ''.obs;
  var memberImage = ''.obs;
  var memberProfile = Rxn<MemberProfile>();

  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Get member details from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      memberHashcode.value = arguments['memberHashcode'] ?? '';
      memberName.value = arguments['memberName'] ?? '';
      memberImage.value = arguments['memberImage'] ?? '';
    }

    fetchRatingCriteria();
    if (memberHashcode.value.isNotEmpty) {
      getMemberProfile();
    }
  }

  Future<void> fetchRatingCriteria() async {
    try {
      isLoadingCriteria.value = true;

      final response = await _ratingCriteriaRepository.getRatingCriteria(
        target: 'C',
      );

      if (response.success == true) {
        final criteriaResponse = RatingCriteriaResponse.fromJson(
          response.toJson(),
        );
        if (criteriaResponse.data != null) {
          criteria.value = criteriaResponse.data!;
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load rating criteria',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading rating criteria: $e',
        SnackBarStatus.ERROR,
      );
      print('Error loading rating criteria: $e');
    } finally {
      isLoadingCriteria.value = false;
    }
  }

  Future<void> getMemberProfile() async {
    try {
      isLoadingProfile.value = true;

      final response = await _profileRepository.getMemberProfile(
        filters: {
          'hashcode': '8bade700cbd9a4012f45f6b3f7f4cbc8',
          'ratings': '1',
          'skills': '0',
          'services': '0',
          'packages': '0',
          'jobs': '0',
        },
      );

      if (response.success == true && response.data != null) {
        memberProfile.value = response.data;

        // Update member details from profile if available
        if (response.data!.member != null) {
          memberName.value =
              '${response.data!.member!.firstName ?? ''} ${response.data!.member!.lastName ?? ''}'
                  .trim();
          memberImage.value = response.data!.member!.image ?? '';
        }
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to load member profile',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error loading member profile: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void updateCriterionRating(String hashcode, double rating) {
    if (hashcode.isNotEmpty) {
      criteriaRatings[hashcode] = rating;
      criteriaRatings.refresh();
      calculateOverallRating();
    }
  }

  double getCriterionRating(String hashcode) {
    return criteriaRatings[hashcode] ?? 0.0;
  }

  void calculateOverallRating() {
    if (criteriaRatings.isEmpty) {
      overallRating.value = 0.0;
      return;
    }

    double total = 0.0;
    for (var rating in criteriaRatings.values) {
      total += rating;
    }
    overallRating.value = total / criteriaRatings.length;
  }

  Future<void> submitRating() async {
    // Validate that all criteria have been rated
    if (criteria.isEmpty) {
      constants.showSnackBar(
        'No rating criteria available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    // Check if at least one criterion has been rated
    if (criteriaRatings.isEmpty) {
      constants.showSnackBar(
        'Please rate at least one criterion',
        SnackBarStatus.ERROR,
      );
      return;
    }

    if (memberHashcode.value.isEmpty) {
      constants.showSnackBar(
        'Member information not available',
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // Build rating_by_criteria string in format: hashcode1:rating1,hashcode2:rating2
      List<String> ratingPairs = [];
      criteriaRatings.forEach((hashcode, rating) {
        ratingPairs.add('$hashcode:${rating.toInt()}');
      });
      String ratingByCriteria = ratingPairs.join(',');

      // Prepare rating data
      Map<String, dynamic> ratingData = {
        'comment': commentController.text.trim(),
        'target': 'C',
        'rate_member': memberHashcode.value,
        'rating_by_criteria': ratingByCriteria,
      };

      final response = await _rateMemberRepository.rateMember(ratingData);

      if (response.success == true) {
        constants.showSnackBar(
          response.message ?? 'Rating submitted successfully',
          SnackBarStatus.SUCCESS,
        );
        Get.back(result: true);
      } else {
        constants.showSnackBar(
          response.message ?? 'Failed to submit rating',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error submitting rating: $e',
        SnackBarStatus.ERROR,
      );
      print('Error submitting rating: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
