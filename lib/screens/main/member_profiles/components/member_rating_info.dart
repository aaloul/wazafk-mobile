import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../components/primary_text.dart';

class MemberRatingInfo extends StatelessWidget {
  const MemberRatingInfo({
    super.key,
    required this.memberProfile,
    this.useFreelancerRatings = false,
  });

  final MemberProfile memberProfile;
  final bool useFreelancerRatings;

  @override
  Widget build(BuildContext context) {
    final ratings = useFreelancerRatings
        ? memberProfile.freelancerRatings
        : memberProfile.clientRatings;

    if (ratings == null || ratings.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.profileReview,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textColor: context.resources.color.colorBlack,
          ),
          SizedBox(height: 8),

          ...ratings.asMap().entries.map((entry) {
            final index = entry.key;
            final rating = entry.value;
            final ratingValue = double.tryParse(rating.rating ?? '0') ?? 0.0;

            return Column(
              children: [
                if (index != 0)
                  Divider(height: 1, thickness: 1, color: Color(0xFFE9E9E9)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryText(
                          text: rating.name ?? 'N/A',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey26,
                        ),
                      ),
                      RatingBarIndicator(
                        rating: ratingValue,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: HexColor('#FFB219'),
                        ),
                        unratedColor: context.resources.color.colorGrey9,
                        itemCount: 5,
                        itemSize: 18,
                      ),
                      SizedBox(width: 6),
                      PrimaryText(
                        text: '/${ratingValue.toStringAsFixed(1)}',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

        ],
      ),
    );
  }
}
