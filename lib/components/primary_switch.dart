import 'package:flutter/cupertino.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class PrimarySwitch extends StatelessWidget {
  const PrimarySwitch({
    super.key,
    required this.checked,
    required this.onChange,
    this.scale,
  });

  final bool checked;
  final Function onChange;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale ?? 0.8,
      child: CupertinoSwitch(
        value: checked,
        thumbColor: checked
            ? context.resources.color.colorPrimary
            : context.resources.color.colorGrey5,
        activeColor: context.resources.color.colorWhite,
        trackColor: context.resources.color.colorWhite,
        onChanged: (bool? value) {
          onChange(value);
        },
      ),
    );
  }
}
