import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/top_header.dart';
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

            TopHeader(
              title: title,
            ),


            SizedBox(height: 16,),

            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


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
