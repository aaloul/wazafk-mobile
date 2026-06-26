import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/screens/main/job_details/job_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/primary_text.dart';
import '../../../../components/progress_bar.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/utils.dart';

class JobDetailsHeader extends StatelessWidget {
  const JobDetailsHeader({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();

    return Container(
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 16),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(AppIcons.back3, width: 38),
                  ),
                ),
                Spacer(),

                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.file,
                          width: 11,
                          color: context.resources.color.colorPrimary,
                        ),
                        SizedBox(width: 3),
                        PrimaryText(
                          text: job.nbApplicants.toString(),
                          textColor: context.resources.color.colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 6),

                if (job.memberHashcode != Prefs.getId)
                  Obx(() {
                    final isFavorite = controller.job.value?.isFavorite ?? false;
                    final isLoading = controller.isTogglingFavorite.value;

                    return GestureDetector(
                      onTap: isLoading ? null : () => controller.toggleFavorite(),
                      child: isLoading
                          ? SizedBox(width: 20, height: 20, child: ProgressBar())
                          : SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Image.asset(
                            isFavorite
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 18,
                            color: context.resources.color.colorPrimary,
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),


          SizedBox(height: 12),

          // Title
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryText(
              text: job.title ?? '',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: context.resources.color.colorBlack,
            ),
          ),

          // Category
          if (job.categoryName != null)
            SizedBox(height: 6),
          if (job.categoryName != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: job.parentCategoryName != null
                    ? "${job.parentCategoryName} / ${job.categoryName}"
                    : job.categoryName.toString(),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                textColor: context.resources.color.colorGrey,
              ),
            ),
          SizedBox(height: 8),

          Row(
            children: [
              Row(
                children: [
                  SizedBox(width: 16,),
                  Image.asset(
                    AppIcons.location,
                    width: 14,
                    color: context.resources.color.colorGrey26,
                  ),
                  SizedBox(width: 5),
                  PrimaryText(
                    text:
                    job.address?.city ??
                        context.resources.strings.notAvailable,
                    textColor: context.resources.color.colorGrey26,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ],
              ),

              Spacer(),

              Row(
                children: [
                  Image.asset(
                    AppIcons.calendar,
                    width: 18,
                    color: context.resources.color.colorGrey,
                  ),
                  SizedBox(width: 6),
                  PrimaryText(
                    text: DateFormat(
                      'dd-MM-yyyy hh:mm a',
                    ).format(job.startDatetime!),
                    textColor: context.resources.color.colorGrey29,
                    fontSize: 13,
                  ),
                ],
              ),

              SizedBox(width: 16,),

            ],
          ),
          SizedBox(height: 12),

        ],
      ),
    );
  }
}
