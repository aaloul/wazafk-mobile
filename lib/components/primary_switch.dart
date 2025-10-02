import 'package:flutter/cupertino.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class PrimarySwitch extends StatelessWidget {
  const PrimarySwitch({
    super.key,
    required this.checked,
    required this.onChange,
    this.scale,
    this.thumbColorActive,
    this.thumbColorNotActive,
    this.activeColor,
    this.trackColor,
    this.activeTrackColor,
  });

  final bool checked;
  final Function onChange;
  final double? scale;
  final Color? thumbColorActive;
  final Color? thumbColorNotActive;
  final Color? activeColor;
  final Color? trackColor;
  final Color? activeTrackColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale ?? 0.8,
      child: CupertinoSwitch(
        value: checked,
        thumbColor: checked
            ? thumbColorActive ?? context.resources.color.colorPrimary
            : thumbColorNotActive ?? context.resources.color.colorGrey5,
        activeColor: activeColor ?? context.resources.color.colorWhite,
        trackColor: checked
            ? activeTrackColor ?? context.resources.color.colorWhite
            : trackColor ?? context.resources.color.colorWhite,
        onChanged: (bool? value) {
          onChange(value);
        },
      ),
    );
  }
}
