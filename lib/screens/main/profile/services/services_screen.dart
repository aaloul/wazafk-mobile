import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/skeletons/my_service_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/item_my_service.dart';
import 'services_controller.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServicesController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchServices();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(hasBack: true, title: Resources
                  .of(context)
                  .strings
                  .services),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) => MyServiceItemSkeleton(),
                    );
                  }

                  if (controller.services.isEmpty) {
                    return Center(child: Text(Resources
                        .of(context)
                        .strings
                        .noServicesAvailable));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.services.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final service = controller.services[index];
                      return ItemMyService(
                        service: service,
                        onToggleStatus: () =>
                            controller.toggleServiceStatus(service),
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
                      .createNewService,
                  onPressed: () {
                    Get.toNamed(RouteConstant.addServiceScreen);
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
