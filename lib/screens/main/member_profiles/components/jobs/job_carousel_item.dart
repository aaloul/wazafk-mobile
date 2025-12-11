import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../utils/res/AppIcons.dart';

class JobCarouselItem extends StatelessWidget {
  const JobCarouselItem(
      {super.key, required this.engagement, this.isFocused = false});

  final Engagement engagement;
  final bool isFocused;

  void _navigateToDetails() {
    final entityType = engagement.type?.toUpperCase();

    if (entityType == 'JA' && engagement.job != null) {
      Get.toNamed(
        RouteConstant.jobDetailsScreen,
        arguments: engagement.job,
      );
    } else if (entityType == 'SB' && engagement.services != null &&
        engagement.services!.isNotEmpty) {
      Get.toNamed(
        RouteConstant.serviceDetailsScreen,
        arguments: engagement.services!.first,
      );
    } else if (entityType == 'PB' && engagement.package != null) {
      Get.toNamed(
        RouteConstant.packageDetailsScreen,
        arguments: engagement.package,
      );
    }
  }

  String _getTitle() {
    final entityType = engagement.type?.toUpperCase();

    if (entityType == 'JA') {
      return engagement.job?.title ?? 'N/A';
    } else if (entityType == 'SB' && engagement.services != null &&
        engagement.services!.isNotEmpty) {
      return engagement.services!.first.title ?? 'N/A';
    } else if (entityType == 'PB') {
      return engagement.package?.title ?? 'N/A';
    }

    return 'N/A';
  }

  String _getCategoryText() {
    final entityType = engagement.type?.toUpperCase();

    if (entityType == 'JA') {
      final job = engagement.job;
      if (job?.parentCategoryName != null) {
        return '${job!.parentCategoryName}/${job.categoryName}';
      }
      return job?.categoryName ?? 'Job';
    } else if (entityType == 'SB' && engagement.services != null &&
        engagement.services!.isNotEmpty) {
      final service = engagement.services!.first;
      if (service.parentCategoryName != null) {
        return '${service.parentCategoryName}/${service.categoryName}';
      }
      return service.categoryName ?? 'Service';
    } else if (entityType == 'PB') {
      final package = engagement.package;
      return '';
      // if (package?.parentCategoryName != null) {
      //   return '${package!.parentCategoryName}/${package.categoryName}';
      // }
      // return package?.categoryName ?? 'Package';
    }

    return 'N/A';
  }

  String _getRating() {
    final entityType = engagement.type?.toUpperCase();

    if (entityType == 'JA') {
      return engagement.job?.rating ?? "0";
    } else if (entityType == 'SB' && engagement.services != null &&
        engagement.services!.isNotEmpty) {
      return engagement.services!.first.memberRating ?? "0";
    } else if (entityType == 'PB') {
      return engagement.package?.memberRating?.toString() ?? "0";
    }

    return "0";
  }

  String _getDescription() {
    final entityType = engagement.type?.toUpperCase();

    if (entityType == 'JA') {
      return engagement.job?.description ?? 'N/A';
    } else if (entityType == 'SB' && engagement.services != null &&
        engagement.services!.isNotEmpty) {
      return engagement.services!.first.description ?? 'N/A';
    } else if (entityType == 'PB') {
      return engagement.package?.description ?? 'N/A';
    }

    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToDetails,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: context.resources.color.colorGrey4, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title (Job/Service/Package)
            PrimaryText(
              text: _getTitle(),
              textColor: context.resources.color.colorPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              maxLines: 1,
            ),

            SizedBox(height: 3),

            // Category
            PrimaryText(
              text: _getCategoryText(),
              textColor: context.resources.color.colorGrey8,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              maxLines: 1,
            ),

            SizedBox(height: 3),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppIcons.star2, width: 14),
                SizedBox(width: 2),
                PrimaryText(
                  text: _getRating().toString(),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorPrimary,
                ),
              ],
            ),

            SizedBox(height: 8),

            // Description
            Expanded(
              child: PrimaryText(
                text: _getDescription().isEmpty ? 'N/A' : _getDescription(),
                textColor: context.resources.color.colorGrey8,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                maxLines: 2,
              ),
            ),

            Row(
              children: [
                Container(
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
                      url: engagement.clientImage ?? '',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),

                SizedBox(width: 6),
                PrimaryText(
                  text: '${engagement.clientFirstName ?? ''} ${engagement
                      .clientLastName ?? ''}',
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
