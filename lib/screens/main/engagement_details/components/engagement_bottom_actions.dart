import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../components/outlined_button.dart';
import '../../../../constants/route_constant.dart';
import '../../../../utils/Prefs.dart';
import 'dispute_bottom_sheet.dart';
import 'verify_face_match_bottom_sheet.dart';

/// The status-driven bottom action panel. The branching logic mirrors the
/// original single-screen implementation 1:1; the only design changes are the
/// "Inquiry" naming (was "Negotiate" + bottom sheet, now a full screen) and the
/// Message / Finalize / Need-Help layout on the active (in-progress) state.
class EngagementBottomActions extends StatelessWidget {
  const EngagementBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _PendingActions(),
        _ActiveActions(),
        _AcceptFinishActions(),
        _DisputeActions(),
        _RateActions(),
      ],
    );
  }
}

// ── status == 0 (pending) ─────────────────────────────────────────────────────
class _PendingActions extends StatelessWidget {
  const _PendingActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    return Obx(() {
      final engagement = controller.engagement.value;
      if (engagement?.status != 0) return const SizedBox.shrink();

      if (engagement?.pendingChangeRequest == 1) {
        final currentUserId = Prefs.getId;
        final changeRequests = engagement?.changeRequests;
        final isRequester = changeRequests != null &&
            changeRequests.isNotEmpty &&
            changeRequests.first.requesterHashcode == currentUserId;

        if (isRequester) {
          return _bottomPanel(
            context,
            _waitingPanel(
              context,
              title: context.resources.strings.waitingForReply,
              subtitle:
                  context.resources.strings.yourChangeRequestPendingApproval,
            ),
          );
        }
        return _bottomPanel(
          context,
          PrimaryButton(
            title: context.resources.strings.viewChanges,
            onPressed: () =>
                Get.toNamed(RouteConstant.inquiryReviewScreen),
          ),
        );
      }

      final currentUserId = Prefs.getId;
      final engagementType = engagement?.type;
      bool canAcceptReject = false;
      if (engagementType == 'JA') {
        canAcceptReject = currentUserId == engagement?.clientHashcode;
      } else if (engagementType == 'SB' || engagementType == 'PB') {
        canAcceptReject = currentUserId == engagement?.freelancerHashcode;
      }

      if (!canAcceptReject) {
        return _bottomPanel(
          context,
          _waitingPanel(
            context,
            title: context.resources.strings.waitingForReply,
            subtitle: context.resources.strings.yourTaskRequestPendingApproval,
          ),
        );
      }

      // Accept + Inquiry + Decline link for every type (jobs included), matching
      // the service flow (design p57 / p215 / p217).
      final showInquiry = engagementType != null;
      // Exact p57 / p213 button colours.
      final acceptGreen = HexColor('#6CC192');
      final inquiryBlue = HexColor('#4DA8ED');
      final declineRed = HexColor('#E45959');

      void onAccept() {
        controller.faceVerificationAction = 'accept_engagement';
        Get.bottomSheet(
          VerifyFaceMatchBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      }

      void onDecline() {
        controller.faceVerificationAction = 'reject_engagement';
        Get.bottomSheet(
          VerifyFaceMatchBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      }

      return _bottomPanel(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => EngagementActionButton(
                      title: Resources.of(context).strings.accept,
                      color: acceptGreen,
                      loading: controller.isAccepting.value,
                      onTap: onAccept,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (showInquiry)
                  Expanded(
                    child: EngagementActionButton(
                      title: Resources.of(context).strings.inquiry,
                      color: inquiryBlue,
                      onTap: () => Get.toNamed(RouteConstant.inquiryScreen),
                    ),
                  )
                else
                  Expanded(
                    child: Obx(
                      () => EngagementActionButton(
                        title: Resources.of(context).strings.decline,
                        color: declineRed,
                        loading: controller.isRejecting.value,
                        onTap: onDecline,
                      ),
                    ),
                  ),
              ],
            ),
            if (showInquiry) ...[
              const SizedBox(height: 12),
              Obx(() {
                if (controller.isRejecting.value) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDecline,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PrimaryText(
                      text: Resources.of(context).strings.decline,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: declineRed,
                      isUnderLined: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      );
    });
  }
}

// ── status == 1 (active / in-progress) ────────────────────────────────────────
class _ActiveActions extends StatelessWidget {
  const _ActiveActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    return Obx(() {
      final engagement = controller.engagement.value;
      if (engagement?.status != 1) return const SizedBox.shrink();

      final isFreelancer =
          Prefs.getId == engagement?.freelancerHashcode.toString();
      final noDispute = engagement?.hasDispute.toString() == '0';

      return _bottomPanel(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EngagementMessageButton(),
            if (isFreelancer && noDispute) ...[
              const SizedBox(height: 12),
              PrimaryOutlinedButton(
                title: Resources.of(context).strings.finalizeJob,
                height: 44,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  controller.faceVerificationAction = 'open_finish_sheet';
                  Get.bottomSheet(
                    VerifyFaceMatchBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.bottomSheet(
                  DisputeBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              child: PrimaryText(
                text: Resources.of(context).strings.submitDispute,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorRed2,
                isUnderLined: true,
              ),
            ),
            const SizedBox(height: 10),
            const EngagementNeedHelpLink(),
          ],
        ),
      );
    });
  }
}

// ── status == 4 (finish submitted, client decides) ────────────────────────────
class _AcceptFinishActions extends StatelessWidget {
  const _AcceptFinishActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    return Obx(() {
      final engagement = controller.engagement.value;
      if (engagement?.status != 4 ||
          Prefs.getId != engagement?.clientHashcode.toString()) {
        return const SizedBox.shrink();
      }
      return _bottomPanel(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              if (controller.isAcceptingFinishEngagement.value) {
                return _loadingButton(context,
                    color: context.resources.color.colorPrimary);
              }
              return PrimaryButton(
                title: Resources.of(context).strings.acceptFinish,
                onPressed: () {
                  controller.faceVerificationAction = 'accept_finish';
                  Get.bottomSheet(
                    VerifyFaceMatchBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              );
            }),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isRejectingFinishEngagement.value) {
                return _loadingButton(context,
                    color: context.resources.color.colorRed);
              }
              return PrimaryOutlinedButton(
                title: Resources.of(context).strings.rejectFinish,
                onPressed: controller.rejectFinishEngagement,
              );
            }),
          ],
        ),
      );
    });
  }
}

// ── status == -3 (dispute pending) ────────────────────────────────────────────
class _DisputeActions extends StatelessWidget {
  const _DisputeActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    return Obx(() {
      final engagement = controller.engagement.value;
      if (engagement?.status != -3) return const SizedBox.shrink();
      return _bottomPanel(
        context,
        PrimaryButton(
          title: Resources.of(context).strings.submitDispute,
          onPressed: () {
            Get.bottomSheet(
              DisputeBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
        ),
      );
    });
  }
}

// ── status == 10 (completed, can rate) ────────────────────────────────────────
class _RateActions extends StatelessWidget {
  const _RateActions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    return Obx(() {
      final engagement = controller.engagement.value;
      if (engagement?.status != 10 ||
          (engagement?.isMemberRated == true &&
              engagement?.isSubjectRated == true) ||
          !controller.shouldRateItem) {
        return const SizedBox.shrink();
      }
      final amber = HexColor('#FFB118');
      final title = controller.targetUserType == 'F'
          ? Resources.of(context).strings.rateFreelancer
          : Resources.of(context).strings.rateClient;
      return _bottomPanel(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(RouteConstant.rateEngagementScreen,
                  arguments: engagement),
              child: Container(
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFECECEC), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppIcons.star, width: 22, color: amber),
                    const SizedBox(width: 10),
                    PrimaryText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      textColor: amber,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const EngagementNeedHelpLink(),
          ],
        ),
      );
    });
  }
}

/// "Message {other party name}" primary button → opens the conversation.
class EngagementMessageButton extends StatelessWidget {
  const EngagementMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;
    final isClient = engagement.clientHashcode.toString() == Prefs.getId;
    final otherHash =
        isClient ? engagement.freelancerHashcode : engagement.clientHashcode;
    final otherName = (isClient
            ? '${engagement.freelancerFirstName ?? ''} ${engagement.freelancerLastName ?? ''}'
            : '${engagement.clientFirstName ?? ''} ${engagement.clientLastName ?? ''}')
        .trim();

    return PrimaryButton(
      title: '${context.resources.strings.message} $otherName'.trim(),
      height: 44,
      borderRadius: 12,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      leadingIcon:
          Image.asset(AppIcons.message, width: 18, color: Colors.white),
      onPressed: () {
        if (otherHash == null || otherHash.isEmpty) return;
        Get.toNamed(
          RouteConstant.conversationMessagesScreen,
          arguments: {
            'member_hashcode': otherHash,
            'member_name': otherName.isNotEmpty
                ? otherName
                : context.resources.strings.message,
          },
        );
      },
    );
  }
}

/// "Need Help? … contact support" link → opens support chat.
class EngagementNeedHelpLink extends StatelessWidget {
  const EngagementNeedHelpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed(RouteConstant.helpCenterScreen),
      child: PrimaryText(
        text: context.resources.strings.needHelpContactSupport,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.center,
        textColor: context.resources.color.colorPrimary,
        isUnderLined: true,
      ),
    );
  }
}

/// Accept / Inquiry / Decline action button matching the design (tall, rounded
/// 14px, bold 18px white label, solid fill). Shows a spinner while [loading].
class EngagementActionButton extends StatelessWidget {
  const EngagementActionButton({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.loading = false,
  });

  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : PrimaryText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

Widget _bottomPanel(BuildContext context, Widget child) {
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
    child: child,
  );
}

Widget _loadingButton(BuildContext context, {required Color color}) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: context.resources.color.colorWhite,
          strokeWidth: 2,
        ),
      ),
    ),
  );
}

Widget _waitingPanel(BuildContext context,
    {required String title, required String subtitle}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.resources.color.colorPrimaryLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Image.asset(AppIcons.clock,
            width: 24, height: 24, color: context.resources.color.colorPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorGrey,
              ),
              const SizedBox(height: 4),
              PrimaryText(
                text: subtitle,
                fontSize: 14,
                textColor: context.resources.color.colorGrey7,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
