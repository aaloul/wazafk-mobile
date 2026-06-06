import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/utils.dart';

/// Add Card screen — Figma p147.
///
/// **UI-only.** The matching backend endpoint (`wallet/savePaymentProfile`)
/// accepts bank-account / routing-number / ID-document fields, not card
/// details. Wiring the form to that endpoint would silently corrupt data.
/// Until a real card-storage endpoint exists, Save is a no-op that pops
/// with a placeholder result.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _selectedBrand = 'master';

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _cardController.text.replaceAll(' ', '').length >= 16 &&
      _expiryController.text.length >= 5 &&
      _cvvController.text.length >= 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Container(height: 1, color: colors.colorGrey4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _FieldBox(
                    label: strings.cardNumber,
                    child: TextField(
                      controller: _cardController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        _GroupedNumberFormatter(),
                      ],
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.colorBlack,
                        letterSpacing: 1.5,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: '**** **** **** 0000',
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _BrandChips(
                    selected: _selectedBrand,
                    onChanged: (b) => setState(() => _selectedBrand = b),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _FieldBox(
                          label: strings.expiryDate,
                          child: TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                              _ExpiryFormatter(),
                            ],
                            onChanged: (_) => setState(() {}),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.colorBlack,
                            ),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: '01/2027',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _FieldBox(
                          label: strings.cvv,
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (_) => setState(() {}),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.colorBlack,
                            ),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: '***',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: PrimaryButton(
                title: strings.save,
                color: _canSave ? colors.colorPrimary : colors.colorGrey2,
                onPressed: () {
                  if (!_canSave) return;
                  // No matching backend endpoint — close with a stub result
                  // so callers can refresh their list.
                  Get.back(result: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = context.resources.strings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: RotatedBox(
              quarterTurns: Utils().isRTL() ? 2 : 0,
              child: Image.asset(AppIcons.back3, width: 36),
            ),
          ),
          const SizedBox(width: 8),
          PrimaryText(
            text: strings.addCard,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: colors.colorBlack,
          ),
          const Spacer(),
          PrimaryText(
            text: strings.delete,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: colors.colorRed2,
          ),
        ],
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.colorGrey4, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: label,
            fontSize: 11,
            textColor: colors.colorGrey,
          ),
          const SizedBox(height: 2),
          child,
        ],
      ),
    );
  }
}

class _BrandChips extends StatelessWidget {
  const _BrandChips({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final brands = const [
      _BrandData('master', AppIcons.brandMaster),
      _BrandData('omt', AppIcons.brandOmt),
      _BrandData('visa', AppIcons.brandVisa),
      _BrandData('whish', AppIcons.brandWhish),
    ];
    return Row(
      children: [
        for (final b in brands) ...[
          _BrandChip(
            icon: b.icon,
            active: selected == b.id,
            onTap: () => onChanged(b.id),
          ),
          if (b != brands.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _BrandData {
  const _BrandData(this.id, this.icon);
  final String id;
  final String icon;
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: active ? 1.0 : 0.45,
        child: Container(
          width: 56,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: colors.colorGrey4,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Image.asset(icon, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _GroupedNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\s'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String out;
    if (digits.length <= 2) {
      out = digits;
    } else {
      final m = digits.substring(0, 2);
      final y = digits.substring(2, digits.length.clamp(2, 6));
      out = '$m/$y';
    }
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: out.length),
    );
  }
}
