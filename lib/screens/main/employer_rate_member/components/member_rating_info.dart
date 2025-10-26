import 'package:flutter/material.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_text.dart';

class MemberRatingInfo extends StatelessWidget {
  const MemberRatingInfo({super.key, required this.memberProfile});

  final MemberProfile memberProfile;

  @override
  Widget build(BuildContext context) {
    final ratings = memberProfile.clientRatings;
    if (ratings == null || ratings.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...ratings.map((rating) {
            final ratingValue = double.tryParse(rating.rating ?? '0') ?? 0.0;
            final percentage = (ratingValue / 5.0).clamp(0.0, 1.0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                PrimaryText(
                  text: rating.name ?? 'N/A',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: context.resources.color.colorGrey,
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: context.resources.color.colorGrey9,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.resources.color.colorPrimary,
                    ),
                    minHeight: 8,
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }
}
