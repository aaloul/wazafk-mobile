import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/screens/main/job_details/job_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../utils/utils.dart';

class JobDetailsHeader extends StatelessWidget {
  const JobDetailsHeader({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();

    return Container(
      width: double.infinity,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  AppIcons.jobCover,
                  fit: BoxFit.cover,
                  height: 160,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 16,
            left: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: RotatedBox(
                    quarterTurns: Utils().isRTL() ? 2 : 0,
                    child: Image.asset(
                      AppIcons.back,
                      width: 30,
                      color: context.resources.color.colorWhite,
                    ),
                  ),
                ),
                Spacer(),

                Obx(() {
                  final isFavorite = controller.job.value?.isFavorite ?? false;
                  final isLoading = controller.isTogglingFavorite.value;

                  return GestureDetector(
                    onTap: isLoading ? null : () => controller.toggleFavorite(),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.resources.color.colorWhite,
                              ),
                            ),
                          )
                        : Image.asset(
                            isFavorite
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 20,
                            color: context.resources.color.colorWhite,
                          ),
                  );
                }),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(14),
                    border: Border.all(
                      color: context.resources.color.background2,
                      width: 5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: PrimaryNetworkImage(
                      url: job.image.toString(),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
