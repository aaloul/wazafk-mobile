import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class ServiceCarouselItem extends StatelessWidget {
  const ServiceCarouselItem({
    super.key,
    required this.service,
    required this.onBookNow,
    this.isFocused = false,
    this.showShadow = false,
  });

  final Service service;
  final VoidCallback onBookNow;
  final bool isFocused;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.serviceDetailsScreen, arguments: service);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: showShadow ? Colors.white : (isFocused ? HexColor("#E7F3EE") : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: showShadow
              ? null
              : Border.all(
                  color: HexColor("#AEC81A").withOpacity(0.7),
                  width: 1,
                ),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppIcons.bag, width: 44),
            Container(
              width: 1,
              height: 50,
              color: context.resources.color.colorGrey29,
              margin: EdgeInsets.symmetric(horizontal: 8),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryText(
                    text: service.title ?? 'N/A',
                    textColor: context.resources.color.colorBlack4,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4),
                  PrimaryText(
                    text: "${service.parentCategoryName != null ? '${service.parentCategoryName}/' : ''}${service.categoryName}",
                    textColor: context.resources.color.colorGrey26,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    fontSize: 11,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PrimaryText(
                  text: '\$ ${service.pricingType.toString() == 'U' ? '${service.unitPrice}/H' : service.totalPrice}',
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                SizedBox(height: 8),
                Image.asset(AppIcons.arrowGo, width: 30, fit: BoxFit.contain),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
