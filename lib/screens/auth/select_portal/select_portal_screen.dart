import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/primary_button.dart';
import '../../../components/top_header.dart';
import 'components/portal_item.dart';

class SelectPortalScreen extends StatelessWidget {
  const SelectPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var isEmployer = false.obs;

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeader(title: Resources
                .of(context)
                .strings
                .selectPortal),
            SizedBox(height: 24),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Obx(()=>  PortalItem(
                      title: Resources
                          .of(context)
                          .strings
                          .freelancerPortal,
                      onClick: () {
                        Prefs.setUserMode('freelancer');
                        isEmployer.value = false;
                      }, selected: !isEmployer.value,
                    ),
                    ),
                    SizedBox(height: 10),

                    Obx(()=> PortalItem(
                      title: Resources
                          .of(context)
                          .strings
                          .employerPortal,
                      onClick: () {
                        isEmployer.value = true;
                        Prefs.setUserMode('employer');
                      }, selected: isEmployer.value,

                    ),),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Container(
                margin: EdgeInsets.all(16),
                child: PrimaryButton(
                  title: Resources.of(context).strings.startYourJourney,
                  onPressed: () {

                    if(Prefs.getUserMode == 'employer'){
                      Get.offAllNamed(RouteConstant.mainNavigationScreen);
                    }else{
                      Get.offAllNamed(RouteConstant.mainNavigationScreen);
                    }
                  },
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
