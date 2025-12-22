import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/ServicesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class ServiceCarouselItem extends StatelessWidget {
  const ServiceCarouselItem({
    super.key,
    required this.service,
    required this.onBookNow,
    this.isFocused = false,
  });

  final Service service;
  final VoidCallback onBookNow;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstant.serviceDetailsScreen, arguments: service);
      },
      child: Container(
        width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFocused ? HexColor("#E7F3EE") : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: HexColor("#AEC81A").withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                PrimaryText(
                  text: service.title ?? 'N/A',
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.center,

                  fontSize: 14,
                  maxLines: 2,
                ),

                SizedBox(height: 4),

                // Category
                PrimaryText(
                  text:
                      "${service.parentCategoryName != null ? '${service.parentCategoryName}/' : ''}${service.categoryName}",
                  textColor: context.resources.color.colorGrey8,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: 12,
                ),

                SizedBox(height: 10),

                PrimaryText(
                  text: '\$ ${service.unitPrice ?? '0'}',
                  textColor: context.resources.color.colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 1,
            color: context.resources.color.colorPrimary.withOpacity(.2),
          ),

          SizedBox(height: 8),

          // Book Now Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            height: 40,
            child: PrimaryButton(
                title: context.resources.strings.bookNow,
                onPressed: onBookNow,
              fontSize: 14,
            ),
          ),
        ],
        ),
      ),
    );
  }
}
