import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'employer_rate_member_controller.dart';

/// Employer rating a freelancer — design p219 "Rate Freelancer". Shares the
/// visual language of [RateEngagementScreen]: circle back + centered title,
/// hero illustration, member card, "Your Opinion Matters!" rating card.
class EmployerRateMemberScreen extends StatelessWidget {
  const EmployerRateMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployerRateMemberController());
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingCriteria.value) {
            return Center(child: ProgressBar(color: colors.colorPrimary));
          }

          if (controller.criteria.isEmpty) {
            return Center(
              child: PrimaryText(
                text: strings.noRatingCriteriaAvailable,
                fontSize: 14,
                textColor: colors.colorGrey,
              ),
            );
          }

          return Column(
            children: [
              _Header(title: strings.rateFreelancer),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const _HeroIllustration(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _MemberCard(controller: controller),
                            const SizedBox(height: 12),
                            _RatingCard(controller: controller),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _SubmitBar(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.colorGrey25, width: 1),
                ),
                child: Image.asset(AppIcons.back3, width: 22),
              ),
            ),
          ),
          PrimaryText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      width: double.infinity,
      color: colors.colorWhite,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Image.asset(
        AppIcons.rateFreelancerIllustration,
        height: 190,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(height: 190),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.controller});

  final EmployerRateMemberController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final name = controller.memberName.value.trim();
    final image = controller.memberImage.value;
    final rating = controller.memberProfile.value?.member?.rating;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: 36,
              height: 36,
              child: image.isNotEmpty
                  ? PrimaryNetworkImage(
                      url: image, width: 36, height: 36, fit: BoxFit.cover)
                  : Image.asset(AppIcons.placeholder, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          PrimaryText(
            text: name.isEmpty ? '-' : name,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          if (rating != null && rating.isNotEmpty) ...[
            const SizedBox(width: 10),
            Image.asset(AppIcons.star,
                width: 14, height: 14, color: const Color(0xFFFFB800)),
            const SizedBox(width: 4),
            PrimaryText(
              text: rating,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.colorBlack,
            ),
          ],
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.controller});

  final EmployerRateMemberController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(14),
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
          const SizedBox(height: 16),
          PrimaryText(
            text: strings.profileReview,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 4),
          Obx(
            () => Column(
              children: controller.criteria.map((c) {
                return _CriterionRow(
                  label: c.name ?? '',
                  rating: controller.getCriterionRating(c.hashcode ?? ''),
                  onRatingUpdate: (r) =>
                      controller.updateCriterionRating(c.hashcode ?? '', r),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryText(
            text: strings.yourReview,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const SizedBox(height: 8),
          MultilineLabeledTextField(
            controller: controller.commentController,
            hint: strings.addYourFeedback,
            maxLines: 20,
            height: 110,
            inputType: TextInputType.text,
            isPassword: false,
            isMandatory: true,
            label: '',
          ),
        ],
      ),
    );
  }
}

class _CriterionRow extends StatelessWidget {
  const _CriterionRow({
    required this.label,
    required this.rating,
    required this.onRatingUpdate,
  });

  final String label;
  final double rating;
  final ValueChanged<double> onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final hasRating = rating > 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.colorGrey2.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: colors.colorGrey,
            ),
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 18.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
            unratedColor: colors.colorGrey2,
            itemBuilder: (context, index) => Image.asset(
              AppIcons.star,
              color: const Color(0xFFFFB800),
            ),
            onRatingUpdate: onRatingUpdate,
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 28,
            child: PrimaryText(
              text: hasRating ? '/${_format(rating)}' : '/-',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: colors.colorGrey,
            ),
          ),
        ],
      ),
    );
  }

  String _format(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1).replaceAll('.', ',');
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.controller});

  final EmployerRateMemberController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isSubmitting.value) {
          return Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.colorPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: colors.colorWhite,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }
        return PrimaryButton(
          title: strings.submitRating,
          onPressed: controller.submitRating,
        );
      }),
    );
  }
}
