import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorGrey4,
      body: Center(
        child: PrimaryText(
          text: 'Home Screen',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: context.resources.color.colorBlackMain,
        ),
      ),
    );
  }
}
