import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class CreateAccountSteps extends StatelessWidget {
  const CreateAccountSteps({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: context.resources.color.colorPrimary,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),

        SizedBox(width: 6),
        Expanded(
          flex: 1,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: index > 0
                  ? context.resources.color.colorPrimary
                  : context.resources.color.colorGrey4,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        SizedBox(width: 6),

        Expanded(
          flex: 1,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: index > 1
                  ? context.resources.color.colorPrimary
                  : context.resources.color.colorGrey4,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ],
    );
  }
}
