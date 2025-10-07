import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/my_address_item.dart';
import 'my_addresses_controller.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAddressesController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'My Addresses'),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: ProgressBar(),
                  );
                }

                if (controller.addresses.isEmpty) {
                  return Center(
                    child: Text('No addresses found'),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: controller.addresses.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = controller.addresses[index];
                    return MyAddressItem(
                      address: address,
                      onClick: () {
                        // Handle address click
                      },
                      onEditClick: () async {
                        final result = await Get.toNamed(
                          RouteConstant.selectLocationScreen,
                          arguments: {
                            'address': address
                          },
                        );
                        if (result == true) {
                          controller.fetchAddresses();
                        }
                      },
                      onDeleteClick: () {
                        if (address.hashcode != null) {
                          controller.confirmDeleteAddress(address.hashcode!);
                        }
                      },
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 0),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                  title: "Add New Address", onPressed: () async {
                Get.toNamed(RouteConstant.selectLocationScreen);
              }),
            ),

            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
