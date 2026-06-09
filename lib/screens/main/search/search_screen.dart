import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/components/sheets/sheets_helper.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_freelancer_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_package_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_service_item.dart';
import 'package:wazafak_app/screens/main/home/components/jobs/home_job_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import 'search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.fromBottomNav = false});

  final bool fromBottomNav;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = Get.find<SearchController>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _SearchHeader(
              controller: controller,
              focusNode: _searchFocusNode,
              showBack: !widget.fromBottomNav,
              onFilterTap: () {
                SheetHelper.showFilterSheet(
                  context,
                  initialFilters: controller.activeFilters.value.copy(),
                  onApply: controller.applyFilters,
                );
              },
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: context.resources.color.colorGrey4),
            Obx(() {
              if (controller.subcategories.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _SubcategoryChips(controller: controller),
              );
            }),
            Expanded(child: _buildResults(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: ProgressBar());
      }

      if (controller.showSuggestions.value) {
        return _buildSuggestionsView(context, controller);
      }

      if (controller.searchQuery.value.isEmpty) {
        if (controller.searchHistory.isNotEmpty) {
          return _buildHistoryView(context, controller);
        }
        return _buildStartTypingState(context);
      }

      if (controller.searchResults.isEmpty) {
        return _buildNoResultsState(context);
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.searchResults.length +
            (controller.hasMorePages.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.searchResults.length) {
            return Obx(() => controller.isLoadingMore.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: ProgressBar()),
                  )
                : const SizedBox.shrink());
          }
          final item = controller.searchResults[index];
          if (item.entityType == 'SERVICE' && item.service != null) {
            return HomeServiceItem(
              service: item.service!,
              onFavoriteToggle: (s) async =>
                  controller.toggleServiceFavorite(s),
            );
          } else if (item.entityType == 'PACKAGE' && item.package != null) {
            return HomePackageItem(
              package: item.package!,
              onFavoriteToggle: (p) async =>
                  controller.togglePackageFavorite(p),
            );
          } else if (item.entityType == 'MEMBER' && item.member != null) {
            return HomeFreelancerItem(
              freelancer: item.member!,
              onFavoriteToggle: (u) async =>
                  controller.toggleMemberFavorite(u),
            );
          } else if (item.entityType == 'JOB' && item.job != null) {
            return HomeJobItem(
              job: item.job!,
              onFavoriteToggle: (j) async => controller.toggleJobFavorite(j),
            );
          }
          return const SizedBox.shrink();
        },
      );
    });
  }

  Widget _buildStartTypingState(BuildContext context) {
    final strings = Resources.of(context).strings;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,
              size: 80, color: context.resources.color.colorGrey8),
          const SizedBox(height: 16),
          PrimaryText(
            text: strings.startTypingToSearch,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: context.resources.color.colorGrey8,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: PrimaryText(
              text: strings.searchJobsServicesPackages,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final strings = Resources.of(context).strings;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 80, color: context.resources.color.colorGrey8),
          const SizedBox(height: 16),
          PrimaryText(
            text: strings.noResultsFound,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: context.resources.color.colorGrey8,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: PrimaryText(
              text: strings.trySearchingDifferentKeywords,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView(BuildContext context, SearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryText(
                text: context.resources.strings.recentSearches,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorGrey,
              ),
              Obx(() => controller.isClearingHistory.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.resources.color.colorPrimary,
                      ),
                    )
                  : GestureDetector(
                      onTap: controller.clearSearchHistory,
                      child: PrimaryText(
                        text: context.resources.strings.clearAll,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorPrimary,
                      ),
                    )),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final history = controller.searchHistory[index];
              return GestureDetector(
                onTap: () => controller.selectHistoryItem(history),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.resources.color.colorGrey2,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.history,
                          size: 20,
                          color: context.resources.color.colorGrey8),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryText(
                          text: history.search ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ),
                      Icon(Icons.north_west,
                          size: 16,
                          color: context.resources.color.colorGrey8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsView(
      BuildContext context, SearchController controller) {
    if (controller.isLoadingSuggestions.value) {
      return const Center(child: ProgressBar());
    }
    final suggestions = controller.searchSuggestions.toList();
    final searchText = controller.searchController.text.trim();
    final bool showSearchTextAsSuggestion =
        suggestions.isEmpty && searchText.isNotEmpty;
    final int itemCount =
        showSearchTextAsSuggestion ? 1 : suggestions.length;
    if (itemCount == 0) return const SizedBox.shrink();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final String suggestionText = showSearchTextAsSuggestion
            ? searchText
            : (suggestions[index].search ?? '');
        return GestureDetector(
          onTap: () => controller.selectSuggestion(suggestionText),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.resources.color.colorGrey2,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search,
                    size: 20, color: context.resources.color.colorGrey8),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryText(
                    text: suggestionText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorGrey,
                  ),
                ),
                Icon(Icons.north_west,
                    size: 16, color: context.resources.color.colorGrey8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.onFilterTap,
    this.showBack = true,
  });

  final SearchController controller;
  final FocusNode focusNode;
  final VoidCallback onFilterTap;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showBack) ...[
            GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              child: RotatedBox(
                quarterTurns: Utils().isRTL() ? 2 : 0,
                child: Image.asset(AppIcons.back3, width: 40),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: SearchWidget(
              controller: controller.searchController,
              focusNode: focusNode,
              hint:
                  context.resources.strings.searchJobsServicesPackages,
              borderRadius: 12,
              height: 40,
              onTextChangedWithDelay: (text) {
                controller.onSearchTextChanged(text);
              },
              onSearchSubmit: (text) {
                controller.search(text);
              },
              enabled: true,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.resources.color.colorPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  AppIcons.filter,
                  width: 20,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubcategoryChips extends StatelessWidget {
  const _SubcategoryChips({required this.controller});

  final SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subs = controller.subcategories.toList();
      // Read the observable here (inside the Obx's synchronous build) so the
      // reactive subscription is registered. ListView's itemBuilder runs
      // lazily and reads inside it would NOT register on their own.
      final selectedHashcode = controller.selectedSubcategory.value?.hashcode;
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: subs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, index) {
            final sub = subs[index];
            final selected = selectedHashcode == sub.hashcode;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  controller.selectSubcategory(selected ? null : sub),
              child: _SubcategoryChip(sub: sub, selected: selected),
            );
          },
        ),
      );
    });
  }
}

class _SubcategoryChip extends StatelessWidget {
  const _SubcategoryChip({required this.sub, required this.selected});

  final Category sub;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      alignment: Alignment.center,
      child: PrimaryText(
        text: sub.name ?? '',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        textColor: selected
            ? context.resources.color.colorPrimary
            : context.resources.color.colorBlack,
      ),
    );
  }
}
