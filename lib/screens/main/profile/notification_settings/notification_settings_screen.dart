import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/notif_toggle_card.dart';
import 'notification_settings_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSettingsController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.notifications),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => NotifToggleCard(
                          title: strings.notificationChannels,
                          children: [
                            NotifToggleRow(
                              label: strings.pushNotifications,
                              value: controller.channelPush.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.channelPush, v),
                            ),
                            NotifToggleRow(
                              label: strings.emailNotifications,
                              value: controller.channelEmail.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.channelEmail, v),
                            ),
                            NotifToggleRow(
                              label: strings.inAppNotifications,
                              value: controller.channelInApp.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.channelInApp, v),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Obx(() => NotifToggleCard(
                          title: strings.employer,
                          children: [
                            NotifToggleRow(
                              label: strings.requests,
                              value: controller.empRequests.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.empRequests, v),
                            ),
                            NotifToggleRow(
                              label: strings.newApplications,
                              value: controller.empNewApplications.value,
                              onChanged: (v) => controller.toggle(
                                  controller.empNewApplications, v),
                            ),
                            NotifToggleRow(
                              label: strings.jobUpdates,
                              value: controller.empJobUpdates.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.empJobUpdates, v),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Obx(() => NotifToggleCard(
                          title: strings.freelancer,
                          children: [
                            NotifToggleRow(
                              label: strings.newJobPostings,
                              value: controller.freelancerNewPostings.value,
                              onChanged: (v) => controller.toggle(
                                  controller.freelancerNewPostings, v),
                            ),
                            NotifToggleRow(
                              label: strings.applicationUpdates,
                              value: controller
                                  .freelancerApplicationUpdates.value,
                              onChanged: (v) => controller.toggle(
                                  controller.freelancerApplicationUpdates, v),
                            ),
                            NotifToggleRow(
                              label: strings.jobRequests,
                              value: controller.freelancerJobRequests.value,
                              onChanged: (v) => controller.toggle(
                                  controller.freelancerJobRequests, v),
                            ),
                            NotifToggleRow(
                              label: strings.jobUpdates,
                              value: controller.freelancerJobUpdates.value,
                              onChanged: (v) => controller.toggle(
                                  controller.freelancerJobUpdates, v),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Obx(() => NotifToggleCard(
                          title: strings.soundAndAlerts,
                          children: [
                            NotifToggleRow(
                              label: strings.notificationsSound,
                              value: controller.soundOn.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.soundOn, v),
                            ),
                            NotifToggleRow(
                              label: strings.vibrate,
                              value: controller.vibrateOn.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.vibrateOn, v),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Obx(() => NotifToggleCard(
                          title: strings.generalGroup,
                          children: [
                            NotifToggleRow(
                              label: strings.messagesNotif,
                              value: controller.generalMessages.value,
                              onChanged: (v) => controller.toggle(
                                  controller.generalMessages, v),
                            ),
                            NotifToggleRow(
                              label: strings.payments,
                              value: controller.generalPayments.value,
                              onChanged: (v) => controller.toggle(
                                  controller.generalPayments, v),
                            ),
                            NotifToggleRow(
                              label: strings.reviewsNotif,
                              value: controller.generalReviews.value,
                              onChanged: (v) =>
                                  controller.toggle(controller.generalReviews, v),
                            ),
                          ],
                        )),
                    const SizedBox(height: 12),
                    Obx(() => NotifToggleCard(
                          title: strings.wazafakAnnouncements,
                          children: [
                            NotifToggleRow(
                              label: strings.promotionsAndOffers,
                              value: controller.annoucementsPromos.value,
                              onChanged: (v) => controller.toggle(
                                  controller.annoucementsPromos, v),
                            ),
                            NotifToggleRow(
                              label: strings.discountAvailable,
                              value: controller.annoucementsDiscounts.value,
                              onChanged: (v) => controller.toggle(
                                  controller.annoucementsDiscounts, v),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
