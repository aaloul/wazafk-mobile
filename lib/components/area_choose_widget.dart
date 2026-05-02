import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/model/AreasResponse.dart';
import 'package:wazafak_app/repository/app/areas_repository.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'primary_text.dart';
import 'progress_bar.dart';

class AreaChooseWidget extends StatefulWidget {
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
  State<AreaChooseWidget> createState() => _AreaChooseWidgetState();
}

class _AreaChooseWidgetState extends State<AreaChooseWidget> {
  final AreasRepository _repo = AreasRepository();
  List<AreaModel> _areas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final response = await _repo.getAreas();
      if (mounted && response.success == true && response.data != null) {
        setState(() {
          _areas = response.data!;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggle(AreaModel area) {
    final updated = widget.selectedAreas.toList();
    final exists = updated.any((a) => a.code == area.code);
    if (exists) {
      updated.removeWhere((a) => a.code == area.code);
    } else {
      updated.add(area);
    }
    widget.onAreasChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          text: "${context.resources.strings.areasYouCover} *",
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textColor: context.resources.color.colorGrey26,
        ),
        SizedBox(height: 8),
        if (_isLoading)
          Center(child: ProgressBar())
        else if (_areas.isEmpty)
          PrimaryText(
            text: context.resources.strings.noAreasAvailable,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey,
          )
        else
          Obx(() {
            final selectedCodes =
                widget.selectedAreas.map((a) => a.code).toSet();
            return SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _areas.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final area = _areas[index];
                  final isSelected = selectedCodes.contains(area.code);
                  return GestureDetector(
                    onTap: widget.enabled ? () => _toggle(area) : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.resources.color.colorPrimary
                                .withAlpha(16)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? context.resources.color.colorPrimary
                              : context.resources.color.colorGrey25,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: PrimaryText(
                          text: area.name ?? '',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: isSelected
                              ? context.resources.color.colorPrimary
                              : context.resources.color.colorBlack4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
      ],
    );
  }
}
