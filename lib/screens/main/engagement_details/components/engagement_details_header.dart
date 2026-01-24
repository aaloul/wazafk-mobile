import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class EngagementDetailsHeader extends StatelessWidget {
  final Engagement engagement;

  const EngagementDetailsHeader({super.key, required this.engagement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: context.resources.color.colorGrey,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: PrimaryText(
              text: context.resources.strings.taskDetails,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: context.resources.color.colorGrey,
            ),
          ),
        ],
      ),
    );
  }
}
