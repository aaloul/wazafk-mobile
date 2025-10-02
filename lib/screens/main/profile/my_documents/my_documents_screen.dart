import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/my_document_item.dart';
import 'my_documents_controller.dart';

class MyDocumentsScreen extends StatelessWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDocumentsController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'My Documents'),
            SizedBox(height: 16,),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: ProgressBar(),
                  );
                }

                if (controller.documents.isEmpty) {
                  return Center(
                    child: Text('No documents found'),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: controller.documents.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final document = controller.documents[index];
                    return MyDocumentItem(
                      document: document,
                      onClick: () {
                        // Handle document click
                      },
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
