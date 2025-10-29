import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class HomeFreelancerItem extends StatefulWidget {
  const HomeFreelancerItem({
    super.key,
    required this.freelancer,
    this.onFavoriteToggle,
  });

  final User freelancer;
  final Future<bool> Function(User member)? onFavoriteToggle;

  @override
  State<HomeFreelancerItem> createState() => _HomeFreelancerItemState();
}

class _HomeFreelancerItemState extends State<HomeFreelancerItem> {
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

    Get.toNamed(
      RouteConstant.freelancerMemberProfileScreen,
      arguments: widget.freelancer,
    );
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
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGrey18,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Freelancer Header
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
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
                      url: widget.freelancer.image ?? '',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: PrimaryText(
                              text:
                                  '${widget.freelancer.firstName ?? ''} ${widget.freelancer.lastName ?? ''}'
                                      .trim(),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              textColor: context.resources.color.colorBlack,
                            ),
                          ),
                          // Rating beside name
                          if (widget.freelancer.rating != null) ...[
                            SizedBox(width: 2),
                            Icon(Icons.star, color: Colors.amber, size: 13),
                            PrimaryText(
                              text: widget.freelancer.rating!,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorBlack,
                            ),
                          ],
                        ],
                      ),
                      if (widget.freelancer.title != null &&
                          widget.freelancer.title!.isNotEmpty)
                        PrimaryText(
                          text: widget.freelancer.title!,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey19,
                        ),
                    ],
                  ),
                ),
                // Bookmark Icon
                Obx(
                  () => GestureDetector(
                    onTap: toggleFavorite,
                    child: isLoading.value
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
                            widget.freelancer.isFavorite == 1
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 18,
                          ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            PrimaryText(
              text: widget.freelancer.info.toString().isEmpty
                  ? 'N/A'
                  : widget.freelancer.info ?? 'N/A',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey19,
              maxLines: 2,
            ),

            // Services & Packages combined
            if ((widget.freelancer.services != null &&
                    widget.freelancer.services!.isNotEmpty) ||
                (widget.freelancer.packages != null &&
                    widget.freelancer.packages!.isNotEmpty)) ...[
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 1,
                color: context.resources.color.colorGrey18,
              ),
              SizedBox(height: 12),
              PrimaryText(
                text: 'Services & Packages',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorBlack,
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Services
                  if (widget.freelancer.services != null)
                    ...widget.freelancer.services!.map(
                      (service) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorGrey20,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: context.resources.color.colorGrey20,
                            width: 1,
                          ),
                        ),
                        child: PrimaryText(
                          text: service.title ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey8,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  // Packages
                  if (widget.freelancer.packages != null)
                    ...widget.freelancer.packages!.map(
                      (package) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorGrey20,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: context.resources.color.colorGrey20,
                            width: 1,
                          ),
                        ),
                        child: PrimaryText(
                          text: package.title ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey8,
                          maxLines: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
