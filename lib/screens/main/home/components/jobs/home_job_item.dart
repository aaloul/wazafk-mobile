import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../components/progress_bar.dart';
import '../../../../../model/JobsResponse.dart';

class HomeJobItem extends StatefulWidget {
  const HomeJobItem({super.key, required this.job, this.onFavoriteToggle});

  final Job job;
  final Future<bool> Function(Job job)? onFavoriteToggle;

  @override
  State<HomeJobItem> createState() => _HomeJobItemState();
}

class _HomeJobItemState extends State<HomeJobItem> {
  bool isTogglingFavorite = false;

  Future<void> toggleFavorite() async {
    if (widget.onFavoriteToggle == null) return;

    setState(() {
      isTogglingFavorite = true;
    });

    try {
      await widget.onFavoriteToggle!(widget.job);
    } finally {
      setState(() {
        isTogglingFavorite = false;
      });
    }
  }

  String getWorkLocationTypeFullName(
    BuildContext context,
    String? workLocationType,
  ) {
    switch (workLocationType) {
      case 'RMT':
        return context.resources.strings.remote;
      case 'HYB':
        return context.resources.strings.hybrid;
      case 'SIT':
        return context.resources.strings.onsite;
      default:
        return context.resources.strings.notAvailable;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.jobDetailsScreen, arguments: widget.job);
      },
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: widget.job.title.toString(),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey16,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Image.asset(
                              AppIcons.location,
                              width: 18,
                              color: context.resources.color.colorGrey29,
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: PrimaryText(
                                text: getWorkLocationTypeFullName(
                                  context,
                                  widget.job.workLocationType,
                                ),
                                textColor: context.resources.color.colorGrey26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: context.resources.color.colorGrey30,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppIcons.file,
                          width: 12,
                          color: context.resources.color.colorPrimary,
                        ),
                        SizedBox(width: 4),
                        PrimaryText(
                          text: widget.job.nbApplicants.toString(),
                          textColor: context.resources.color.colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),

                  if (widget.job.memberHashcode != Prefs.getId)
                    GestureDetector(
                      onTap: isTogglingFavorite ? null : () => toggleFavorite(),
                      child: isTogglingFavorite
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: ProgressBar(),
                            )
                          : Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.resources.color.colorGrey15,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  color: context.resources.color.colorPrimary,
                                  widget.job.isFavorite ?? false
                                      ? AppIcons.banomarkOn
                                      : AppIcons.banomark,
                                  width: 15,
                                ),
                              ),
                            ),
                    ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 26,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.job.skills!.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final skill = widget.job.skills![index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: context.resources.color.colorPrimaryLight,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: PrimaryText(
                                text: skill.name.toString(),
                                textColor: context.resources.color.colorPrimary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                width: double.infinity,
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 12),
                color: context.resources.color.colorGrey20
              ),


              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.job.memberHashcode != null) {
                        Get.toNamed(
                          RouteConstant.employerMemberProfileScreen,
                          arguments: User(
                            hashcode: widget.job.memberHashcode,
                            image: widget.job.memberImage,
                            firstName: widget.job.memberFirstName,
                            lastName: widget.job.memberLastName,
                            title: '',
                          ),
                        );
                      }
                    },
                    child: Container(
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
                          url: widget.job.memberImage.toString(),
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PrimaryText(
                              text:
                                  '${widget.job.memberFirstName}\n${widget.job.memberLastName}',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: 6),

                            Image.asset(AppIcons.star2, width: 12),
                            SizedBox(width: 2),
                            PrimaryText(
                              text: widget.job.rating.toString(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 2),

                        PrimaryText(
                          text: DateFormat(
                            "dd-MM-yyyy",
                          ).format(widget.job.startDatetime!),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey10,
                        ),
                      ],
                    ),
                  ),

                  PrimaryText(
                    text: "\$${widget.job.totalPrice}",
                    textColor: context.resources.color.colorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
