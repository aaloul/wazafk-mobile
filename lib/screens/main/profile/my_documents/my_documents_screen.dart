import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import 'components/my_document_item.dart';
import 'my_documents_controller.dart';

class MyDocumentsScreen extends StatelessWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDocumentsController());
    final colors = context.resources.color;
    final strings = Resources.of(context).strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: strings.myDocuments),
            Container(height: 1, color: colors.colorGrey4),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: ProgressBar());
                }
                if (controller.documents.isEmpty) {
                  return Center(
                    child: PrimaryText(
                      text: strings.noDocumentsFound,
                      textColor: colors.colorGrey,
                      fontSize: 14,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: controller.documents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final document = controller.documents[index];
                    return MyDocumentItem(
                      document: document,
                      onClick: () => Get.toNamed(
                        RouteConstant.uploadDocumentsScreen,
                        arguments: document,
                      ),
                    );
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
