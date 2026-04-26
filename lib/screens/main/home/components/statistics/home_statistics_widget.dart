import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class HomeStatisticsWidget extends StatefulWidget {
  const HomeStatisticsWidget({super.key});

  @override
  State<HomeStatisticsWidget> createState() => _HomeStatisticsWidgetState();
}

class _HomeStatisticsWidgetState extends State<HomeStatisticsWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric( vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() {
        final pages = [
          Row(
            children: [
              StatisticsItem(
                title: context.resources.strings.totalEarnings,
                value: '\$${controller.totalEarnings.value}',
              ),
              SizedBox(width: 10),
              StatisticsItem(
                title: context.resources.strings.activeJobs,
                value: '${controller.nbActiveJobs.value}',
              ),
            ],
          ),
          Row(
            children: [
              StatisticsItem(
                title: context.resources.strings.completed,
                value: '${controller.nbCompletedJobs.value}',
              ),
              SizedBox(width: 10),
              StatisticsItem(
                title: context.resources.strings.successRate,
                value: '${controller.successRate.value}%',
              ),
            ],
          ),
        ];

        return Column(
          children: [
            SizedBox(
              height: 70,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: pages,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: _currentPage == index ? 10 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary.withOpacity(
                      _currentPage == index ? 1 : 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

class StatisticsItem extends StatelessWidget {
  const StatisticsItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: context.resources.color.colorPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric( horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

                Expanded(
                  child: PrimaryText(
                    text: title,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorSnowWhite,
                  ),
                ),



            SizedBox(width: 4),

            PrimaryText(
              text: value,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorWhite,
            ),
          ],
        ),
      ),
    );
  }
}
