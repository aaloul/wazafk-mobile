import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/search_widget.dart';
import '../../../components/sheets/sheets_helper.dart';
import '../../../constants/route_constant.dart';
import '../../../utils/Prefs.dart';
import '../../../utils/res/AppIcons.dart';
import 'components/categories/home_subcategories_widget.dart';
import 'components/employer_data/employer_home_data_widget.dart';
import 'components/home_header.dart';
import 'components/jobs/home_jobs_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return FocusDetector(
      onFocusGained: () {
        if (Prefs.getLoggedIn) {
          controller.fetchProfile();
        }

        // controller.fetchEngagements();
        if (controller.isFreelancerMode.value) {
          controller.fetchJobs();
        } else {
          controller.fetchEmployerHome();
        }
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background2,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshHomeData,
            color: context.resources.color.colorPrimary,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  HomeHeader(
                    isFreelancerMode: controller.isFreelancerMode.value,
                  ),
                  HomeSubcategoriesWidget(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 16),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteConstant.searchScreen);
                          },
                          child: AbsorbPointer(
                            child: SearchWidget(
                              enabled: false,
                              borderRadius: 12,
                              height: 45,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          SheetHelper.showFilterSheet(
                            context,
                            initialFilters: controller.activeFilters.value
                                .copy(),
                            onApply: controller.applyFilters,
                          );
                        },
                        child: Container(
                          width: 45,
                          height: 45,
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
                      SizedBox(width: 16),
                    ],
                  ),

                  Obx(() {
                    if (controller.isFreelancerMode.value) {
                      return Column(
                        children: [
                          // SizedBox(height: 16),
                          // SizedBox(height: 16),
                          // HomeEngagementsWidget(),
                          SizedBox(height: 16),
                          HomeJobsWidget(),
                          SizedBox(height: 16),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          // SizedBox(height: 16),
                          // HomeEngagementsWidget(),
                          SizedBox(height: 16),
                          EmployerHomeDataWidget(),
                          SizedBox(height: 16),
                        ],
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
