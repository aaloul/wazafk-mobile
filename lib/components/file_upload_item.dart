import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../../../../components/primary_text.dart';

class FileUploadItem extends StatelessWidget {
  const FileUploadItem({
    super.key,
    required this.label,
    required this.onClick,
    required this.isMandatory,
    required this.isOptional,
    this.imagePath,
    this.isPdf = false,
  });

  final String label;
  final Function onClick;
  final bool isMandatory;
  final bool isOptional;
  final String? imagePath;
  final bool isPdf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PrimaryText(
              text: label,
              textColor: context.resources.color.colorGrey3,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            const SizedBox(width: 1),
            if (isMandatory)
              PrimaryText(
                text: '*',
                textColor: context.resources.color.colorGrey3,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            if (isOptional ?? false)
              Flexible(
                child: PrimaryText(
                  text: '(optional)',
                  textColor: context.resources.color.colorGrey3,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () => onClick(),
          child: Container(
            color: context.resources.color.background,
            width: double.infinity,
            height: 80,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: context.resources.color.colorGrey2,
                strokeWidth: 1,
                dashPattern: [8, 4],
                radius: Radius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: imagePath != null
                    ? (isPdf
                          ? Center(
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: context.resources.color.colorPrimary,
                                size: 48,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.insert_drive_file,
                                      color: context.resources.color.colorGrey,
                                      size: 48,
                                    ),
                                  );
                                },
                              ),
                            ))
                    : Center(
                        child: Image.asset(
                          AppIcons.upload,
                          width: 32,
                          height: 32,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
