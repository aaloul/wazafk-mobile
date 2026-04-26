import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class HomeServiceItem extends StatefulWidget {
  const HomeServiceItem({
    super.key,
    required this.service,
    this.onFavoriteToggle,
  });

  final Service service;
  final Future<bool> Function(Service service)? onFavoriteToggle;

  @override
  State<HomeServiceItem> createState() => _HomeServiceItemState();
}

class _HomeServiceItemState extends State<HomeServiceItem> {
  var isLoading = false.obs;

  Future<void> toggleFavorite() async {
    if (widget.onFavoriteToggle == null || isLoading.value) return;

    setState(() {
      isLoading.value = true;
    });

    try {
      await widget.onFavoriteToggle!(widget.service);
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  void navigateToMemberProfile() {
    if (widget.service.hashcode == null) return;

    Get.toNamed(RouteConstant.serviceDetailsScreen, arguments: widget.service);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToMemberProfile,
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: EdgeInsets.only(bottom: 12),
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
              // Top row: title + bookmark (same as job)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: widget.service.title ?? 'N/A',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorGrey16,
                        ),
                        SizedBox(height: 4),
                        PrimaryText(
                          text: widget.service.description ?? 'N/A',
                          fontSize: 12,
                          maxLines: 2,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey26,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),
                  Obx(
                    () => GestureDetector(
                      onTap: toggleFavorite,
                      child: isLoading.value
                          ? SizedBox(width: 18, height: 18, child: ProgressBar())
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
                                  widget.service.isFavorite ?? false
                                      ? AppIcons.banomarkOn
                                      : AppIcons.banomark,
                                  width: 15,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Skills row
              if (widget.service.skills != null &&
                  widget.service.skills!.isNotEmpty)
                SizedBox(
                  height: 26,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.service.skills!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final skill = widget.service.skills![index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: PrimaryText(
                            text: skill.name ?? '',
                            textColor: context.resources.color.colorPrimary,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              Container(
                width: double.infinity,
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 12),
                color: context.resources.color.colorGrey20,
              ),

              // Bottom row: member avatar + name/rating + price (same as job)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.service.memberHashcode != null) {
                        Get.toNamed(
                          RouteConstant.freelancerMemberProfileScreen,
                          arguments: User(
                            hashcode: widget.service.memberHashcode,
                            image: widget.service.memberImage,
                            firstName: widget.service.memberFirstName,
                            lastName: widget.service.memberLastName,
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
                        url: widget.service.memberImage ?? '',
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
                                  '${widget.service.memberFirstName ?? ''} ${widget.service.memberLastName ?? ''}'
                                      .trim(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: 6),
                            Image.asset(AppIcons.star2, width: 12),
                            SizedBox(width: 2),
                            PrimaryText(
                              text: widget.service.memberRating ?? 'N/A',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        if (widget.service.createdAt != null)
                          SizedBox(height: 2,),
                        if (widget.service.createdAt != null)
                          PrimaryText(
                            text: 'Since ${DateFormat('dd/MM/yyyy').format(widget.service.createdAt!)}',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            textColor: context.resources.color.colorGrey29,
                          ),
                      ],
                    ),
                  ),
                  PrimaryText(
                    text: '\$${widget.service.pricingType.toString() == 'U' ? '${widget.service.unitPrice}/H' : widget.service.totalPrice}',
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
