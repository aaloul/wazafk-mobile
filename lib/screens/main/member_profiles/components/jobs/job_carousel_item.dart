import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class JobCarouselItem extends StatelessWidget {
  const JobCarouselItem({super.key, required this.job, this.isFocused = false});

  final Job job;
  final bool isFocused;

  String _getCategoryText() {
    if (job.parentCategoryName != null) {
      return '${job.parentCategoryName}/${job.categoryName}';
    }
    return job.categoryName ?? 'Job';
  }

  @override
  Widget build(BuildContext context) {
    final rating = double.tryParse(job.memberRating ?? '0') ?? 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.resources.color.colorGrey4, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title
                    PrimaryText(
                      text: job.title ?? 'N/A',
                      textColor: context.resources.color.colorPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      maxLines: 2,
                    ),

                    SizedBox(height: 6),

                    // Category
                    PrimaryText(
                      text: _getCategoryText(),
                      textColor: context.resources.color.colorGrey8,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.resources.color.colorPrimary,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PrimaryNetworkImage(
                        url: job.memberImage ?? '',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),

                  SizedBox(height: 4),
                  PrimaryText(
                    text: '${job.memberFirstName} ${job.memberLastName}',
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppIcons.star2, width: 14),
              SizedBox(width: 2),
              PrimaryText(
                text: job.rating.toString(),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorPrimary,
              ),
            ],
          ),

          SizedBox(height: 12),

          // Description
          PrimaryText(
            text: job.description.toString().isEmpty
                ? 'N/A'
                : job.description ?? 'N/A',
            textColor: context.resources.color.colorGrey8,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
