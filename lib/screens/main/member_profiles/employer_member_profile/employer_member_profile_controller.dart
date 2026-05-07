import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/repository/member/profile_repository.dart';
import 'package:wazafak_app/utils/utils.dart';

class EmployerMemberProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final EngagementsListRepository _engagementsListRepository = EngagementsListRepository();

  var user = Rxn<User>();
  var memberProfile = Rxn<MemberProfile>();
  var engagements = <Engagement>[].obs;
  var isLoading = false.obs;
  var isLoadingEngagements = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments is User) {
      user.value = arguments;
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

        if (response.data!.member != null) {
          user.value = response.data!.member;
        }

        fetchMemberEngagements(memberHashcode);
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMemberEngagements(String memberHashcode) async {
    try {
      isLoadingEngagements.value = true;

      final response = await _engagementsListRepository.getEngagements(
        filters: {
          'employer': memberHashcode,
          'status': '1',
        },
      );

      if (response.success == true && response.data?.list != null) {
        engagements.value = response.data!.list!;
      }
    } catch (e) {
      print('Error fetching member engagements: $e');
    } finally {
      isLoadingEngagements.value = false;
    }
  }
}
