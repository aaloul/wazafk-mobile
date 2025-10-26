import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../../../utils/utils.dart';

class MemberProfileHeader extends StatelessWidget {
  const MemberProfileHeader({super.key, required this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  AppIcons.jobCover,
                  fit: BoxFit.cover,
                  height: 160,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 16,
            left: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: Image.asset(
                    AppIcons.back,
                    width: 30,
                    color: context.resources.color.colorWhite,
                  ),
                ),
                Spacer(),

                Image.asset(
                  AppIcons.banomark,
                  width: 20,
                  color: context.resources.color.colorWhite,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.background2,
                      width: 5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(999999),
                    child: PrimaryNetworkImage(
                      url: avatar,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
