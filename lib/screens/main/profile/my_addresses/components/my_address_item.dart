import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.resources.color.colorGrey11,
            width: .4,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: address.label.toString(),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    textColor: context.resources.color.colorGrey11,
                  ),
                  SizedBox(height: 5),
                  PrimaryText(
                    text:
                        '${address.city.toString()}, ${address.street.toString()}, ${address.building.toString()}',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    textColor: context.resources.color.colorGrey8,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8),

            GestureDetector(
              onTap: () {
                onEditClick.call();
              },
              child: Image.asset(AppIcons.edit, width: 22),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                onDeleteClick.call();
              },
              child: Image.asset(AppIcons.delete, width: 18),
            ),
          ],
        ),
      ),
    );
  }
}
