import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

enum AttachmentType {
  camera,
  gallery,
  video,
  document,
  file,
}

class AttachmentOptionsBottomSheet {
  static Future<AttachmentType?> show(BuildContext context) async {
    return await showModalBottomSheet<AttachmentType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.resources.color.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.resources.color.colorGrey8,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),

              // Title
              PrimaryText(
                text: Resources.of(context).strings.selectAttachment,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorPrimary,
              ),

              SizedBox(height: 20),

              // Options grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildOption(
                      context,
                      icon: Icons.camera_alt,
                      label: Resources.of(context).strings.camera,
                      color: Colors.blue,
                      onTap: () => Navigator.pop(context, AttachmentType.camera),
                    ),
                    _buildOption(
                      context,
                      icon: Icons.photo_library,
                      label: Resources.of(context).strings.gallery,
                      color: Colors.purple,
                      onTap: () => Navigator.pop(context, AttachmentType.gallery),
                    ),
                    _buildOption(
                      context,
                      icon: Icons.videocam,
                      label: Resources.of(context).strings.video,
                      color: Colors.red,
                      onTap: () => Navigator.pop(context, AttachmentType.video),
                    ),
                    _buildOption(
                      context,
                      icon: Icons.description,
                      label: Resources.of(context).strings.document,
                      color: Colors.orange,
                      onTap: () => Navigator.pop(context, AttachmentType.document),
                    ),
                    _buildOption(
                      context,
                      icon: Icons.insert_drive_file,
                      label: Resources.of(context).strings.file,
                      color: Colors.green,
                      onTap: () => Navigator.pop(context, AttachmentType.file),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            PrimaryText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
