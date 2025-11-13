import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/networking/services/engagement/engagements_list_service.dart';

import '../../../utils/Prefs.dart';

class AllEngagementsController extends GetxController {
  final EngagementsListService _service = EngagementsListService();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var engagements = <Engagement>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEngagements(isInitialLoad: true);
  }

  Future<void> fetchEngagements({
    bool refresh = false,
    bool isInitialLoad = false,
  }) async {
    if (refresh) {
      currentPage.value = 1;
      engagements.clear();
      hasMore.value = true;
    }

    if (isLoading.value || isLoadingMore.value) return;

    if (refresh || isInitialLoad) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _service.getEngagements(
        filters: {
          'page': currentPage.value.toString(),
          if (Prefs.getUserMode == 'freelancer') 'freelancer': Prefs.getId,
          if (Prefs.getUserMode == 'employer') 'client': Prefs.getId,
        },
      );

      if (response.success == true && response.data != null) {
        if (refresh) {
          engagements.value = response.data!.list ?? [];
        } else {
          engagements.addAll(response.data!.list ?? []);
        }

        if (response.data!.meta != null) {
          lastPage.value = response.data!.meta!.last ?? 1;
          currentPage.value = response.data!.meta!.page ?? 1;
          hasMore.value = currentPage.value < lastPage.value;
        }
      }
    } catch (e) {
      print('Error fetching engagements: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    currentPage.value++;
    await fetchEngagements();
  }

  Future<void> refresh() async {
    await fetchEngagements(refresh: true);
  }
}
