import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/jobs/job_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class MemberJobsCarousel extends StatefulWidget {
  const MemberJobsCarousel({super.key, required this.memberProfile});

  final MemberProfile memberProfile;

  @override
  State<MemberJobsCarousel> createState() => _MemberJobsCarouselState();
}

class _MemberJobsCarouselState extends State<MemberJobsCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jobs Carousel Section
        if (widget.memberProfile.jobs != null &&
            widget.memberProfile.jobs!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryText(
              text: 'Work History',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              textColor: context.resources.color.colorGrey,
            ),
          ),
          SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              height: 156,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: widget.memberProfile.jobs!.asMap().entries.map((entry) {
              final index = entry.key;
              final job = entry.value;
              return JobCarouselItem(
                job: job,
                isFocused: index == _currentPage,
              );
            }).toList(),
          ),

          // Carousel Indicators
          if (widget.memberProfile.jobs!.length > 1) ...[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.memberProfile.jobs!.asMap().entries.map((entry) {
                return Container(
                  width: _currentPage == entry.key ? 12 : 12,
                  height: 12,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: _currentPage == entry.key
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey9,
                  ),
                );
              }).toList(),
            ),
          ],

          SizedBox(height: 8),

          if (widget.memberProfile.jobs != null &&
              widget.memberProfile.jobs!.isNotEmpty)
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
