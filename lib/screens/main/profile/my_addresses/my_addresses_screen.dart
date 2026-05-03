import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/skeletons/my_address_item_skeleton.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/my_address_item.dart';
import 'my_addresses_controller.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAddressesController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchAddresses();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(
                hasBack: true,
                title: Resources.of(context).strings.myAddresses,
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: PrimaryButton(
                  title: Resources.of(context).strings.addNewAddress,
                  leadingIcon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.toNamed(RouteConstant.selectLocationScreen);
                  },
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          MyAddressItemSkeleton(),
                    );
                  }

                  if (controller.addresses.isEmpty) {
                    return Center(
                      child: Text(
                          Resources.of(context).strings.noAddressesFound),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.addresses.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final address = controller.addresses[index];
                      return MyAddressItem(
                        address: address,
                        onClick: () {},
                        onEditClick: () async {
                          final result = await Get.toNamed(
                            RouteConstant.selectLocationScreen,
                            arguments: {'address': address},
                          );
                          if (result == true) {
                            controller.fetchAddresses();
                          }
                        },
                        onDeleteClick: () {
                          if (address.hashcode != null) {
                            controller
                                .confirmDeleteAddress(address.hashcode!);
                          }
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
