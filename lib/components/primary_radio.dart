import 'package:flutter/material.dart';

import '../utils/res/AppIcons.dart';

class PrimaryRadio extends StatelessWidget {
  const PrimaryRadio({super.key, required this.checked, this.width});

  final bool checked;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: checked
          ? Image.asset(AppIcons.radioOn, width: width ?? 35)
          : Image.asset(AppIcons.radioOff, width: width ?? 35),
    );
  }
}
