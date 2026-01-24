import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_switch.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../../../../components/progress_bar.dart';

class ItemMyJob extends StatefulWidget {
  const ItemMyJob({super.key, required this.job, required this.onToggleStatus});

  final Job job;
  final Future<void> Function() onToggleStatus;

  @override
  State<ItemMyJob> createState() => _ItemMyJobState();
}

class _ItemMyJobState extends State<ItemMyJob> {
  bool isTogglingStatus = false;

  Future<void> handleToggleStatus() async {
    setState(() {
      isTogglingStatus = true;
    });

    try {
      await widget.onToggleStatus();
    } finally {
      if (mounted) {
        setState(() {
          isTogglingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.jobDetailsScreen, arguments: {
          'job': widget.job,
          'isFromMyJobs': true,
        });
      },
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HexColor("#D5ECEF"),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor("#00AEC81A"), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: "${widget.job.title}",
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
                PrimaryText(
                  text: "${widget.job.categoryName}",
                  textColor: context.resources.color.colorGrey8,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          PrimaryText(
            text: "\$ ${widget.job.totalPrice ?? '0'}",
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),

          isTogglingStatus
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: ProgressBar(),
                    ),
                  ),
                )
              : Obx(
                  () => PrimarySwitch(
                    scale: .7,
                    checked: widget.job.checked.value,
                    thumbColorActive: context.resources.color.colorWhite,
                    thumbColorNotActive: context.resources.color.colorWhite,
                    trackColor: context.resources.color.colorGrey8,
                    activeTrackColor: context.resources.color.colorPrimary,
                    activeColor: context.resources.color.colorPrimary,
                    onChange: (value) {
                      handleToggleStatus();
                    },
                  ),
                ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteConstant.addJobScreen, arguments: widget.job);
            },
            child: Image.asset(
              AppIcons.edit,
              width: 20,
              color: context.resources.color.colorPrimary,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
