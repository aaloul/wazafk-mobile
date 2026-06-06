import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'give_feedback_controller.dart';

class GiveFeedbackScreen extends StatelessWidget {
  const GiveFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiveFeedbackController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.giveUsFeedback),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                decoration: BoxDecoration(
                  color: colors.colorWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: PrimaryText(
                        text: strings.yourOpinionMatters,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: colors.colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryText(
                      text: strings.rating,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack,
                    ),
                    const SizedBox(height: 6),
                    RatingBar.builder(
                      initialRating: controller.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 26,
                      itemPadding:
                          const EdgeInsets.symmetric(horizontal: 2),
                      unratedColor: colors.colorGrey4,
                      itemBuilder: (_, __) => Image.asset(
                        AppIcons.star,
                        color: const Color(0xFFFFB800),
                      ),
                      onRatingUpdate: (r) => controller.rating.value = r,
                    ),
                    const SizedBox(height: 16),
                    PrimaryText(
                      text: strings.review,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 130,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.colorWhite,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: colors.colorGrey4, width: 1),
                      ),
                      child: TextField(
                        controller: controller.feedbackController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.colorBlack,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: strings.addYourFeedback,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: colors.colorGrey,
                          ),
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Obx(() => controller.isLoading.value
                  ? const ProgressBar()
                  : PrimaryButton(
                      title: strings.submitFeedback,
                      onPressed: controller.submitFeedback,
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
