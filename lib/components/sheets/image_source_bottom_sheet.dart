import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class ImageSourceBottomSheet {
  static Future<XFile?> show(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
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
                text: Resources.of(context).strings.selectImageSource,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: context.resources.color.colorPrimary,
              ),

              SizedBox(height: 20),

              // Camera option
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary.withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: context.resources.color.colorPrimary,
                    size: 24,
                  ),
                ),
                title: PrimaryText(
                  text: Resources.of(context).strings.camera,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: context.resources.color.colorPrimary,
                ),
                subtitle: PrimaryText(
                  text: Resources.of(context).strings.takeANewPhoto,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey,
                ),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),

              Divider(
                height: 1,
                color: context.resources.color.colorGrey8,
                indent: 16,
                endIndent: 16,
              ),

              // Gallery option
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary.withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: context.resources.color.colorPrimary,
                    size: 24,
                  ),
                ),
                title: PrimaryText(
                  text: Resources.of(context).strings.gallery,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: context.resources.color.colorPrimary,
                ),
                subtitle: PrimaryText(
                  text: Resources.of(context).strings.chooseFromGallery,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey,
                ),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),

              SizedBox(height: 10),

              // Cancel button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: context.resources.color.colorGrey8
                        .withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: PrimaryText(
                    text: Resources.of(context).strings.cancel,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey,
                  ),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    if (source == null) return null;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }
}
