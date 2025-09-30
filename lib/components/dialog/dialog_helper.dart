import 'package:flutter/material.dart';

import 'date_popup.dart';

class DialogHelper {
  static showDatePopup(context, Function onDateSelected) => showGeneralDialog(
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: DatePopup(onDateSelected: onDateSelected),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  );
}
