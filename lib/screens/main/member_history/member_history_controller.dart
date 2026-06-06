import 'package:get/get.dart';
import 'package:wazafak_app/model/MemberReviewsResponse.dart';
import 'package:wazafak_app/networking/services/rating/member_reviews_service.dart';

enum HistoryType { hiring, work }

class MemberHistoryArgs {
  const MemberHistoryArgs({
    required this.memberHashcode,
    required this.type,
  });
  final String memberHashcode;
  final HistoryType type;
}

class MemberHistoryController extends GetxController {
  final _service = MemberReviewsService();

  final reviews = <MemberReview>[].obs;
  final isLoading = false.obs;
  late MemberHistoryArgs args;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as MemberHistoryArgs;
    fetch();
  }

  Future<void> fetch() async {
    try {
      isLoading.value = true;
      // target 'C' = ratings the member received as a client (hiring history);
      // 'F' = ratings as a freelancer (work history).
      final target = args.type == HistoryType.hiring ? 'C' : 'F';
      final response = await _service.getMemberReviews(
        filters: {
          'member': args.memberHashcode,
          'target': target,
        },
      );
      if (response.success == true) {
        reviews.value = response.data ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }
}
