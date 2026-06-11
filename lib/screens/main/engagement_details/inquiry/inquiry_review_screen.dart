import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../constants/route_constant.dart';
import '../components/engagement_bottom_actions.dart';
import '../components/engagement_common.dart';
import '../components/engagement_content_cards.dart';
import '../components/engagement_header_card.dart';

/// Full-screen view of an incoming inquiry (change request) plus the original
/// request — design p217. Replaces the old ChangeRequestBottomSheet. The
/// non-requester accepts, counter-inquires, or declines the change request.
class InquiryReviewScreen extends StatelessWidget {
  const InquiryReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final strings = Resources.of(context).strings;

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Obx(() {
          final engagement = controller.engagement.value;
          final changeRequests = engagement?.changeRequests;
          if (engagement == null ||
              changeRequests == null ||
              changeRequests.isEmpty) {
            return Column(
              children: [
                const EngagementBackBar(),
                Expanded(
                  child: Center(
                    child: PrimaryText(
                      text: strings.noChangeRequestDetailsAvailable,
                      fontSize: 14,
                      textColor: context.resources.color.colorGrey,
                    ),
                  ),
                ),
              ],
            );
          }

          final cr = changeRequests.first;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const EngagementHeaderCard(showCategory: false),
                      const SizedBox(height: 16),

                      // ── Incoming inquiry (the change request) ──────────────
                      _OuterCard(
                        heading: strings.inquiry,
                        background: context.resources.color.colorWhite,
                        children: [
                          _Chip(
                            label: strings.freelancerPriceRequest,
                            value: cr.unitPrice ?? cr.totalPrice,
                          ),
                          if ((cr.message ?? '').toString().trim().isNotEmpty)
                            ...[
                            const SizedBox(height: 12),
                            EngagementSectionCard(
                              title: strings.messageFromFreelancer,
                              margin: EdgeInsets.zero,
                              child: _bodyText(context, cr.message!),
                            ),
                          ],
                          const SizedBox(height: 12),
                          const EngagementLocationCard(margin: EdgeInsets.zero),
                          const SizedBox(height: 12),
                          _DatesCard(
                            dates: [cr.startDatetime, cr.expiryDatetime],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Your original request ──────────────────────────────
                      _OuterCard(
                        heading: strings.yourRequest,
                        background:
                            context.resources.color.colorPrimaryLight,
                        children: [
                          _Chip(
                            label: strings.budget,
                            value: engagement.totalPrice ?? engagement.unitPrice,
                            background: context.resources.color.colorWhite,
                          ),
                          if ((engagement.description ?? '')
                              .toString()
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: 12),
                            EngagementSectionCard(
                              title: strings.brief,
                              margin: EdgeInsets.zero,
                              child:
                                  _bodyText(context, engagement.description!),
                            ),
                          ],
                          const SizedBox(height: 12),
                          const EngagementLocationCard(margin: EdgeInsets.zero),
                          const SizedBox(height: 12),
                          const EngagementDatesCard(margin: EdgeInsets.zero),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _BottomActions(controller: controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _bodyText(BuildContext context, String text) => PrimaryText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: context.resources.color.colorGrey,
      );
}

/// Titled outer card (white "Inquiry" or light-blue "Your request").
class _OuterCard extends StatelessWidget {
  const _OuterCard({
    required this.heading,
    required this.background,
    required this.children,
  });

  final String heading;
  final Color background;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: heading,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: context.resources.color.colorBlack,
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// Full-width price chip.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.value, this.background});

  final String label;
  final dynamic value;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? context.resources.color.colorPrimaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: PrimaryText(
        text: '$label: \$${value ?? '-'}',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        textColor: context.resources.color.colorPrimary,
      ),
    );
  }
}

/// Dates sub-card for an arbitrary date list (used for the change request).
class _DatesCard extends StatelessWidget {
  const _DatesCard({required this.dates});

  final List<DateTime?> dates;

  @override
  Widget build(BuildContext context) {
    final shown = dates
        .where((d) => d != null)
        .map((d) => DateFormat('dd MMMM yyyy').format(d!))
        .toList();
    if (shown.isEmpty) return const SizedBox.shrink();

    return EngagementSectionCard(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.calendar,
              width: 18, color: context.resources.color.colorPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: context.resources.strings.dates,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey,
                ),
                const SizedBox(height: 2),
                ...shown.map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: PrimaryText(
                      text: '•  $d',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: context.resources.color.colorBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Accept (green) + Inquiry (blue) + Decline (red link), per p217.
class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.controller});

  final EngagementDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final strings = Resources.of(context).strings;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => EngagementActionButton(
                    title: strings.accept,
                    color: HexColor('#6CC192'),
                    loading: controller.isAcceptingChangeRequest.value,
                    onTap: controller.acceptChangeRequest,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: EngagementActionButton(
                  title: strings.inquiry,
                  color: HexColor('#4DA8ED'),
                  onTap: () => Get.toNamed(RouteConstant.inquiryScreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isRejectingChangeRequest.value) {
              return const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.rejectChangeRequest,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: PrimaryText(
                  text: strings.decline,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: HexColor('#E45959'),
                  isUnderLined: true,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
