import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/engagement_common.dart';
import 'engagement_details_controller.dart';
import 'job/job_engagement_details_screen.dart';
import 'package/package_engagement_details_screen.dart';
import 'service/service_engagement_details_screen.dart';

/// Dispatcher for the engagement details flow. Keeps the existing
/// [RouteConstant.engagementDetailsScreen] route so every caller keeps working,
/// then renders the type-specific screen once the engagement type resolves.
/// All three screens share the single [EngagementDetailsController].
class EngagementDetailsScreen extends StatelessWidget {
  const EngagementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EngagementDetailsController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _centered(
              context,
              ProgressBar(color: context.resources.color.colorPrimary),
            );
          }

          final engagement = controller.engagement.value;
          if (engagement == null) {
            return _centered(
              context,
              PrimaryText(
                text: context.resources.strings.noTaskDetailsAvailable,
                fontSize: 14,
                textColor: context.resources.color.colorGrey,
              ),
            );
          }

          if (controller.isJob.value) {
            return const JobEngagementDetailsScreen();
          }
          if (controller.isPackage.value) {
            return const PackageEngagementDetailsScreen();
          }
          if (controller.isService.value) {
            return const ServiceEngagementDetailsScreen();
          }

          // Engagement loaded but its type payload isn't resolved yet.
          return _centered(
            context,
            ProgressBar(color: context.resources.color.colorPrimary),
          );
        }),
      ),
    );
  }

  Widget _centered(BuildContext context, Widget child) {
    return Column(
      children: [
        const EngagementBackBar(),
        Expanded(child: Center(child: child)),
      ],
    );
  }
}
