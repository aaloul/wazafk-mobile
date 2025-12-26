import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/model/RatingCriteriaResponse.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/repository/rating/rate_bulk_repository.dart';
import 'package:wazafak_app/repository/rating/rating_criteria_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../engagement_details/engagement_details_controller.dart';

class RateEngagementController extends GetxController {
  final RatingCriteriaRepository _ratingCriteriaRepository =
      RatingCriteriaRepository();
  final RateBulkRepository _rateBulkRepository = RateBulkRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  final Rx<Engagement?> engagement = Rx<Engagement?>(null);
  final RxBool isLoadingCriteria = false.obs;
  final RxBool isSubmittingRating = false.obs;
  final RxBool isLoadingProfile = false.obs;

  final Rxn<User> user = Rxn<User>();
  final Rxn<MemberProfile> memberProfile = Rxn<MemberProfile>();

  // Member rating criteria
  final RxList<RatingCriteria> memberCriteria = <RatingCriteria>[].obs;
  final RxMap<String, double> memberRatings = <String, double>{}.obs;

  // Service/Job rating criteria
  final RxList<RatingCriteria> itemCriteria = <RatingCriteria>[].obs;
  final RxMap<String, double> itemRatings = <String, double>{}.obs;

  // Comment
  final TextEditingController commentController = TextEditingController();
  final TextEditingController itemCommentController = TextEditingController();

  // Determine if we're rating a freelancer or client
  String get targetUserType {
    final currentUserId = Prefs.getId;
    if (engagement.value?.clientHashcode.toString() == currentUserId) {
      // Current user is client, so we're rating the freelancer
      return 'F';
    } else {
      // Current user is freelancer, so we're rating the client
      return 'C';
    }
  }

  // Determine if we're rating a job or service
  String get itemType {
    final engagementType = engagement.value?.type;
    if (engagementType == 'JA') {
      return 'J';
    } else {
      return 'S';
    }
  }

  // Get the hashcode of the user being rated
  String get targetUserHashcode {
    final currentUserId = Prefs.getId;
    if (engagement.value?.clientHashcode.toString() == currentUserId) {
      return engagement.value?.freelancerHashcode.toString() ?? '';
    } else {
      return engagement.value?.clientHashcode.toString() ?? '';
    }
  }

  // Determine if we should rate the service/job
  // Only rate if the service/job belongs to the member being rated
  bool get shouldRateItem {
    final engagementType = engagement.value?.type;

    if (engagementType == 'JA') {
      // Job Application: Job belongs to CLIENT
      // Only rate job if we're rating the CLIENT
      return targetUserType == 'C';
    } else {
      // Service/Package Booking: Service belongs to FREELANCER
      // Only rate service if we're rating the FREELANCER
      return targetUserType == 'F';
    }
  }

  // Get the item (service/job) hashcode
  String get itemHashcode {
    if (!shouldRateItem) return '';

    if (itemType == 'J') {
      return engagement.value?.job?.hashcode ?? '';
    } else {
      // For service bookings
      if (engagement.value?.services != null &&
          engagement.value!.services!.isNotEmpty) {
        return engagement.value!.services!.first.hashcode ?? '';
      }
      return '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Engagement) {
      engagement.value = arg;

      // Check if both are already rated
      if (engagement.value?.isMemberRated == true &&
          engagement.value?.isSubjectRated == true) {
        constants.showSnackBar(
          'Engagement already rated',
          SnackBarStatus.ERROR,
        );
        Get.back();
        return;
      }

      fetchMemberProfile(targetUserHashcode);
      loadRatingCriteria();
    }
  }

  Future<void> fetchMemberProfile(String memberHashcode) async {
    try {
      isLoadingProfile.value = true;

      final response = await _profileRepository.getMemberProfile(
        filters: {
          'hashcode': memberHashcode,
          'ratings': '1',
          'skills': '1',
          'services': '0',
          'packages': '0',
          'jobs': '0',
        },
      );

      if (response.success == true && response.data != null) {
        memberProfile.value = response.data;

        // Update user with the full profile data
        if (response.data!.member != null) {
          user.value = response.data!.member;
        }
      } else {
        if (response.message != null) {
          constants.showSnackBar(response.message!, SnackBarStatus.ERROR);
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error fetching member profile: $e',
        SnackBarStatus.ERROR,
      );
      print('Error fetching member profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> loadRatingCriteria() async {
    isLoadingCriteria.value = true;
    try {
      // Load member criteria only if not already rated
      if (engagement.value?.isMemberRated != true) {
        final memberResponse = await _ratingCriteriaRepository.getRatingCriteria(
          target: targetUserType,
        );

        if (memberResponse.success == true && memberResponse.data != null) {
          memberCriteria.value = memberResponse.data!;
          // Initialize ratings to 0
          for (var criteria in memberCriteria) {
            memberRatings[criteria.hashcode ?? ''] = 0.0;
          }
        }
      }

      // Load item criteria only if we should rate the item and not already rated
      if (shouldRateItem && engagement.value?.isSubjectRated != true) {
        final itemResponse = await _ratingCriteriaRepository.getRatingCriteria(
          target: itemType,
        );

        if (itemResponse.success == true && itemResponse.data != null) {
          itemCriteria.value = itemResponse.data!;
          // Initialize ratings to 0
          for (var criteria in itemCriteria) {
            itemRatings[criteria.hashcode ?? ''] = 0.0;
          }
        }
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

  void updateMemberRating(String criteriaHashcode, double rating) {
    memberRatings[criteriaHashcode] = rating;
  }

  void updateItemRating(String criteriaHashcode, double rating) {
    itemRatings[criteriaHashcode] = rating;
  }

  // Calculate average rating for member
  double get averageMemberRating {
    if (memberRatings.isEmpty) return 0.0;
    final total = memberRatings.values.fold(0.0, (sum, rating) => sum + rating);
    return total / memberRatings.length;
  }

  // Calculate average rating for item
  double get averageItemRating {
    if (itemRatings.isEmpty) return 0.0;
    final total = itemRatings.values.fold(0.0, (sum, rating) => sum + rating);
    return total / itemRatings.length;
  }

  Future<void> submitRating() async {
    // Check if there's anything to rate
    bool hasMemberToRate = engagement.value?.isMemberRated != true && memberRatings.isNotEmpty;
    bool hasItemToRate = shouldRateItem && engagement.value?.isSubjectRated != true && itemRatings.isNotEmpty;

    if (!hasMemberToRate && !hasItemToRate) {
      constants.showSnackBar(
        'Nothing to rate',
        SnackBarStatus.ERROR,
      );
      return;
    }

    // Validate that all member ratings are filled (only if not already rated)
    if (hasMemberToRate && memberRatings.values.any((rating) => rating == 0.0)) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseRateAllCriteria,
        SnackBarStatus.ERROR,
      );
      return;
    }

    // Validate that all item ratings are filled (only if we should rate and not already rated)
    if (hasItemToRate && itemRatings.values.any((rating) => rating == 0.0)) {
      constants.showSnackBar(
        Resources.of(Get.context!).strings.pleaseRateAllCriteria,
        SnackBarStatus.ERROR,
      );
      return;
    }

    try {
      isSubmittingRating.value = true;

      // Prepare request data - only initialize if member not rated
      Map<String, dynamic> ratingData = {};

      // Add member rating only if not already rated
      if (hasMemberToRate) {
        // Prepare member rating by criteria as string
        Map<String, dynamic> memberRatingByCriteria = {};
        memberRatings.forEach((hashcode, rating) {
          memberRatingByCriteria[hashcode] = rating.toInt().toString();
        });

        ratingData['target'] = targetUserType;
        ratingData['rate_member'] =targetUserHashcode;
        ratingData['rating_by_criteria'] =
            memberRatingByCriteria.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(" ", "");
        ratingData['comment'] = commentController.text.trim();
      }

      // Add service or job rating only if shouldRateItem is true and not already rated
      if (hasItemToRate) {
        // Prepare item rating by criteria as string
        Map<String, dynamic> itemRatingByCriteria = {};
        itemRatings.forEach((hashcode, rating) {
          itemRatingByCriteria[hashcode] = rating.toInt().toString();
        });

        if (itemType == 'J') {
          ratingData['rate_jobs'] = [
            {
              'job': itemHashcode,
              'rating_by_criteria':
                  itemRatingByCriteria.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(" ", ""),
              'comment': itemCommentController.text.trim(),
            }
          ];
        } else {
          ratingData['rate_services'] = [
            {
              'service': itemHashcode,
              'rating_by_criteria':
                  itemRatingByCriteria.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(" ", ""),
              'comment': itemCommentController.text.trim(),
            }
          ];
        }
      }

      final response = await _rateBulkRepository.rateBulk(ratingData);

      if (response.success == true) {
        final controller = Get.put(EngagementDetailsController());
        controller.getEngagementDetails(engagement.value?.hashcode.toString() ?? '');

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
      print('Error submitting rating: $e');
      constants.showSnackBar(
        'Error submitting rating: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isSubmittingRating.value = false;
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    itemCommentController.dispose();
    super.onClose();
  }
}
