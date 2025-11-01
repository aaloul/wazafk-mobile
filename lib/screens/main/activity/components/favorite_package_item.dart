import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class FavoritePackageItem extends StatefulWidget {
  const FavoritePackageItem({
    super.key,
    required this.package,
    this.onFavoriteToggle,
  });

  final Package package;
  final Future<bool> Function(Package package)? onFavoriteToggle;

  @override
  State<FavoritePackageItem> createState() => _FavoritePackageItemState();
}

class _FavoritePackageItemState extends State<FavoritePackageItem> {
  var isLoading = false.obs;

  Future<void> toggleFavorite() async {
    if (widget.onFavoriteToggle == null || isLoading.value) return;

    setState(() {
      isLoading.value = true;
    });

    try {
      await widget.onFavoriteToggle!(widget.package);
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  void navigateToPackage() {
    if (widget.package.hashcode == null) return;

    Get.toNamed(RouteConstant.packageDetailsScreen, arguments: widget.package);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToPackage,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorGreen5,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGreen5,
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
                        text: widget.package.title ?? 'N/A',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        textColor: context.resources.color.colorBlue3,
                      ),

                      PrimaryText(
                        text: widget.package.description ?? 'N/A',
                        fontSize: 12,
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.resources.color.colorPrimary,
                              ),
                            ),
                          )
                        : Image.asset(
                            widget.package.isFavorite ?? false
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
                      url: widget.package.memberImage ?? '',
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
                            '${widget.package.memberFirstName ?? ''} ${widget.package.memberLastName ?? ''}'
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
                            text:
                                widget.package.memberRating.toString() ?? 'N/A',
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
            if ((widget.package.services != null &&
                widget.package.services!.isNotEmpty)) ...[
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 1,
                color: context.resources.color.colorGrey18,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: PrimaryText(
                      text: 'Services',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorBlack,
                    ),
                  ),
                  PrimaryText(
                    text: '\$${widget.package.totalPrice}',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    textColor: context.resources.color.colorBlue3,
                  ),
                ],
              ),

              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Services
                  if (widget.package.services != null)
                    ...widget.package.services!.map(
                      (service) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorWhite,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: context.resources.color.colorWhite,
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
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
