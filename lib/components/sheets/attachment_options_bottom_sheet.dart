import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

enum AttachmentType {
  camera,
  gallery,
  video,
  document,
  file,
  location,
}

class AttachmentOptionsBottomSheet {
  static Future<AttachmentType?> show(BuildContext context) async {
    return await showModalBottomSheet<AttachmentType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.resources.color.colorGrey2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Option(
                      icon: AppIcons.attachGallery,
                      label: Resources.of(context).strings.gallery,
                      onTap: () =>
                          Navigator.pop(context, AttachmentType.gallery),
                    ),
                    _Option(
                      icon: AppIcons.attachFile,
                      label: Resources.of(context).strings.file,
                      onTap: () => Navigator.pop(context, AttachmentType.file),
                    ),
                    _Option(
                      icon: AppIcons.attachLocation,
                      label: Resources.of(context).strings.location,
                      onTap: () =>
                          Navigator.pop(context, AttachmentType.location),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.colorWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.colorGrey4, width: 1),
            ),
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          PrimaryText(
            text: label,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            textColor: colors.colorGrey,
          ),
        ],
      ),
    );
  }
}
