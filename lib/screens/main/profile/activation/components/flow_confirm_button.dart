import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';

/// Primary action for the last flow step — awaits the async submit and keeps a
/// loader up while it runs, so the step can't be double-submitted.
class FlowConfirmButton extends StatefulWidget {
  const FlowConfirmButton({
    super.key,
    required this.title,
    required this.onConfirm,
    this.enabled = true,
    this.color,
  });

  final String title;
  final Future<void> Function() onConfirm;
  final bool enabled;
  final Color? color;

  @override
  State<FlowConfirmButton> createState() => _FlowConfirmButtonState();
}

class _FlowConfirmButtonState extends State<FlowConfirmButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    if (_busy) return ProgressBar();
    return PrimaryButton(
      title: widget.title,
      color: widget.color,
      onPressed: () async {
        if (!widget.enabled || _busy) return;
        setState(() => _busy = true);
        try {
          await widget.onConfirm();
        } finally {
          if (mounted) setState(() => _busy = false);
        }
      },
    );
  }
}
