import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'privacy_sharing_controller.dart';

class PrivacySharingScreen extends StatelessWidget {
  const PrivacySharingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PrivacySharingController());
    final colors = context.resources.color;
    final strings = context.resources.strings;
    final content = Prefs.getPrivacyPolicy;

    return Scaffold(
      backgroundColor: colors.colorWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.privacyAndSharing),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: content.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: PrimaryText(
                          text: strings.noContentAvailable,
                          textColor: colors.colorGrey,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: HtmlWidget(
                        content,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: colors.colorBlackMain,
                          height: 1.5,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
