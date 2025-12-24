import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'agreement_popup.dart';
import 'date_popup.dart';

class DialogHelper {
  static showDatePopup(
    context,
    Function onDateSelected, {
    DateTime? minDate,
    DateTime? maxDate,
  }) => showGeneralDialog(
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: DatePopup(
          onDateSelected: onDateSelected,
          minDate: minDate,
          maxDate: maxDate,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  );

  static showAgreementPopup(
    context,
    String title,
    String agreeText,
    String disAgreeText,
    Function onAgree,
    RxBool loading, {
    Color? agreeColor,
  }) => showGeneralDialog(
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: AgreementPopup(
          title: title,
          agreeText: agreeText,
          disAgreeText: disAgreeText,
          onAgree: onAgree,
          loading: loading,
          agreeColor: agreeColor,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  );
}
