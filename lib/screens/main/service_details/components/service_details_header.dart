import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../components/progress_bar.dart';
import '../../../../utils/utils.dart';
import '../service_details_controller.dart';

class ServiceDetailsHeader extends StatelessWidget {
  const ServiceDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceDetailsController>();
    return SizedBox(
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
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      AppIcons.back,
                      width: 30,
                      color: context.resources.color.colorWhite,
                    ),
                  ),
                ),
                Spacer(),

                if (controller.service.value?.memberHashcode != Prefs.getId)
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isFavoriteLoading.value
                          ? null
                          : controller.toggleFavorite,
                      child: controller.isFavoriteLoading.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: ProgressBar(),
                            )
                          : Image.asset(
                              controller.isFavorite.value
                                  ? AppIcons.banomarkOn
                                  : AppIcons.banomark,
                              width: 20,
                              color: context.resources.color.colorWhite,
                            ),
                    ),
                  ),
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
                      url: controller.service.value?.image.toString() ?? '',
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
