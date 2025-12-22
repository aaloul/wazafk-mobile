import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../utils/res/colors/hex_color.dart';
import '../home/home_controller.dart';
import 'components/profile_header.dart';
import 'components/settings/large_menu_item.dart';
import 'components/settings/settings_group_widget.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  late ProfileController controller;
  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    homeController = Get.find<HomeController>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh profile data when app comes back to foreground
      homeController.fetchProfile();
      homeController.fetchWallet();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
              ProfileHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      LargeMenuItem(
                      title: context.resources.strings.services,
                      onClick: () {
                          controller.navigateToServices();
                        },
                        color: HexColor("#CDE9EE"),
                        border: HexColor("#CDE9EE"),
                        icon: AppIcons.services,
                      ),

                      SizedBox(height: 10),
                      LargeMenuItem(
                      title: context.resources.strings.packs,
                      onClick: () {
                          controller.navigateToPacks();
                        },
                        color: HexColor("#E7F3EE"),
                        border: HexColor("#E7F3EE"),
                        icon: AppIcons.packs,
                      ),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.settingsGroups.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, groupIndex) {
                          final group = controller.settingsGroups[groupIndex];
                          return SettingsGroupWidget(settingsGroup: group);
                        },
                      ),

                      SizedBox(height: 24),
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
