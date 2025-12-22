import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'help_center_controller.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpCenterController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeader(
                hasBack: true, title: context.resources.strings.helpCenter),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryText(
                text: context.resources.strings.howCanWeHelpYou,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                textColor: context.resources.color.colorGrey,
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: ProgressBar());
                }

                if (controller.faqs.isEmpty) {
                  return Center(child: Text('No FAQs available'));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: controller.faqs.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final faq = controller.faqs[index];

                    return Obx(() {
                      final isExpanded =
                          controller.expandedIndex.value == index;

                      return GestureDetector(
                        onTap: () => controller.toggleExpand(index),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.resources.color.colorWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: context.resources.color.colorGrey9,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryText(
                                      text: faq.question ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      textColor:
                                          context.resources.color.colorGrey,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: context.resources.color.colorGrey8,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                SizedBox(height: 10),

                                Divider(
                                  height: 1,
                                  color: context.resources.color.colorGrey9,
                                  thickness: 0.5,
                                ),

                                SizedBox(height: 10),
                                PrimaryText(
                                  text: faq.answer ?? '',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                      context.resources.color.colorGrey10,
                                  height: 1.5,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
