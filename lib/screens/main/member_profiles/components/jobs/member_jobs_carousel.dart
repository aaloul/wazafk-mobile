import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/jobs/job_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class MemberJobsCarousel extends StatefulWidget {
  const MemberJobsCarousel({
    super.key,
    required this.engagements,
    this.isLoading = false,
  });

  final List<Engagement> engagements;
  final bool isLoading;

  @override
  State<MemberJobsCarousel> createState() => _MemberJobsCarouselState();
}

class _MemberJobsCarouselState extends State<MemberJobsCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (widget.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: ProgressBar()),
      );
    }

    // Don't show anything if no engagements
    if (widget.engagements.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Jobs Carousel Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PrimaryText(
            text: context.resources.strings.workHistory,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            textColor: context.resources.color.colorGrey,
          ),
        ),
        SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 165,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            viewportFraction: .8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          items: widget.engagements.asMap().entries.map((entry) {
            final index = entry.key;
            final engagement = entry.value;
            return JobCarouselItem(
              engagement: engagement,
              isFocused: index == _currentPage,
            );
          }).toList(),
        ),

        // Carousel Indicators
        if (widget.engagements.length > 1) ...[
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.engagements.asMap().entries.map((entry) {
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

        Container(
          width: double.infinity,
          height: 1,
          color: context.resources.color.colorGrey.withOpacity(.25),
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        ),
      ],
    );
  }
}
