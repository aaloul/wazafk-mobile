import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/services/service_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';

class MemberServicesCarousel extends StatefulWidget {
  const MemberServicesCarousel({
    super.key,
    required this.memberProfile,
    required this.onBookService,
  });

  final MemberProfile memberProfile;
  final Function onBookService;

  @override
  State<MemberServicesCarousel> createState() => _MemberServicesCarouselState();
}

class _MemberServicesCarouselState extends State<MemberServicesCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Services Carousel Section
        if (widget.memberProfile.services != null &&
            widget.memberProfile.services!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryText(
              text: 'Services',
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
            items: widget.memberProfile.services!.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              return ServiceCarouselItem(
                service: service,
                isFocused: index == _currentPage,
                onBookNow: () {
                  widget.onBookService(service);
                },
              );
            }).toList(),
          ),
          if (widget.memberProfile.services != null &&
              widget.memberProfile.services!.isNotEmpty)
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
