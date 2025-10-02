import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'about_us_controller.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutUsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.title.value.isEmpty
                    ? 'About Us'
                    : controller.title.value,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: ProgressBar());
                }

                if (controller.htmlContent.value.isEmpty) {
                  return Center(child: Text('No content available'));
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: HtmlWidget(
                    controller.htmlContent.value,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: context.resources.color.colorGrey,
                      height: 1.5,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
