import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Renders [text] with any contained URL turned into a tappable span that
/// opens in the system browser. Used in chat messages so links the user types
/// (or the shared location URL) become clickable.
class LinkifiedText extends StatefulWidget {
  const LinkifiedText({
    super.key,
    required this.text,
    required this.textColor,
    this.linkColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.height = 1.3,
    this.maxLines,
  });

  final String text;
  final Color textColor;
  final Color? linkColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final int? maxLines;

  @override
  State<LinkifiedText> createState() => _LinkifiedTextState();
}

class _LinkifiedTextState extends State<LinkifiedText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  static final RegExp _urlRegex = RegExp(
    r'((?:https?:\/\/|www\.)[^\s<>"]+)',
    caseSensitive: false,
  );

  Future<void> _open(String raw) async {
    var url = raw;
    if (url.startsWith('www.')) url = 'https://$url';
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final baseStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      color: widget.textColor,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
      height: widget.height,
    );
    final linkStyle = baseStyle.copyWith(
      color: widget.linkColor ?? colors.colorPrimary,
      decoration: TextDecoration.underline,
      decorationColor: widget.linkColor ?? colors.colorPrimary,
    );

    final matches = _urlRegex.allMatches(widget.text).toList();
    if (matches.isEmpty) {
      return Text(
        widget.text,
        style: baseStyle,
        maxLines: widget.maxLines,
        overflow: TextOverflow.clip,
      );
    }

    final spans = <InlineSpan>[];
    int cursor = 0;
    for (final m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(
          text: widget.text.substring(cursor, m.start),
          style: baseStyle,
        ));
      }
      final url = m.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _open(url);
      _recognizers.add(recognizer);
      spans.add(TextSpan(
        text: url,
        style: linkStyle,
        recognizer: recognizer,
      ));
      cursor = m.end;
    }
    if (cursor < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(cursor),
        style: baseStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: widget.maxLines,
      overflow: TextOverflow.clip,
    );
  }
}
