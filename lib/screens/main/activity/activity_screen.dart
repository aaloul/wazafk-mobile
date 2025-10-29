import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/components/tabs_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/screens/main/projects/components/projects/project_item.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {},
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(
                hasBack: false,
                title: 'Activity',
              ),


            ],
          ),
        ),
      ),
    );
  }

}
