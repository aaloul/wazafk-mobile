import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'components/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.colorGrey4,
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(),

          ],
        ),
      ),
    );
  }
}
