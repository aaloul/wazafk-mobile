import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

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
        if(label.isNotEmpty)
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
        if(label.isNotEmpty)
          const SizedBox(height: 8),

        GestureDetector(
          onTap: () => onClick(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFECEFF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (imagePath != null)
                  Expanded(
                    child: isPdf
                        ? Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: context.resources.color.colorPrimary,
                                size: 32,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: PrimaryText(
                                  text: imagePath!.split('/').last,
                                  fontSize: 12,
                                  maxLines: 1,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: context.resources.color.colorGrey,
                                    size: 32,
                                  ),
                            ),
                          ),
                  )
                else
                  Expanded(child: SizedBox.shrink()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      PrimaryText(
                        text: context.resources.strings.chooseFile,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
