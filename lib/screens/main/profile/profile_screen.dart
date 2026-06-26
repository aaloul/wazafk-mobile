import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../components/sheets/sheets_helper.dart';
import '../../../constants/route_constant.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(),

              SizedBox(height: 20),

              Obx(() => homeController.isFreelancerMode.value
                  ? Column(
                children: [
                  LargeMenuItem(
                    title: context.resources.strings.services,
                    onClick: () => controller.navigateToServices(),
                    color: HexColor("#E5E5E5"),
                    border: HexColor("#E5E5E5"),
                    icon: AppIcons.bag,
                  ),
                  SizedBox(height: 10),
                  LargeMenuItem(
                    title: context.resources.strings.packs,
                    onClick: () => controller.navigateToPacks(),
                    color: HexColor("#E5E5E5"),
                    border: HexColor("#E5E5E5"),
                    icon: AppIcons.package,
                  ),
                ],
              )
                  : LargeMenuItem(
                title: context.resources.strings.jobsPosted,
                onClick: () => controller.navigateToJobs(),
                color: HexColor("#E5E5E5"),
                border: HexColor("#E5E5E5"),
                icon: AppIcons.bag,
              )),
              SizedBox(height: 12),


          Container(
            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: context.resources.color.colorWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.resources.color.colorGrey25,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteConstant.personalInformationScreen);

                  },
                  child: Column(
                    children: [

                      Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.all(14),
                        decoration:
                        BoxDecoration(
                          color: context.resources.color.colorPrimary.withOpacity(.2),
                          border: Border.all(
                            color: context.resources.color.colorPrimary.withOpacity(.2),
                            width: 1
                          ),
                          borderRadius: BorderRadiusGeometry.circular(20)
                        ),
                        child: Image.asset(AppIcons.profile3,width: 24,height: 24,),
                      ),
                      SizedBox(height: 6,),
                      PrimaryText(text: 'Profile',fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                        fontSize: 12,
                      )
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => Get.toNamed(RouteConstant.getSupportScreen),
                  child: Column(
                    children: [

                      Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.all(14),
                        decoration:
                        BoxDecoration(
                          color: context.resources.color.colorPrimary.withOpacity(.2),
                          border: Border.all(
                            color: context.resources.color.colorPrimary.withOpacity(.2),
                            width: 1
                          ),
                          borderRadius: BorderRadiusGeometry.circular(20)
                        ),
                        child: Image.asset(AppIcons.support,width: 24,height: 24,),
                      ),
                      SizedBox(height: 6,),
                      PrimaryText(text: 'Support',fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                        fontSize: 12,
                      )
                    ],
                  ),
                ),


                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteConstant.paymentMethodsScreen);

                  },
                  child: Column(
                    children: [

                      Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.all(14),
                        decoration:
                        BoxDecoration(
                          color: context.resources.color.colorPrimary.withOpacity(.2),
                          border: Border.all(
                            color: context.resources.color.colorPrimary.withOpacity(.2),
                            width: 1
                          ),
                          borderRadius: BorderRadiusGeometry.circular(20)
                        ),
                        child: Image.asset(AppIcons.payment,width: 24,height: 24,),
                      ),
                      SizedBox(height: 6,),
                      PrimaryText(text: 'Payments',fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                        fontSize: 12,
                      )
                    ],
                  ),
                ),


                GestureDetector(
                  onTap: (){
                    SheetHelper.showChangeLanguageSheet(context);
                  },
                  child: Column(
                    children: [

                      Container(
                        width: 60,
                        height: 60,
                        padding: EdgeInsets.all(14),
                        decoration:
                        BoxDecoration(
                          color: context.resources.color.colorPrimary.withOpacity(.2),
                          border: Border.all(
                            color: context.resources.color.colorPrimary.withOpacity(.2),
                            width: 1
                          ),
                          borderRadius: BorderRadiusGeometry.circular(20)
                        ),
                        child: Image.asset(AppIcons.language,width: 24,height: 24,),
                      ),
                      SizedBox(height: 6,),
                      PrimaryText(text: 'Language',fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey26,
                        fontSize: 12,
                      )
                    ],
                  ),
                ),



              ],
            ),
            ),


              SizedBox(height: 4),



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
    );
  }
}
