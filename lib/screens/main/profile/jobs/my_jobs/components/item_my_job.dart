import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/JobsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

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
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: context.resources.color.colorGrey15,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child:Row(
              children: [
                Flexible(
                  child: PrimaryText(
                    text: "${widget.job.title}",
                    textColor: context.resources.color.colorBlack4,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                if (widget.job.rating != null) ...[
                  SizedBox(width: 6),
                  Image.asset(AppIcons.star2, width: 13),
                  SizedBox(width: 3),
                  PrimaryText(
                    text: widget.job.rating!,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorBlack4,
                  ),
                ],
                SizedBox(width: 4,),

              ],
          )
                        ),

                      ],
                    ),
                  ),
                  isTogglingStatus
                      ? SizedBox(
                          width: 90,
                          height: 28,
                          child: Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: ProgressBar(),
                            ),
                          ),
                        )
                      : Obx(() => _OnOffToggle(
                            isOn: widget.job.checked.value,
                            onTap: handleToggleStatus,
                          )),
                ],
              ),

              SizedBox(height: 4),

              PrimaryText(
                text: "${widget.job.parentCategoryName}",
                textColor: context.resources.color.colorGrey26,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),

              SizedBox(height: 2),

              PrimaryText(
                text: "${widget.job.categoryName}",
                textColor: context.resources.color.colorGrey29,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),

              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteConstant.addJobScreen, arguments: widget.job);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.edit,
                          width: 18,
                          color: context.resources.color.colorPrimary,
                        ),
                        SizedBox(width: 4),
                        PrimaryText(
                          text: context.resources.strings.edit,
                          textColor: context.resources.color.colorPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnOffToggle extends StatelessWidget {
  const _OnOffToggle({required this.isOn, required this.onTap});

  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.resources.color.colorPrimary;
    const unselectedBg = Color(0xFFFAFAFA);
    const unselectedText = Color(0xFFB3B3B3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: context.resources.color.colorGrey25,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isOn ? unselectedBg : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isOn ? null : Border.all(color: primary, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  'OFF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOn ? unselectedText : primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isOn ? Colors.white : unselectedBg,
                  borderRadius: BorderRadius.circular(12),
                  border: isOn ? Border.all(color: primary, width: 1) : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'ON',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOn ? primary : unselectedText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
