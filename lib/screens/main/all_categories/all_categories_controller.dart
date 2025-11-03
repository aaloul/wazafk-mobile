import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../repository/app/categories_repository.dart';

class AllCategoriesController extends GetxController {
  final CategoriesRepository _categoriesRepository = CategoriesRepository();

  var categories = <Category>[].obs;
  var allCategories = <Category>[].obs; // Store all categories
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await _categoriesRepository.getCategories(
        type: 'S', // 'S' for service categories
      );

      if (response.success == true && response.data?.list != null) {
        allCategories.value = response.data!.list!;
        categories.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Error fetching categories',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error fetching categories: $e',
        SnackBarStatus.ERROR,
      );
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchCategories(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      // Show all categories when search is empty
      categories.value = allCategories;
      return;
    }

    // Filter categories by name (case insensitive)
    categories.value = allCategories.where((category) {
      final categoryName = category.name?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return categoryName.contains(searchLower);
    }).toList();
  }

  void onCategoryTap(Category category) {
    // If this category has subcategories, navigate to subcategories screen
    if (category.hasSubCategories == true) {
      Get.toNamed(RouteConstant.subcategoriesScreen, arguments: category);
    } else {
      // Navigate to search screen with this category
      Get.toNamed(RouteConstant.searchScreen, arguments: category);
    }
  }
}
