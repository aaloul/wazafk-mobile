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
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(99999999),
              child: PrimaryNetworkImage(
                url: contact.image.toString(),
                width: 60,
                height: 60,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: HexColor('#99999980').withOpacity(.5),
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: contactName,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey23,
                    fontSize: 16,
                  ),
                  SizedBox(height: 4),
                  PrimaryText(
                    text: contact.title ?? Resources.of(context).strings.notAvailableShort,
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey23,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
