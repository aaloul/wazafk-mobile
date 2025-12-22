import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/packages/package_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';

class MemberPackagesCarousel extends StatefulWidget {
  const MemberPackagesCarousel({
    super.key,
    required this.memberProfile,
    required this.onBookPackage,
  });

  final MemberProfile memberProfile;
  final Function onBookPackage;

  @override
  State<MemberPackagesCarousel> createState() => _MemberPackagesCarouselState();
}

class _MemberPackagesCarouselState extends State<MemberPackagesCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Packages Carousel Section
        if (widget.memberProfile.packages != null &&
            widget.memberProfile.packages!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryText(
              text: context.resources.strings.workPackages,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              textColor: context.resources.color.colorGrey,
            ),
          ),
          SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              height: 178,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              viewportFraction: 0.60,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: widget.memberProfile.packages!.asMap().entries.map((entry) {
              final index = entry.key;
              final package = entry.value;
              return PackageCarouselItem(
                package: package,
                isFocused: index == _currentPage,
                onBookNow: () {
                  widget.onBookPackage(package);
                },
              );
            }).toList(),
          ),
          if (widget.memberProfile.packages != null &&
              widget.memberProfile.packages!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 1,
              color: context.resources.color.colorGrey.withOpacity(.25),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
        ],
      ],
    );
  }
}
