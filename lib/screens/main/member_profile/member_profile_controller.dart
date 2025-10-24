import 'package:get/get.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class MemberProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();

  var user = Rxn<User>();
  var memberProfile = Rxn<MemberProfile>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get user from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is User) {
      user.value = arguments;
      // Fetch full member profile if we have the hashcode
      if (user.value?.hashcode != null) {
        fetchMemberProfile(user.value!.hashcode!);
      }
    }
  }

  Future<void> fetchMemberProfile(String memberHashcode) async {
    try {
      isLoading.value = true;

      final response = await _profileRepository.getMemberProfile(
        filters: {
          'hashcode': memberHashcode,
          'ratings': '1',
          'skills': '1',
          'services': '1',
          'packages': '1',
          'jobs': '1',
        },
      );

      if (response.success == true && response.data != null) {
        memberProfile.value = response.data;

        // Debug logging
        print('=== Member Profile Fetched ===');
        print(
          'Member: ${response.data!.member?.firstName} ${response.data!.member?.lastName}',
        );
        print('Skills count: ${response.data!.skills?.length ?? 0}');
        if (response.data!.skills != null) {
          for (var skill in response.data!.skills!) {
            print('  - ${skill.name}');
          }
        }
        print('Services count: ${response.data!.services?.length ?? 0}');
        print('Packages count: ${response.data!.packages?.length ?? 0}');
        print('Jobs count: ${response.data!.jobs?.length ?? 0}');
        print('==============================');

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
      isLoading.value = false;
    }
  }
}
