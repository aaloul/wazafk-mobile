import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class JobCarouselItem extends StatelessWidget {
  const JobCarouselItem(
      {super.key, required this.engagement, this.isFocused = false});

  final Engagement engagement;
  final bool isFocused;

  String _getCategoryText() {
    final job = engagement.job;
    if (job?.parentCategoryName != null) {
      return '${job!.parentCategoryName}/${job.categoryName}';
    }
    return job?.categoryName ?? 'Job';
  }

  @override
  Widget build(BuildContext context) {
    final job = engagement.job;

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
          // Job Title
          PrimaryText(
            text: job?.title ?? 'N/A',
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            maxLines: 1,
          ),

          SizedBox(height: 3),

          // Category
          PrimaryText(
            text: _getCategoryText(),
            textColor: context.resources.color.colorGrey8,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            maxLines: 1,
          ),

          SizedBox(height: 3),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppIcons.star2, width: 14),
              SizedBox(width: 2),
              PrimaryText(
                text: (job?.rating ?? 0).toString(),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorPrimary,
              ),
            ],
          ),

          SizedBox(height: 8),

          // Description
          Expanded(
            child: PrimaryText(
              text: job?.description
                  ?.toString()
                  .isEmpty ?? true
                  ? 'N/A'
                  : job?.description ?? 'N/A',
              textColor: context.resources.color.colorGrey8,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              maxLines: 2,
            ),
          ),


          Row(
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
                    url: engagement.clientImage ?? '',
                    width: 35,
                    height: 35,
                  ),
                ),
              ),

              SizedBox(width: 6),
              PrimaryText(
                text: '${engagement.clientFirstName ?? ''} ${engagement
                    .clientLastName ?? ''}',
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
            ],
          ),


        ],
      ),
    );
  }
}
