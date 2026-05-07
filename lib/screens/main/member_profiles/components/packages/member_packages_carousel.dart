import 'package:flutter/material.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/packages/package_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';

class MemberPackagesCarousel extends StatelessWidget {
  const MemberPackagesCarousel({
    super.key,
    required this.memberProfile,
    required this.onBookPackage,
  });

  final MemberProfile memberProfile;
  final Function onBookPackage;

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final packages = memberProfile.packages;
    if (packages == null || packages.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.workPackages,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: context.resources.color.colorBlack4,
          ),
          const SizedBox(height: 16),
          ...packages.map(
            (package) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PackageCarouselItem(
                package: package,
                showShadow: true,
                onBookNow: () => onBookPackage(package),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
