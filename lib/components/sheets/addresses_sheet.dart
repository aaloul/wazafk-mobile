import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/outlined_button.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class AddressesSheet extends StatefulWidget {
  final List<Address> selectedAddresses;
  final Function(List<Address>) onAddressesSelected;
  final bool singleSelect;

  const AddressesSheet({
    super.key,
    required this.selectedAddresses,
    required this.onAddressesSelected,
    this.singleSelect = false,
  });

  @override
  State<AddressesSheet> createState() => _AddressesSheetState();
}

class _AddressesSheetState extends State<AddressesSheet> {
  late List<Address> tempSelectedAddresses;
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    tempSelectedAddresses = List.from(widget.selectedAddresses);
  }

  bool isAddressSelected(Address address) {
    return tempSelectedAddresses.any((a) => a.hashcode == address.hashcode);
  }

  void toggleAddressSelection(Address address) {
    setState(() {
      if (widget.singleSelect) {
        // For single select, replace the selection
        tempSelectedAddresses.clear();
        tempSelectedAddresses.add(address);
      } else {
        // For multi-select, toggle the selection
        if (isAddressSelected(address)) {
          tempSelectedAddresses.removeWhere(
            (a) => a.hashcode == address.hashcode,
          );
        } else {
          tempSelectedAddresses.add(address);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: context.resources.color.background2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  text: widget.singleSelect
                      ? "Select Address"
                      : "Select Addresses",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorGrey,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: context.resources.color.colorGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (homeController.addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 48,
                          color: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 8),
                        PrimaryText(
                          text: 'No addresses available',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorGrey8,
                        ),
                        SizedBox(height: 4),
                        PrimaryText(
                          text: 'Please add an address from your profile',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey8,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        PrimaryOutlinedButton(
                          title: "+ Add New Address",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          onPressed: () async {
                            Get.toNamed(RouteConstant.selectLocationScreen);
                          },
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: homeController.addresses.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final address = homeController.addresses[index];
                          final isSelected = isAddressSelected(address);
                          return GestureDetector(
                            onTap: () => toggleAddressSelection(address),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.resources.color.colorPrimary
                                          .withOpacity(0.1)
                                    : context.resources.color.colorWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? context.resources.color.colorPrimary
                                      : context.resources.color.colorGrey2,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text: address.label ?? '',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          textColor: isSelected
                                              ? context
                                                    .resources
                                                    .color
                                                    .colorPrimary
                                              : context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text:
                                              '${address.address}, ${address.city}',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey8,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color:
                                          context.resources.color.colorPrimary,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    PrimaryOutlinedButton(
                      title: "+ Add New Address",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      onPressed: () async {
                        Get.toNamed(RouteConstant.selectLocationScreen);
                      },
                    ),
                  ],
                );
              }),
            ),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: 'Apply',
                    onPressed: () {
                      widget.onAddressesSelected(tempSelectedAddresses);
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
