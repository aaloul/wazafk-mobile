import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/outlined_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/screens/main/book_service/book_service_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../constants/route_constant.dart';

class AddressListWidget extends StatelessWidget {
  const AddressListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookServiceController>();

    return Obx(() {
      if (controller.isLoadingAddresses.value) {
        return Container(
          padding: EdgeInsets.all(32),
          child: Center(child: ProgressBar()),
        );
      }

      final addresses = controller.addresses;

      if (addresses.isEmpty) {
        return _buildEmptyState(context);
      }

      return _buildAddressList(context, controller, addresses);
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.resources.color.colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.resources.color.colorGrey18,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            size: 48,
            color: context.resources.color.colorGrey8,
          ),
          SizedBox(height: 8),
          PrimaryText(
            text: context.resources.strings.noAddressesAvailable,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: context.resources.color.colorGrey8,
          ),
          SizedBox(height: 4),
          PrimaryText(
            text: context.resources.strings.pleaseAddAddressFromProfile,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey19,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          PrimaryOutlinedButton(
            title: Resources.of(context).strings.addNewAddress,
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

  Widget _buildAddressList(
    BuildContext context,
    BookServiceController controller,
    List<Address> addresses,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PrimaryText(
              text: context.resources.strings.chooseLocation,
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            const SizedBox(width: 4),
            PrimaryText(
              text: '*',
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ],
        ),
        SizedBox(height: 12),
        ...addresses
            .map((address) => _buildAddressItem(context, controller, address))
            .toList(),
        SizedBox(height: 8),

        PrimaryOutlinedButton(
          title: Resources.of(context).strings.addNewAddress,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          onPressed: () async {
            Get.toNamed(RouteConstant.selectLocationScreen);
          },
        ),
      ],
    );
  }

  Widget _buildAddressItem(
    BuildContext context,
    BookServiceController controller,
    Address address,
  ) {
    return Obx(() {
      final isSelected =
          controller.selectedAddress.value?.hashcode == address.hashcode;

      return GestureDetector(
        onTap: () => controller.selectAddress(address),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.resources.color.colorGreen4
                : context.resources.color.colorWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? context.resources.color.colorPrimary
                  : context.resources.color.colorGrey4,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: address.label ?? 'Address',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: context.resources.color.colorGrey,
                    ),
                    SizedBox(height: 4),
                    PrimaryText(
                      text:
                          '${address.city.toString()}, ${address.street.toString()}, ${address.building.toString()}',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: context.resources.color.colorGrey19,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey2,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.resources.color.colorPrimary,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
