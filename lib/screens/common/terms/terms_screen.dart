import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../components/primary_text.dart';

class TermsScreen extends StatelessWidget {
  TermsScreen({super.key});

  final String type = Get.arguments?['type'] ?? 'terms';

  @override
  Widget build(BuildContext context) {
    final String title = type == 'terms'
        ? Prefs.getTermsAndConditionsTitle
        : Prefs.getPrivacyPolicyTitle;
    final String content = type == 'terms'
        ? Prefs.getTermsAndConditions
        : Prefs.getPrivacyPolicy;

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                  color: context.resources.color.colorPrimary,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)
                  )
              ),
            ),

            SizedBox(height: 24),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: title,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      textColor: context.resources.color.colorBlackMain,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 24),

                    if (content.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: PrimaryText(
                            text: context.resources.strings.noContentAvailable,
                            textColor: context.resources.color.colorGrey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: HtmlWidget(
                            content,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: context.resources.color.colorBlackMain,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(title: context.resources.strings.close,
                  onPressed: () {
                    Navigator.pop(Get.context!);
                  }),
            ),

            SizedBox(height: 24),


          ],
        ),
      ),
    );
  }
}
