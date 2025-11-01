import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/search_widget.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_freelancer_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_package_item.dart';
import 'package:wazafak_app/screens/main/home/components/employer_data/home_service_item.dart';
import 'package:wazafak_app/screens/main/home/components/jobs/home_job_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
              hasBack: true,
              title: 'Search',
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SearchWidget(
                controller: controller.searchController,
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
                            text: 'Search for jobs, services, packages, or freelancers',
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
                final hasResults = controller.isFreelancerMode
                    ? controller.jobResults.isNotEmpty
                    : controller.employerResults.isNotEmpty;

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

                // Display results based on mode
                if (controller.isFreelancerMode) {
                  // Freelancer mode: show jobs
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.jobResults.length,
                    itemBuilder: (context, index) {
                      final job = controller.jobResults[index];
                      return HomeJobItem(
                        job: job,
                        onFavoriteToggle: (job) async {
                          // TODO: Implement favorite toggle
                          return true;
                        },
                      );
                    },
                  );
                } else {
                  // Employer mode: show services, packages, and freelancers
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.employerResults.length,
                    itemBuilder: (context, index) {
                      final item = controller.employerResults[index];

                      // Determine item type and return appropriate widget
                      if (item.entityType == 'SERVICE' &&
                          item.service != null) {
                        return HomeServiceItem(
                          service: item.service!,
                          onFavoriteToggle: (service) async {
                            // TODO: Implement favorite toggle
                            return true;
                          },
                        );
                      } else if (item.entityType == 'Package' &&
                          item.package != null) {
                        return HomePackageItem(
                          package: item.package!,
                          onFavoriteToggle: (package) async {
                            // TODO: Implement favorite toggle
                            return true;
                          },
                        );
                      } else if (item.entityType == 'Member' && item.member !=
                          null) {
                        return HomeFreelancerItem(
                          onFavoriteToggle: (user) async {
                            // TODO: Implement favorite toggle
                            return true;
                          }, freelancer: item.member!,
                        );
                      }

                      return SizedBox.shrink();
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
