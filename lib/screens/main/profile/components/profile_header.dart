import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../components/primary_text.dart';
import '../../../../utils/Prefs.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../home/components/statistics/home_statistics_widget.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.resources.color.colorPrimary,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: context.resources.color.colorWhite,
                    shape: BoxShape.circle
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(1000),
                  child: PrimaryNetworkImage(
                    url: Prefs.getAvatar,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              SizedBox(width: 12,),

              Expanded(
                child:
                PrimaryText(
                  text: "${Prefs.getFName} ${Prefs.getLName}",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: context.resources.color.colorWhite,),
              ),


              GestureDetector(onTap: () {},
                  child: Image.asset(AppIcons.profile, width: 20,
                    color: context.resources.color.colorWhite,)),

              Container(
                height: 24,
                width: 1,
                margin: EdgeInsets.symmetric(horizontal: 8),
                color: context.resources.color.colorWhite.withOpacity(.7),
              ),
              GestureDetector(onTap: () {},
                  child: Image.asset(AppIcons.file, width: 20,
                      color: context.resources.color.colorWhite)),
            ],
          ),
          Container(
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16),
            color: context.resources.color.colorWhite.withOpacity(.25),
          ),

          Row(
            children: [
              StatisticsItem(
                title: 'Total Earnings',
                value: '\$834.12',
                textIcon: "\$",
                icon: "",
              ),
              SizedBox(width: 12),
              StatisticsItem(
                title: 'Wallet',
                value: '\$10000.0',
                icon: AppIcons.wallet,
              ),
            ],
          ),

        ],
      ),
    );
  }
}
