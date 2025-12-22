import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import 'components/share_desc_item.dart';
import 'share_app_controller.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShareAppController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(children: [
          TopHeader(hasBack: true, title: context.resources.strings.shareApp),
          SizedBox(height: 16,),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                          AppIcons.shareIntro, width: Get.width / 1.5,)),

                    SizedBox(height: 20,),

                    Container(
                      width: double.infinity,
                      height: 2,
                      color: HexColor("#353C82").withOpacity(.1),
                    ),
                    SizedBox(height: 16,),


                    Center(
                      child: PrimaryText(
                        text: context.resources.strings.inviteFriendAndGet,
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w700,
                        textColor: context.resources.color.colorGrey8,),
                    ),

                    SizedBox(height: 16,),

                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.settingItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ShareDescItem(
                          settingsModel: controller.settingItems[index],
                          onClick: (id) {

                          },
                          index: index,
                          totalLength: controller.settingItems.length,
                        );
                      },
                    ),


                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 16,),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryButton(
                title: context.resources.strings.inviteAFriend, onPressed: () {
              Get.toNamed(RouteConstant.inviteFriendsScreen);
            }),
          ),


          SizedBox(height: 16,),


        ]),
      ),
    );
  }
}
