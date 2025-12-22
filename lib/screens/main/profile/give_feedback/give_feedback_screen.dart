import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/multiline_labeled_text_field.dart';
import '../../../../components/primary_text.dart';
import 'give_feedback_controller.dart';

class GiveFeedbackScreen extends StatelessWidget {
  const GiveFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiveFeedbackController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(
                hasBack: true, title: context.resources.strings.giveUsFeedback),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),

                      PrimaryText(
                        text: 'Your Opinion Matters!',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        textColor: context.resources.color.colorGrey,
                      ),
                      SizedBox(height: 8),
                      PrimaryText(
                        text: 'Rate Us and leave a feedback',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        textColor: context.resources.color.colorGrey3,
                      ),

                      SizedBox(height: 20),
                      PrimaryText(
                        text: 'Your Rating*',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        textColor: context.resources.color.colorGrey,
                      ),
                      SizedBox(height: 4),

                      RatingBar.builder(
                        initialRating: 3.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 32.0,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                        unratedColor: context.resources.color.colorGrey9,
                        itemBuilder: (context, index) => Image.asset(
                          AppIcons.star,
                          color: context.resources.color.colorPrimary,
                        ),
                        onRatingUpdate: (rating) {
                          controller.rating.value = rating;
                        },
                      ),
                      SizedBox(height: 8),
                      MultilineLabeledTextField(
                        controller: controller.feedbackController,
                        label: context.resources.strings.yourReview,
                        hint: context.resources.strings.addYourFeedback,
                        maxLines: 20,
                        height: 120,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Obx(
              () => controller.isLoading.value
                  ? ProgressBar()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: context.resources.strings.submitApplication,
                        onPressed: () {
                          controller.submitFeedback();
                        },
                      ),
                    ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
