import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../model/JobsResponse.dart';

class HomeJobItem extends StatefulWidget {
  const HomeJobItem({
    super.key,
    required this.job,
    this.onFavoriteToggle,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.jobDetailsScreen, arguments: widget.job);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGrey15,
            width: 2,
          ),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.job.memberHashcode != null) {
                    Get.toNamed(
                      RouteConstant.employerRateMemberScreen,
                      arguments: {
                        'memberHashcode': widget.job.memberHashcode,
                        'memberImage': widget.job.memberImage,
                        'memberName': '${widget.job.memberFirstName} ${widget
                            .job.memberLastName}',
                      },
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: PrimaryNetworkImage(
                    url: widget.job.memberImage.toString(),
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: '${widget.job.memberFirstName} ${widget.job
                          .memberLastName}',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AppIcons.star2, width: 16),
                        SizedBox(width: 2),
                        PrimaryText(
                          text: widget.job.rating.toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if(widget.job.memberHashcode != Prefs.getId)
              GestureDetector(
                onTap: isTogglingFavorite ? null : () => toggleFavorite(),
                child: isTogglingFavorite
                    ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.resources.color.colorPrimary,
                    ),
                  ),
                )
                    : Image.asset(
                  widget.job.isFavorite ?? false
                      ? AppIcons.banomarkOn
                      : AppIcons.banomark,
                  width: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          PrimaryText(
            text: widget.job.title.toString(),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: context.resources.color.colorGrey16,
          ),
          SizedBox(height: 4),
          PrimaryText(
            text: DateFormat("dd-MM-yyyy").format(widget.job.startDatetime!),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey16,
          ),

          SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 26,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.job.skills!.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final skill = widget.job.skills![index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: PrimaryText(
                            text: skill.name.toString(),
                            textColor: context.resources.color.colorWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Image.asset(AppIcons.userCircle, width: 24),
              SizedBox(width: 2),
              PrimaryText(text: "${widget.job.nbApplicants} applications"),
            ],
          ),

          Container(
            width: double.infinity,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 12),
            color: context.resources.color.colorPrimary.withOpacity(.25),
          ),

          Row(
            children: [
              Image.asset(AppIcons.location, width: 18),
              SizedBox(width: 8),
              Expanded(child: PrimaryText(
                  text: widget.job.workLocationType ?? "N/A")),

              PrimaryText(
                text: "\$${widget.job.totalPrice}",
                textColor: context.resources.color.colorGreen3,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
