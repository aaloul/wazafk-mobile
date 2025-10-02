import 'package:flutter/material.dart';
import 'package:wazafak_app/model/DocumentsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../components/primary_text.dart';
import '../../../../../utils/res/colors/hex_color.dart';

class MyDocumentItem extends StatelessWidget {
  const MyDocumentItem({
    super.key,
    required this.document,
    required this.onClick,
  });

  final Document document;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: HexColor("#CDE9EE"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(AppIcons.document, width: 42),

            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: document.type ?? "N/A",
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    textColor: context.resources.color.colorGrey,
                  ),
                  SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: context.resources.color.colorGrey12,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: PrimaryText(
                      text: document.status.toString() ?? "N/A",
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      textColor: context.resources.color.colorWhite,
                    ),
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
