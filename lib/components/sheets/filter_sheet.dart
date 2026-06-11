import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/repository/app/categories_repository.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

enum FilterSort { recommended, newest, highestBudget, rating }

enum FilterBudget { under50, b50to150, b150to500, b500plus }

enum FilterEmployerRating { threePlus, fourPlus, fourFivePlus }

enum FilterApplicants { under5, fiveToTen, tenToTwenty, twentyPlus }

class HomeFilters {
  /// Slider maximum. At this value the distance is treated as "no limit" and
  /// is omitted from the API params (so defaults / Reset send no attributes).
  static const double maxDistanceKm = 50;

  FilterSort? sort;
  Category? category;

  /// Multi-select categories. When non-empty, takes precedence over [category]
  /// and is sent to the API as `category_list[0..n]`. Empty by default so the
  /// existing single-pick UI keeps working through [category].
  List<Category> categories;
  FilterBudget? budget;
  double distanceKm;
  FilterEmployerRating? employerRating;
  FilterApplicants? applicants;

  HomeFilters({
    this.sort,
    this.category,
    List<Category>? categories,
    this.budget,
    this.distanceKm = maxDistanceKm,
    this.employerRating,
    this.applicants,
  }) : categories = categories ?? <Category>[];

  HomeFilters copy() => HomeFilters(
        sort: sort,
        category: category,
        categories: List.of(categories),
        budget: budget,
        distanceKm: distanceKm,
        employerRating: employerRating,
        applicants: applicants,
      );
}

/// Maps [HomeFilters] to the query params used by `/v2/search/*` and the
/// home endpoints. Empty selections are omitted.
extension HomeFiltersApi on HomeFilters {
  Map<String, String> toSearchParams() {
    final params = <String, String>{};

    switch (sort) {
      case FilterSort.newest:
        params['sort_by'] = 'date_desc';
        break;
      case FilterSort.highestBudget:
        params['sort_by'] = 'price_desc';
        break;
      case FilterSort.rating:
        params['sort_by'] = 'rating_desc';
        break;
      case FilterSort.recommended:
      case null:
        break;
    }

    // Multi-select wins over single-pick; sent as category_list[0..n] per v2 API.
    if (categories.isNotEmpty) {
      for (var i = 0; i < categories.length; i++) {
        final h = categories[i].hashcode;
        if (h != null) params['category_list[$i]'] = h;
      }
    } else if (category?.hashcode != null) {
      params['category'] = category!.hashcode!;
    }

    switch (budget) {
      case FilterBudget.under50:
        params['min_price'] = '0';
        params['max_price'] = '50';
        break;
      case FilterBudget.b50to150:
        params['min_price'] = '50';
        params['max_price'] = '150';
        break;
      case FilterBudget.b150to500:
        params['min_price'] = '150';
        params['max_price'] = '500';
        break;
      case FilterBudget.b500plus:
        params['min_price'] = '500';
        break;
      case null:
        break;
    }

    // Only constrain distance when the user narrowed it below the max; at the
    // max value (and on Reset/default) it means "no limit" so we send nothing.
    if (distanceKm > 0 && distanceKm < HomeFilters.maxDistanceKm) {
      params['min_distance'] = '0';
      params['max_distance'] = distanceKm.toInt().toString();
    }

    switch (employerRating) {
      case FilterEmployerRating.threePlus:
        params['min_member_rating'] = '3';
        break;
      case FilterEmployerRating.fourPlus:
        params['min_member_rating'] = '4';
        break;
      case FilterEmployerRating.fourFivePlus:
        params['min_member_rating'] = '4.5';
        break;
      case null:
        break;
    }

    switch (applicants) {
      case FilterApplicants.under5:
        params['min_applicants'] = '0';
        params['max_applicants'] = '4';
        break;
      case FilterApplicants.fiveToTen:
        params['min_applicants'] = '5';
        params['max_applicants'] = '10';
        break;
      case FilterApplicants.tenToTwenty:
        params['min_applicants'] = '10';
        params['max_applicants'] = '20';
        break;
      case FilterApplicants.twentyPlus:
        params['min_applicants'] = '20';
        break;
      case null:
        break;
    }

    return params;
  }
}

class FilterSheet extends StatefulWidget {
  final HomeFilters initialFilters;
  final ValueChanged<HomeFilters> onApply;

  const FilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late HomeFilters _filters;
  HomeController? _homeController;
  final CategoriesRepository _categoriesRepository = CategoriesRepository();

  /// Subcategories of the currently selected [HomeFilters.category], loaded the
  /// same way the home screen loads them, shown as multi-select chips.
  List<Category> _subcategories = <Category>[];
  bool _loadingSubcategories = false;

  static const double _maxDistance = HomeFilters.maxDistanceKm;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters.copy();
    try {
      _homeController = Get.find<HomeController>();
    } catch (_) {}
    _initCategorySelection();
  }

  /// Selected subcategories live in [HomeFilters.categories]; the parent
  /// category in [HomeFilters.category]. When the incoming filters carry
  /// subcategories without a parent (e.g. picked from the home category bar),
  /// derive the parent so its chips render highlighted.
  void _initCategorySelection() {
    if (_filters.category == null && _filters.categories.isNotEmpty) {
      final parentHash =
          _filters.categories.first.parentHashcode?.toString();
      if (parentHash != null && parentHash.isNotEmpty) {
        final list = _availableCategories();
        for (final c in list) {
          if (c.hashcode == parentHash) {
            _filters.category = c;
            break;
          }
        }
      }
    }
    if (_filters.category != null) {
      _fetchSubcategories(_filters.category!);
    }
  }

  /// Job categories for freelancers, service categories for employers — the
  /// same source the home category bar uses.
  List<Category> _availableCategories() {
    final bool isFreelancer = _homeController?.isFreelancerMode.value ?? false;
    return (isFreelancer
            ? _homeController?.jobCategories
            : _homeController?.categories)
            ?.toList() ??
        <Category>[];
  }

  Future<void> _fetchSubcategories(Category parent) async {
    if (parent.hashcode == null) return;
    setState(() {
      _loadingSubcategories = true;
      _subcategories = <Category>[];
    });
    try {
      final bool isFreelancer =
          _homeController?.isFreelancerMode.value ?? false;
      final response = await _categoriesRepository.getCategories(
        parent: parent.hashcode!,
        type: parent.type ?? (isFreelancer ? 'J' : 'S'),
      );
      // Ignore late responses if the selection changed meanwhile.
      if (!mounted || _filters.category?.hashcode != parent.hashcode) return;
      setState(() {
        _subcategories =
            (response.success == true && response.data?.list != null)
                ? response.data!.list!
                : <Category>[];
      });
    } catch (_) {
      if (mounted && _filters.category?.hashcode == parent.hashcode) {
        setState(() => _subcategories = <Category>[]);
      }
    } finally {
      if (mounted && _filters.category?.hashcode == parent.hashcode) {
        setState(() => _loadingSubcategories = false);
      }
    }
  }

  void _onCategorySelected(Category? category) {
    setState(() {
      _filters.category = category;
      _filters.categories = <Category>[];
      _subcategories = <Category>[];
      _loadingSubcategories = false;
    });
    if (category != null) _fetchSubcategories(category);
  }

  void _toggleSubcategory(Category sub) {
    setState(() {
      final index =
          _filters.categories.indexWhere((e) => e.hashcode == sub.hashcode);
      if (index >= 0) {
        _filters.categories.removeAt(index);
      } else {
        _filters.categories.add(sub);
      }
    });
  }

  void _reset() {
    setState(() {
      _filters = HomeFilters();
      _subcategories = <Category>[];
      _loadingSubcategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = Resources.of(context).strings;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        color: context.resources.color.colorWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSortCard(context, strings),
                    const SizedBox(height: 16),
                    _buildFilterCard(context, strings),
                  ],
                ),
              ),
            ),
            _buildFooter(context, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 4),
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: context.resources.color.colorGrey6,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSortCard(BuildContext context, dynamic strings) {
    final items = <_SortItem>[
      _SortItem(
        sort: FilterSort.recommended,
        label: strings.recommended,
        iconAsset: AppIcons.filterRecommended,
      ),
      _SortItem(
        sort: FilterSort.newest,
        label: strings.newest,
        iconAsset: AppIcons.filterNewest,
      ),
      _SortItem(
        sort: FilterSort.highestBudget,
        label: strings.highestBudget,
        iconAsset: AppIcons.filterHighestBudget,
      ),
      _SortItem(
        sort: FilterSort.rating,
        label: strings.rating,
        iconAsset: AppIcons.filterRating,
      ),
    ];

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  text: strings.sortBy,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: context.resources.color.colorBlack,
                ),
                GestureDetector(
                  onTap: _reset,
                  child: PrimaryText(
                    text: strings.reset,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorPrimary,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            _buildSortRow(context, items[i]),
            if (i < items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  color: context.resources.color.colorGrey4,
                ),
              ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSortRow(BuildContext context, _SortItem item) {
    final selected = _filters.sort == item.sort;
    return InkWell(
      onTap: () => setState(() {
        _filters.sort = selected ? null : item.sort;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Image.asset(
              item.iconAsset,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryText(
                text: item.label,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: context.resources.color.colorBlack,
              ),
            ),
            _buildRadio(context, selected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(BuildContext context, bool selected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? context.resources.color.colorPrimary
              : context.resources.color.colorGrey6,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.resources.color.colorPrimary,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFilterCard(BuildContext context, dynamic strings) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: strings.filter,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorBlack,
            ),
            const SizedBox(height: 16),
            _buildCategoryPicker(context, strings),
            _buildSectionDivider(context),
            _buildBudget(context, strings),
            _buildSectionDivider(context),
            _buildDistance(context, strings),
            _buildSectionDivider(context),
            _buildEmployerRating(context, strings),
            _buildSectionDivider(context),
            _buildApplicants(context, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1,
        color: context.resources.color.colorGrey4,
      ),
    );
  }

  Widget _buildCategoryPicker(BuildContext context, dynamic strings) {
    // Freelancers filter jobs (job categories, type J); employers filter
    // services/packages (service categories, type S).
    final categories = _availableCategories();
    final selected = _filters.category;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showCategoryPicker(context, categories),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.resources.color.colorWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.resources.color.colorGrey4,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryText(
                    text: selected?.name ?? strings.selectCategory,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    textColor: selected != null
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey8,
                    maxLines: 1,
                  ),
                ),
                Image.asset(
                  AppIcons.filterChevronDown,
                  width: 22,
                  height: 22,
                ),
              ],
            ),
          ),
        ),
        _buildSubcategoryChips(context),
      ],
    );
  }

  /// Multi-select subcategory chips shown once a category is picked — same
  /// behaviour and look as the home category bar (design p35).
  Widget _buildSubcategoryChips(BuildContext context) {
    if (_filters.category == null) return const SizedBox.shrink();

    if (_loadingSubcategories && _subcategories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.resources.color.colorPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (_subcategories.isEmpty) return const SizedBox.shrink();

    final selectedHashes =
        _filters.categories.map((c) => c.hashcode).toSet();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _subcategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, index) {
            final sub = _subcategories[index];
            final selected = selectedHashes.contains(sub.hashcode);
            return _SubcategoryChip(
              label: sub.name ?? '',
              selected: selected,
              onTap: () => _toggleSubcategory(sub),
            );
          },
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, List<Category> categories) {
    if (categories.isEmpty) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.resources.color.colorWhite,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.6,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: categories.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: context.resources.color.colorGrey4,
            ),
            itemBuilder: (_, index) {
              final c = categories[index];
              final isSelected = _filters.category?.hashcode == c.hashcode;
              return ListTile(
                title: PrimaryText(
                  text: c.name ?? '',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textColor: isSelected
                      ? context.resources.color.colorPrimary
                      : context.resources.color.colorBlack,
                ),
                trailing: _buildRadio(context, isSelected),
                onTap: () {
                  // Single-select: re-tapping clears the selection.
                  _onCategorySelected(isSelected ? null : c);
                  Navigator.of(sheetContext).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBudget(BuildContext context, dynamic strings) {
    final items = <MapEntry<FilterBudget, String>>[
      const MapEntry(FilterBudget.under50, 'Under \$50'),
      const MapEntry(FilterBudget.b50to150, '\$50 - \$150'),
      const MapEntry(FilterBudget.b150to500, '\$150 - \$500'),
      const MapEntry(FilterBudget.b500plus, '\$500+'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, strings.budget),
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final entry = items[index];
              final selected = _filters.budget == entry.key;
              return _PillChip(
                label: entry.value,
                selected: selected,
                onTap: () => setState(() {
                  _filters.budget = selected ? null : entry.key;
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDistance(BuildContext context, dynamic strings) {
    final value = _filters.distanceKm.clamp(0, _maxDistance);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, strings.distance),
        const SizedBox(height: 8),
        _DistanceSlider(
          value: value.toDouble(),
          max: _maxDistance,
          kmLabel: strings.km,
          onChanged: (v) => setState(() => _filters.distanceKm = v),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryText(
              text: '0 ${strings.km}',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey8,
            ),
            PrimaryText(
              text: '${_maxDistance.toInt()} ${strings.km}',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey8,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployerRating(BuildContext context, dynamic strings) {
    final items = <MapEntry<FilterEmployerRating, String>>[
      MapEntry(FilterEmployerRating.threePlus, '3'),
      MapEntry(FilterEmployerRating.fourPlus, '4'),
      MapEntry(FilterEmployerRating.fourFivePlus, '4.5'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, strings.employerRating),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((entry) {
            final selected = _filters.employerRating == entry.key;
            return _PillChip(
              selected: selected,
              onTap: () => setState(() {
                _filters.employerRating = selected ? null : entry.key;
              }),
              builder: (textColor) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryText(
                      text: entry.value,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: textColor,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: context.resources.color.colorPrimary,
                    ),
                    const SizedBox(width: 4),
                    PrimaryText(
                      text: strings.andUp,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: textColor,
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplicants(BuildContext context, dynamic strings) {
    final items = <MapEntry<FilterApplicants, String>>[
      const MapEntry(FilterApplicants.under5, 'Under 5'),
      const MapEntry(FilterApplicants.fiveToTen, '5 - 10'),
      const MapEntry(FilterApplicants.tenToTwenty, '10 - 20'),
      const MapEntry(FilterApplicants.twentyPlus, '20 +'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, strings.applicants),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((entry) {
            final selected = _filters.applicants == entry.key;
            return _PillChip(
              label: entry.value,
              selected: selected,
              onTap: () => setState(() {
                _filters.applicants = selected ? null : entry.key;
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return PrimaryText(
      text: label,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      textColor: context.resources.color.colorGrey8,
    );
  }

  Widget _buildFooter(BuildContext context, dynamic strings) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: PrimaryButton(
          title: strings.applyFilter,
          height: 52,
          borderRadius: 14,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          onPressed: () {
            widget.onApply(_filters);
            Get.back();
          },
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.resources.color.colorGrey4,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _SortItem {
  final FilterSort sort;
  final String label;
  final String iconAsset;

  _SortItem({
    required this.sort,
    required this.label,
    required this.iconAsset,
  });
}

class _PillChip extends StatelessWidget {
  final String? label;
  final bool selected;
  final VoidCallback onTap;
  final Widget Function(Color textColor)? builder;

  const _PillChip({
    this.label,
    required this.selected,
    required this.onTap,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? context.resources.color.colorPrimary
        : context.resources.color.colorBlack;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? context.resources.color.colorPrimary
                : context.resources.color.colorGrey4,
            width: 1,
          ),
        ),
        child: builder != null
            ? builder!(textColor)
            : PrimaryText(
                text: label ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: textColor,
              ),
      ),
    );
  }
}

/// Subcategory chip — mirrors the home subcategory chip (design p35).
class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.resources.color.colorPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? context.resources.color.colorPrimaryLight
              : context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? primary : context.resources.color.colorGrey25,
            width: 1,
          ),
        ),
        child: PrimaryText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          textColor: selected ? primary : context.resources.color.colorBlack,
        ),
      ),
    );
  }
}

class _DistanceSlider extends StatelessWidget {
  final double value;
  final double max;
  final String kmLabel;
  final ValueChanged<double> onChanged;

  const _DistanceSlider({
    required this.value,
    required this.max,
    required this.kmLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const handleSize = 14.0;
        final fraction = (value / max).clamp(0.0, 1.0);
        final trackLeft = handleSize / 2;
        final trackWidth = width - handleSize;
        final handleCenter = trackLeft + trackWidth * fraction;

        return SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bubble label above handle
              Positioned(
                left: handleCenter - 22,
                top: 0,
                child: _DistanceBubble(
                  value: value.toInt(),
                  kmLabel: kmLabel,
                ),
              ),
              // Track
              Positioned(
                left: 0,
                right: 0,
                top: 42,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorGrey4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Active track
              Positioned(
                left: 0,
                top: 42,
                child: Container(
                  width: handleCenter,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Slider for interaction (transparent overlay)
              Positioned(
                left: 0,
                right: 0,
                top: 32,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 0,
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    thumbColor: context.resources.color.colorPrimary,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: max,
                    value: value,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DistanceBubble extends StatelessWidget {
  final int value;
  final String kmLabel;

  const _DistanceBubble({required this.value, required this.kmLabel});

  @override
  Widget build(BuildContext context) {
    final color = context.resources.color.colorPrimary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryText(
                text: '$value',
                textAlign: TextAlign.center,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorWhite,
              ),
              PrimaryText(
                text: kmLabel,
                textAlign: TextAlign.center,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                textColor: context.resources.color.colorWhite,
              ),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter(color),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
