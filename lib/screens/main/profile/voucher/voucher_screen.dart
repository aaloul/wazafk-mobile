import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

/// Vouchers list per Figma p167. The design is essentially an empty-state
/// placeholder — no API exists in Postman for vouchers, so this is a
/// header + centered "no vouchers yet" message until the backend ships one.
class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(hasBack: true, title: strings.vouchers),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppIcons.voucher,
                      width: 64,
                      height: 64,
                      color: colors.colorGrey2,
                    ),
                    const SizedBox(height: 16),
                    PrimaryText(
                      text: strings.noVouchersYet,
                      fontSize: 14,
                      textColor: colors.colorGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
