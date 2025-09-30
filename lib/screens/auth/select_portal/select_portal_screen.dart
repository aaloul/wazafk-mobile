import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SelectPortalScreen extends StatelessWidget {
  const SelectPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryButton(title: "Verify", onPressed: () {}),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
