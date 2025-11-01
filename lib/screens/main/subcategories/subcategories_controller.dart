import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../repository/app/categories_repository.dart';

class SubcategoriesController extends GetxController {
  final CategoriesRepository _categoriesRepository = CategoriesRepository();

  var parentCategory = Rxn<Category>();
  var subcategories = <Category>[].obs;
  var allSubcategories = <Category>[].obs; // Store all subcategories
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Get parent category from arguments
    if (Get.arguments != null && Get.arguments is Category) {
      parentCategory.value = Get.arguments as Category;
      fetchSubcategories();
    }
  }

  Future<void> fetchSubcategories() async {
    if (parentCategory.value?.hashcode == null) return;

    try {
      isLoading.value = true;

      final response = await _categoriesRepository.getCategories(
        parent: parentCategory.value!.hashcode!,
        type: 'S',
      );

      if (response.success == true && response.data?.list != null) {
        allSubcategories.value = response.data!.list!;
        subcategories.value = response.data!.list!;
      } else {
        constants.showSnackBar(
          response.message ?? 'Error fetching subcategories',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      constants.showSnackBar(
        'Error fetching subcategories: $e',
        SnackBarStatus.ERROR,
      );
      print('Error fetching subcategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchSubcategories(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      // Show all subcategories when search is empty
      subcategories.value = allSubcategories;
      return;
    }

    // Filter subcategories by name (case insensitive)
    subcategories.value = allSubcategories.where((category) {
      final categoryName = category.name?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return categoryName.contains(searchLower);
    }).toList();
  }

  void onSubcategoryTap(Category subcategory) {
    // If this subcategory has more subcategories, navigate to another subcategories screen
    if (subcategory.hasSubCategories == true) {
      Get.toNamed(RouteConstant.subcategoriesScreen, arguments: subcategory);
    } else {
      // Navigate to search screen with this subcategory
      Get.toNamed(RouteConstant.searchScreen, arguments: subcategory);
    }
  }
}
