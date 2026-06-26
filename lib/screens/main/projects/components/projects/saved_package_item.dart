import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/model/PackagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

/// Package card styled like [HomeServiceItem] so the Saved tab is visually
/// consistent (white card + chips + footer), instead of the green home card.
class SavedPackageItem extends StatefulWidget {
  const SavedPackageItem({
    super.key,
    required this.package,
    this.onFavoriteToggle,
  });

  final Package package;
  final Future<bool> Function(Package package)? onFavoriteToggle;

  @override
  State<SavedPackageItem> createState() => _SavedPackageItemState();
}

class _SavedPackageItemState extends State<SavedPackageItem> {
  var isLoading = false.obs;

  Future<void> toggleFavorite() async {
    if (widget.onFavoriteToggle == null || isLoading.value) return;
    setState(() => isLoading.value = true);
    try {
      await widget.onFavoriteToggle!(widget.package);
    } finally {
      if (mounted) setState(() => isLoading.value = false);
    }
  }

  void navigateToDetails() {
    if (widget.package.hashcode == null) return;
    Get.toNamed(RouteConstant.packageDetailsScreen, arguments: widget.package);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final services = widget.package.services ?? [];
    return GestureDetector(
      onTap: navigateToDetails,
      child: Card(
        color: colors.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.colorGrey15, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + description + bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: widget.package.title ?? 'N/A',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: colors.colorGrey16,
                        ),
                        const SizedBox(height: 4),
                        PrimaryText(
                          text: widget.package.description ?? 'N/A',
                          fontSize: 12,
                          maxLines: 2,
                          fontWeight: FontWeight.w400,
                          textColor: colors.colorGrey26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Obx(
                    () => GestureDetector(
                      onTap: toggleFavorite,
                      child: isLoading.value
                          ? const SizedBox(
                              width: 18, height: 18, child: ProgressBar())
                          : Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: colors.colorGrey15, width: 1),
                              ),
                              child: Center(
                                child: Image.asset(
                                  color: colors.colorPrimary,
                                  widget.package.isFavorite ?? false
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

              // Services chips (package contents)
              if (services.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 26,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: PrimaryText(
                            text: services[index].title ?? '',
                            textColor: colors.colorPrimary,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              Container(
                width: double.infinity,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 12),
                color: colors.colorGrey20,
              ),

              // Footer: avatar + name/rating + price
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.package.memberHashcode != null) {
                        Get.toNamed(
                          RouteConstant.freelancerMemberProfileScreen,
                          arguments: User(
                            hashcode: widget.package.memberHashcode,
                            image: widget.package.memberImage,
                            firstName: widget.package.memberFirstName,
                            lastName: widget.package.memberLastName,
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
                        border:
                            Border.all(color: colors.colorPrimary, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: PrimaryNetworkImage(
                          url: widget.package.memberImage ?? '',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PrimaryText(
                              text:
                                  '${widget.package.memberFirstName ?? ''} ${widget.package.memberLastName ?? ''}'
                                      .trim(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 6),
                            Image.asset(AppIcons.star2, width: 12),
                            const SizedBox(width: 2),
                            PrimaryText(
                              text: widget.package.memberRating ?? 'N/A',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        if (widget.package.createdAt != null) ...[
                          const SizedBox(height: 2),
                          PrimaryText(
                            text:
                                'Since ${DateFormat('dd/MM/yyyy').format(widget.package.createdAt!)}',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            textColor: colors.colorGrey29,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PrimaryText(
                    text: '\$${widget.package.totalPrice}',
                    textColor: colors.colorPrimary,
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
