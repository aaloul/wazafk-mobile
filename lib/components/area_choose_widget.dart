import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/AreasResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'primary_text.dart';
import 'sheets/sheets_helper.dart';

class AreaChooseWidget extends StatelessWidget {
  const AreaChooseWidget({
    super.key,
    required this.selectedAreas,
    required this.onAreasChanged,
    this.enabled = true,
  });

  final RxList<AreaModel> selectedAreas;
  final Function(List<AreaModel>) onAreasChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "${context.resources.strings.areasYouCover}*",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: context.resources.color.colorGrey3,
        ),

        SizedBox(height: 12),

        Obx(() {
          if (selectedAreas.isEmpty) {
            return GestureDetector(
              onTap: enabled ? () {
                SheetHelper.showAreasSheet(
                  context,
                  selectedAreas: selectedAreas.toList(),
                  onAreasSelected: (areas) {
                    onAreasChanged(areas);
                  },
                );
              } : null,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(16),
                  color: context.resources.color.colorGrey2,
                  strokeWidth: 1,
                  dashPattern: [3, 3],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: enabled
                        ? context.resources.color.colorWhite
                        : context.resources.color.colorGrey4,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                        color: context.resources.color.colorGrey,
                      ),
                      PrimaryText(
                        text: context.resources.strings.add,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorGrey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selectedAreas.map(
                (area) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.resources.color.colorPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PrimaryText(
                        text: area.name ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: context.resources.color.colorWhite,
                      ),
                      if (enabled) ...[
                        SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            final updatedAreas = selectedAreas.toList();
                            updatedAreas.removeWhere((a) => a.code == area.code);
                            onAreasChanged(updatedAreas);
                          },
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: context.resources.color.colorWhite,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (enabled)
                GestureDetector(
                  onTap: () {
                    SheetHelper.showAreasSheet(
                      context,
                      selectedAreas: selectedAreas.toList(),
                      onAreasSelected: (areas) {
                        onAreasChanged(areas);
                      },
                    );
                  },
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(16),
                      color: context.resources.color.colorGrey2,
                      strokeWidth: 1,
                      dashPattern: [3, 3],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.resources.color.colorWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 14,
                            color: context.resources.color.colorGrey,
                          ),
                          PrimaryText(
                            text: context.resources.strings.add,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: context.resources.color.colorGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
