import 'package:get/get.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class FreelancerMemberProfileController extends GetxController {
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
        // fetchMemberProfile(user.value!.hashcode!);
        fetchMemberProfile('e0b268610e9c3e609945c9361730b463');
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

  void bookService(Service service) {
    // TODO: Implement booking functionality
    // This could navigate to a booking screen or open a booking dialog
    constants.showSnackBar(
      'Booking functionality for "${service.title}" will be implemented soon',
      SnackBarStatus.INFO,
    );
    print('Book service: ${service.title} (${service.hashcode})');
  }

  void bookPackage(Package package) {
    // TODO: Implement booking functionality
    // This could navigate to a booking screen or open a booking dialog
    constants.showSnackBar(
      'Booking functionality for "${package.title}" will be implemented soon',
      SnackBarStatus.INFO,
    );
    print('Book package: ${package.title} (${package.hashcode})');
  }
}
