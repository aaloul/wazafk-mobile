import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';
import '../../../../components/progress_bar.dart';

class FavoriteFreelancerItem extends StatefulWidget {
  const FavoriteFreelancerItem({
    super.key,
    required this.freelancer,
    this.onFavoriteToggle,
  });

  final User freelancer;
  final Future<bool> Function(User member)? onFavoriteToggle;

  @override
  State<FavoriteFreelancerItem> createState() => _FavoriteFreelancerItemState();
}

class _FavoriteFreelancerItemState extends State<FavoriteFreelancerItem> {
  var isLoading = false.obs;

  Future<void> toggleFavorite() async {
    if (widget.onFavoriteToggle == null || isLoading.value) return;

    setState(() {
      isLoading.value = true;
    });

    try {
      await widget.onFavoriteToggle!(widget.freelancer);
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  void navigateToMemberProfile() {
    if (widget.freelancer.hashcode == null) return;

    Get.toNamed(RouteConstant.freelancerMemberProfileScreen,
        arguments: widget.freelancer);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToMemberProfile,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorBlue2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorBlue2,
            width: 1,
          ),
        ),
        child: Row(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: PrimaryNetworkImage(
                url: widget.freelancer.image ?? '',
                width: 70,
                height: 70,
              ),
            ),


            Container(
              width: 1,
              height: 70,
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: context.resources.color.colorWhite.withOpacity(.3),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Freelancer Header
                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text:
                              '${widget.freelancer.firstName ?? ''} ${widget
                                  .freelancer.lastName ?? ''}'
                                  .trim(),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              textColor: context.resources.color.colorBlue3,
                            ),

                            PrimaryText(
                              text: widget.freelancer.title ?? 'N/A',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorBlue3,
                            ),
                          ],
                        ),
                      ),
                      // Bookmark Icon
                      Obx(
                            () =>
                            GestureDetector(
                              onTap: toggleFavorite,
                              child: isLoading.value
                                  ? SizedBox(
                            width: 18,
                            height: 18,
                                child: ProgressBar(
                                ),
                          )
                                  : Image.asset(
                                widget.freelancer.isFavorite == 1
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 18,
                          ),
                            ),
                      ),
                    ],
                  ),


                  // Services & Packages combined
                  if ((widget.freelancer.services != null &&
                      widget.freelancer.services!.isNotEmpty) ||
                      (widget.freelancer.packages != null &&
                          widget.freelancer.packages!.isNotEmpty)) ...[

                    SizedBox(height: 12),
                    PrimaryText(
                      text: 'Services & Packages',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorBlue3,
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        // Services
                        if (widget.freelancer.services != null)
                          ...widget.freelancer.services!.map(
                                (service) =>
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorGrey20,
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                      color: context.resources.color
                                          .colorGrey20,
                                      width: 1,
                                    ),
                                  ),
                                  child: PrimaryText(
                                    text: service.title ?? '',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: context.resources.color
                                        .colorGrey8,
                                    maxLines: 1,
                                  ),
                                ),
                          ),
                        // Packages
                        if (widget.freelancer.packages != null)
                          ...widget.freelancer.packages!.map(
                                (package) =>
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.resources.color.colorGrey20,
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: context.resources.color
                                          .colorGrey20,
                                      width: 1,
                                    ),
                                  ),
                                  child: PrimaryText(
                                    text: package.title ?? '',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: context.resources.color
                                        .colorGrey8,
                                    maxLines: 1,
                                  ),
                                ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
