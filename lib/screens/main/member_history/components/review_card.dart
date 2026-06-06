import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/MemberReviewsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final MemberReview review;

  String get _name {
    final f = review.memberFirstName ?? '';
    final l = review.memberLastName ?? '';
    final v = '$f $l'.trim();
    return v.isEmpty ? '-' : v;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final dateStr = review.createdAt != null
        ? DateFormat('dd/MM/yyyy').format(review.createdAt!)
        : '';
    final ratingStr = (review.rating ?? 0).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryText(
                  text: strings.review,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: colors.colorBlack,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.colorGrey4,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppIcons.star,
                      width: 12,
                      color: const Color(0xFFFFB800),
                    ),
                    const SizedBox(width: 4),
                    PrimaryText(
                      text: ratingStr,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: colors.colorBlack,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          PrimaryText(
            text: review.comment ?? '',
            fontSize: 12,
            textColor: colors.colorGrey,
            height: 1.4,
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: colors.colorGrey4,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppIcons.placeholder,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              PrimaryText(
                text: _name,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textColor: colors.colorBlack,
              ),
              const SizedBox(width: 6),
              Image.asset(
                AppIcons.star,
                width: 12,
                color: const Color(0xFFFFB800),
              ),
              const SizedBox(width: 3),
              PrimaryText(
                text: ratingStr,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textColor: colors.colorBlack,
              ),
              const Spacer(),
              Image.asset(
                AppIcons.calendar,
                width: 14,
                color: colors.colorGrey,
              ),
              const SizedBox(width: 4),
              PrimaryText(
                text: dateStr,
                fontSize: 12,
                textColor: colors.colorGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
