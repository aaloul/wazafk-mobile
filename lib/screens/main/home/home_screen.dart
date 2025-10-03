import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/categories/home_categories_widget.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: 16),
              HomeStatisticsWidget(),
              SizedBox(height: 16),
              HomeCategoriesWidget(),
              SizedBox(height: 16),
              HomeJobsWidget(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
