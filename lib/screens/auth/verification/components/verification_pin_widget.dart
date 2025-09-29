import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class VerificationPinWidget extends StatefulWidget {
  final Function(String pin, bool completed) onPinChange;

  const VerificationPinWidget({super.key, required this.onPinChange});

  @override
  State<StatefulWidget> createState() {
    return _PinState();
  }
}

class _PinState extends State<VerificationPinWidget> {
  TextEditingController controller = TextEditingController(text: "");
  int pinLength = 4;
  bool hasError = false;
  late String errorMessage;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PinCodeTextField(
        pinBoxWidth: Get.width / 6.7,
        pinBoxHeight: Get.width / 6.7,
        autofocus: true,
        controller: controller,
        hideCharacter: false,
        highlight: false,
        highlightPinBoxColor: context.resources.color.colorWhite,
        pinBoxColor: context.resources.color.colorWhite,
        defaultBorderColor: context.resources.color.colorGrey2,
        hasTextBorderColor: context.resources.color.colorGrey2,
        pinBoxRadius: 5,
        pinBoxBorderWidth: 1.2,
        maxLength: pinLength,
        hasError: hasError,
        onTextChanged: (text) {
          if (text.length == pinLength) {
            _isCompleted = true;
          } else {
            _isCompleted = false;
          }
          widget.onPinChange(controller.text, _isCompleted);
        },
        onDone: (text) {
          widget.onPinChange(controller.text, _isCompleted);
        },
        pinBoxOuterPadding: const EdgeInsets.only(right: 6, left: 6),
        hasUnderline: false,
        wrapAlignment: WrapAlignment.center,
        pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
        highlightColor: Colors.transparent,
        pinTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.displaySmall?.color,
        ),
        pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
        pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 100),
        highlightAnimationBeginColor: Theme.of(context).scaffoldBackgroundColor,
        highlightAnimationEndColor: Colors.transparent,
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
