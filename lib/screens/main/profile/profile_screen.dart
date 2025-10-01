import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: Center(
        child: PrimaryText(
          text: 'Profile Screen',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: context.resources.color.colorBlackMain,
        ),
      ),
    );
  }
}
