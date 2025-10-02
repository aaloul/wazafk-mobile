import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/profile/login_security/where_logged_in/where_logged_in_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class WhereLoggedInScreen extends StatelessWidget {
  const WhereLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhereLoggedInController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: "Where You're Logged In"),
            SizedBox(height: 16),
            // Expanded(
            //   child: Obx(() {
            //     if (controller.isLoading.value) {
            //       return Center(
            //         child: ProgressBar(),
            //       );
            //     }
            //
            //     if (controller.loginSessions.isEmpty) {
            //       return Center(
            //         child: PrimaryText(
            //           text: 'No active sessions found',
            //           fontSize: 14,
            //           textColor: context.resources.color.colorGrey8,
            //         ),
            //       );
            //     }
            //
            //     return ListView.separated(
            //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //       itemCount: controller.loginSessions.length,
            //       separatorBuilder: (context, index) => SizedBox(height: 12),
            //       itemBuilder: (context, index) {
            //         final session = controller.loginSessions[index];
            //         return Container(
            //           padding: EdgeInsets.all(16),
            //           decoration: BoxDecoration(
            //             color: context.resources.color.colorWhite,
            //             borderRadius: BorderRadius.circular(10),
            //             border: Border.all(
            //               color: context.resources.color.colorGrey9,
            //               width: 0.5,
            //             ),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //
            //               PrimaryText(
            //                 text: session['device'] ?? '',
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w900,
            //                 textColor: context.resources.color.colorGrey,
            //               ),
            //
            //               SizedBox(height: 8),
            //               PrimaryText(
            //                 text: session['location'] ?? '',
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.w400,
            //                 textColor: context.resources.color.colorGrey8,
            //               ),
            //
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}
