import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

class MyAddressItem extends StatelessWidget {
  const MyAddressItem({
    super.key,
    required this.address,
    required this.onClick,
    required this.onDeleteClick,
    required this.onEditClick,
  });

  final Address address;
  final Function onClick;
  final Function onDeleteClick;
  final Function onEditClick;

  void _showOptionsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: context.resources.color.colorGrey15,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            PrimaryText(
              text: address.label.toString(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: context.resources.color.colorBlack4,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: context.resources.strings.edit,
              height: 45,
              onPressed: () {
                Get.back();
                onEditClick.call();
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Get.back();
                  onDeleteClick.call();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: PrimaryText(
                  text: context.resources.strings.delete,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick.call(),
      child: Card(
        color: context.resources.color.colorWhite,
        elevation: 8,
        shadowColor: Colors.black26,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: context.resources.color.colorGrey15,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.asset(AppIcons.address, width: 32),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: address.label.toString(),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      textColor: context.resources.color.colorBlack4,
                    ),
                    const SizedBox(height: 2),
                    PrimaryText(
                      text:
                          '${address.city}, ${address.street}, ${address.building}',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      textColor: context.resources.color.colorGrey26,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showOptionsBottomSheet(context),
                child: Image.asset(
                  AppIcons.threeDots,
                  width: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
