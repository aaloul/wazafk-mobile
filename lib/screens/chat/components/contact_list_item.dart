import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/ContactsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/res/colors/hex_color.dart';

class ContactListItem extends StatelessWidget {
  const ContactListItem({
    super.key,
    required this.contact,
    required this.contactName,
    this.onTap,
  });

  final ContactElement contact;
  final String contactName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(99999999),
              child: PrimaryNetworkImage(
                url: contact.image.toString(),
                width: 45,
                height: 45,
              ),
            ),
            SizedBox(
              width: 12,
              height: 40,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: contactName,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey26,
                    fontSize: 12,
                  ),
                  SizedBox(height: 4),
                  PrimaryText(
                    text: contact.title ?? Resources.of(context).strings.notAvailableShort,
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          Divider(
            height: 1,
            thickness: 1,
            color: HexColor('#E9E9E9'),
          ),
        ],
      ),
    );
  }
}
