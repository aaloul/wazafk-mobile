import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
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

  Widget _buildHorizontalGrid(BuildContext context) {
    // Get all skills
    final List<Widget> allItems = [];

    // Add skills
    if (widget.service.skills != null) {
      allItems.addAll(
        widget.service.skills!.map(
          (skill) => Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: context.resources.color.colorWhite,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: context.resources.color.colorWhite,
                width: 1,
              ),
            ),
            child: PrimaryText(
              text: skill.name ?? '',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey8,
              maxLines: 1,
            ),
          ),
        ),
      );
    }

    if (allItems.isEmpty) {
      return SizedBox.shrink();
    }

    // If 2 or fewer items, display in single row
    if (allItems.length <= 2) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: allItems
              .map((item) =>
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: item,
              ))
              .toList(),
        ),
      );
    }

    // Split items into 2 rows for more than 2 items
    final List<Widget> row1 = [];
    final List<Widget> row2 = [];

    for (int i = 0; i < allItems.length; i++) {
      if (i % 2 == 0) {
        row1.add(allItems[i]);
      } else {
        row2.add(allItems[i]);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (row1.isNotEmpty)
            Row(
              children: row1
                  .map((item) =>
                  Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 8),
                    child: item,
                  ))
                  .toList(),
            ),
          if (row2.isNotEmpty)
            Row(
              children: row2
                  .map((item) =>
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: item,
                  ))
                  .toList(),
            ),
        ],
      ),
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
          color: context.resources.color.colorBlue4,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorBlue4,
            width: 1,
          ),
        ),
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
                        text: widget.service.title ?? 'N/A',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        textColor: context.resources.color.colorBlue3,
                      ),

                      PrimaryText(
                        text: widget.service.description ?? 'N/A',
                        fontSize: 12,
                        maxLines: 2,
                        fontWeight: FontWeight.w400,
                        textColor: context.resources.color.colorGrey8,
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
                      child: ProgressBar(

                            ),
                          )
                        : Image.asset(
                            widget.service.isFavorite ?? false
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 18,
                          ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

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
                      url: widget.service.memberImage ?? '',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text:
                            '${widget.service.memberFirstName ?? ''} ${widget.service.memberLastName ?? ''}'
                                .trim(),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: context.resources.color.colorBlack,
                      ),

                      Row(
                        children: [
                          SizedBox(width: 2),
                          Icon(Icons.star, color: Colors.amber, size: 13),
                          PrimaryText(
                            text: widget.service.memberRating ?? 'N/A',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: context.resources.color.colorBlack,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bookmark Icon
              ],
            ),

            // Services & Packages combined
            if ((widget.service.skills != null &&
                widget.service.skills!.isNotEmpty)) ...[
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 1,
                color: context.resources.color.colorGrey.withOpacity(.3),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: PrimaryText(
                      text: 'Skills',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorBlack,
                    ),
                  ),
                  PrimaryText(
                    text: '\$${widget.service.unitPrice}/H',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    textColor: context.resources.color.colorBlue3,
                  ),
                ],
              ),

              SizedBox(height: 8),
              _buildHorizontalGrid(context),
            ],
          ],
        ),
      ),
    );
  }
}
