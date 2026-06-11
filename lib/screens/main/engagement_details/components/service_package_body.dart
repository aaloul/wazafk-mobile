import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'engagement_bottom_actions.dart';
import 'engagement_common.dart';
import 'engagement_content_cards.dart';
import 'engagement_header_card.dart';

/// Shared body for service- and package-booking engagement details
/// (design p57 "Booking request" / p215 "Inquiry"). Everything below the title
/// sits inside one outer card: the member pill + budget chip, then the Brief,
/// Location and Dates sub-cards. The two types differ only in the (package-only)
/// services chips, resolved by [EngagementSkillsCard].
class ServicePackageEngagementBody extends StatelessWidget {
  const ServicePackageEngagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final strings = Resources.of(context).strings;
    final engagement = controller.engagement.value!;
    final type = engagement.type.toString();

    const zero = EdgeInsets.zero;

    final hasServices = type == 'PB' &&
        engagement.package?.services != null &&
        engagement.package!.services!.isNotEmpty;
    final hasBrief =
        (engagement.description ?? '').toString().trim().isNotEmpty;
    final hasLocation = engagement.workLocationType.toString().isNotEmpty ||
        engagement.address != null;
    final hasDates =
        engagement.startDatetime != null || engagement.expiryDatetime != null;
    final hasMsg =
        (engagement.messageToFreelancer ?? '').toString().trim().isNotEmpty;
    final hasMilestones =
        (engagement.tasksMilestones ?? '').toString().trim().isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EngagementHeaderCard(showCategory: false),
                const SizedBox(height: 16),

                // Outer "Booking request" card holding everything (design p57).
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: engagementCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: strings.bookingRequest,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: context.resources.color.colorBlack,
                      ),
                      const SizedBox(height: 12),
                      const EngagementMemberPriceRow(margin: zero),
                      if (hasServices) ...[
                        const SizedBox(height: 14),
                        const EngagementSkillsCard(margin: zero),
                      ],
                      if (hasBrief) ...[
                        const SizedBox(height: 14),
                        EngagementSectionCard(
                          title: strings.brief,
                          margin: zero,
                          child: _bodyText(context, engagement.description!),
                        ),
                      ],
                      if (hasLocation) ...[
                        const SizedBox(height: 12),
                        const EngagementLocationCard(margin: zero),
                      ],
                      if (hasDates) ...[
                        const SizedBox(height: 12),
                        const EngagementDatesCard(margin: zero),
                      ],
                      if (hasMsg) ...[
                        const SizedBox(height: 12),
                        EngagementSectionCard(
                          title: strings.messageToFreelancer,
                          margin: zero,
                          child: _bodyText(
                              context, engagement.messageToFreelancer!),
                        ),
                      ],
                      if (hasMilestones) ...[
                        const SizedBox(height: 12),
                        EngagementSectionCard(
                          title: strings.milestones,
                          margin: zero,
                          child:
                              _bodyText(context, engagement.tasksMilestones!),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const EngagementDeliverablesCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        const EngagementBottomActions(),
      ],
    );
  }

  Widget _bodyText(BuildContext context, String text) => PrimaryText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: context.resources.color.colorGrey,
      );
}
