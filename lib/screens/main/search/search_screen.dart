import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_freelancer_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_package_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_service_item.dart';
import 'package:wazafak_app/screens/main/home/components/jobs/home_job_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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

    // Auto-focus the search field after the widget is built
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
            TopHeader(hasBack: true, title: 'Search'),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SearchWidget(
                controller: controller.searchController,
                focusNode: _searchFocusNode,
                hint: 'Search jobs, services, packages...',
                borderRadius: 0,
                onTextChangedWithDelay: (text) {
                  controller.search(text);
                },
                enabled: true,
              ),
            ),

            // Search results
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: ProgressBar());
                }

                if (controller.searchQuery.value.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 16),
                        PrimaryText(
                          text: 'Start typing to search',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: PrimaryText(
                            text:
                                'Search for jobs, services, packages, or freelancers',
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

                // Check if there are any results based on mode
                final hasResults = controller.searchResults.isNotEmpty;

                if (!hasResults) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 16),
                        PrimaryText(
                          text: 'No results found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: PrimaryText(
                            text: 'Try searching with different keywords',
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

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: controller.searchResults.length +
                      (controller.hasMorePages.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the bottom
                    if (index == controller.searchResults.length) {
                      return Obx(() =>
                      controller.isLoadingMore.value
                          ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: ProgressBar()),
                      )
                          : SizedBox.shrink());
                    }

                    final item = controller.searchResults[index];

                    // Determine item type and return appropriate widget
                    if (item.entityType == 'SERVICE' && item.service != null) {
                      return HomeServiceItem(
                        service: item.service!,
                        onFavoriteToggle: (service) async {
                          return await controller.toggleServiceFavorite(
                            service,
                          );
                        },
                      );
                    } else if (item.entityType == 'PACKAGE' &&
                        item.package != null) {
                      return HomePackageItem(
                        package: item.package!,
                        onFavoriteToggle: (package) async {
                          return await controller.togglePackageFavorite(
                            package,
                          );
                        },
                      );
                    } else if (item.entityType == 'MEMBER' &&
                        item.member != null) {
                      return HomeFreelancerItem(
                        onFavoriteToggle: (user) async {
                          return await controller.toggleMemberFavorite(user);
                        },
                        freelancer: item.member!,
                      );
                    } else if (item.entityType == 'JOB' &&
                        item.member != null) {
                      return HomeJobItem(
                        job: item.job!,
                        onFavoriteToggle: (job) async {
                          return await controller.toggleJobFavorite(job);
                        },
                      );
                    }

                    return SizedBox.shrink();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
