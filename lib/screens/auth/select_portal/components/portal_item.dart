import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class PortalItem extends StatelessWidget {
  const PortalItem({
    super.key,
    required this.title,
    required this.onClick,
    required this.color,
    required this.border,
  });

  final String title;
  final Function onClick;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick.call();
      },
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: PrimaryText(
            text: title,
            textColor: context.resources.color.colorPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
