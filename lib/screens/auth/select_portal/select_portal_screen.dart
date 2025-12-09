import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

import '../../../components/top_header.dart';
import 'components/portal_item.dart';

class SelectPortalScreen extends StatelessWidget {
  const SelectPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeader(title: "Select Portal"),
            SizedBox(height: 24),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PortalItem(
                      title: 'Freelancer Portal',
                      onClick: () {
                        Prefs.setUserMode('freelancer');
                        Get.offAllNamed(RouteConstant.mainNavigationScreen);
                      },
                      color: HexColor("#E7F3EE"),
                      border: HexColor("#00AEC81A"),
                    ),
                    SizedBox(height: 10),

                    PortalItem(
                      title: 'Employer Portal',
                      onClick: () {
                        Prefs.setUserMode('employer');
                        Get.offAllNamed(RouteConstant.mainNavigationScreen);
                      },
                      color: HexColor("#D5ECEF"),
                      border: HexColor("##00AEC81A"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
