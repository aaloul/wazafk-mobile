import 'package:flutter/material.dart';
import 'package:wazafak_app/model/MemberProfileResponse.dart';
import 'package:wazafak_app/screens/main/member_profiles/components/services/service_carousel_item.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';

class MemberServicesCarousel extends StatelessWidget {
  const MemberServicesCarousel({
    super.key,
    required this.memberProfile,
    required this.onBookService,
  });

  final MemberProfile memberProfile;
  final Function onBookService;

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final services = memberProfile.services;
    if (services == null || services.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: context.resources.strings.services,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: context.resources.color.colorBlack4,
          ),
          const SizedBox(height: 16),
          ...services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ServiceCarouselItem(
                service: service,
                showShadow: true,
                onBookNow: () => onBookService(service),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
