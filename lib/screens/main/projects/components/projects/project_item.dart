import 'package:flutter/material.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../../components/primary_text.dart';
import '../../../../../utils/res/AppIcons.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.engagement});

  final Engagement engagement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.resources.color.colorGrey15,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: 'Ui Design',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorBlack3,
                    ),

                    PrimaryText(
                      text: engagement.description ?? 'N/A',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorBlack3,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: '\$${engagement.totalPrice.toString()}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGreen3,
                  ),

                  PrimaryText(
                    text: 'Total Value',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey7,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),

          // PrimaryText(
          //   text: job.title.toString(),
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          //   textColor: context.resources.color.colorGrey16,
          // ),
          // SizedBox(height: 4),
          // PrimaryText(
          //   text: DateFormat("dd-MM-yyyy").format(job.startDatetime!),
          //   fontSize: 12,
          //   fontWeight: FontWeight.w400,
          //   textColor: context.resources.color.colorGrey16,
          // ),
          //
          // SizedBox(height: 8),
          //
          Container(
            width: double.infinity,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 12),
            color: context.resources.color.colorPrimary.withOpacity(.25),
          ),

          // Row(
          //   children: [
          //     Image.asset(AppIcons.location, width: 18),
          //     SizedBox(width: 8),
          //     Expanded(child: PrimaryText(text: job.workLocationType ?? "N/A")),
          //
          //     PrimaryText(
          //       text: "\$${job.totalPrice}",
          //       textColor: context.resources.color.colorGreen3,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
