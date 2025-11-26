import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/categories/home_categories_widget.dart';
import 'components/employer_data/employer_home_data_widget.dart';
import 'components/engagements/home_engagements_widget.dart';
import 'components/home_header.dart';
import 'components/jobs/home_jobs_widget.dart';
import 'components/statistics/home_statistics_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshHomeData,
          color: context.resources.color.colorPrimary,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 16),

                Obx(() {
                  if (controller.isFreelancerMode.value) {
                    // Freelancer view: Statistics, Available Jobs, Engagements
                    return Column(
                      children: [
                        HomeStatisticsWidget(),
                        SizedBox(height: 16),
                        HomeEngagementsWidget(),
                        SizedBox(height: 16),
                        HomeJobsWidget(),
                        SizedBox(height: 16),
                      ],
                    );
                  } else {
                    // Employer view: Categories (Services), Freelancers, Engagements
                    return Column(
                      children: [
                        HomeCategoriesWidget(),
                        SizedBox(height: 16),
                        HomeEngagementsWidget(),
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
    );
  }
}
