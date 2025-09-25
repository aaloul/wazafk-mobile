import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, this.color, this.width});

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 50,
        height: width ?? 50,
        child: LoadingIndicator(
          colors: [color ?? context.resources.color.colorPrimary],
          indicatorType: Indicator.ballRotateChase,
          strokeWidth: 3,
          // pathBackgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
