import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/skeletons/my_package_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/profile/packages/packs_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/item_my_package.dart';

class PacksScreen extends StatelessWidget {
  const PacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PacksController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchPackages();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(hasBack: true, title: Resources
                  .of(context)
                  .strings
                  .packs),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) => MyPackageItemSkeleton(),
                    );
                  }

                  if (controller.packages.isEmpty) {
                    return Center(child: Text(Resources
                        .of(context)
                        .strings
                        .noPackagesAvailable));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.packages.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final package = controller.packages[index];
                      return ItemMyPackage(
                        package: package,
                        onToggleStatus: () =>
                            controller.togglePackageStatus(package),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: 8),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryButton(
                  title: Resources
                      .of(context)
                      .strings
                      .createNewPack,
                  onPressed: () async {
                    Get.toNamed(RouteConstant.addPackageScreen);
                  },
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
