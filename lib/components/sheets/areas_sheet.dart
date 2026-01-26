import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/model/AreasResponse.dart';
import 'package:wazafak_app/repository/app/areas_repository.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

class AreasSheet extends StatefulWidget {
  final List<AreaModel> selectedAreas;
  final Function(List<AreaModel>) onAreasSelected;

  const AreasSheet({
    super.key,
    required this.selectedAreas,
    required this.onAreasSelected,
  });

  @override
  State<AreasSheet> createState() => _AreasSheetState();
}

class _AreasSheetState extends State<AreasSheet> {
  late List<AreaModel> tempSelectedAreas;
  final AreasRepository _areasRepository = AreasRepository();
  List<AreaModel> areas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tempSelectedAreas = List.from(widget.selectedAreas);
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final response = await _areasRepository.getAreas();
      if (response.success == true && response.data != null) {
        setState(() {
          areas = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching areas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isAreaSelected(AreaModel area) {
    return tempSelectedAreas.any((a) => a.code == area.code);
  }

  void toggleAreaSelection(AreaModel area) {
    setState(() {
      if (isAreaSelected(area)) {
        tempSelectedAreas.removeWhere((a) => a.code == area.code);
      } else {
        tempSelectedAreas.add(area);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: context.resources.color.background2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryText(
                  text: Resources.of(context).strings.selectAreas,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  textColor: context.resources.color.colorGrey,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: context.resources.color.colorGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: ProgressBar())
                  : areas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 48,
                                color: context.resources.color.colorGrey8,
                              ),
                              SizedBox(height: 8),
                              PrimaryText(
                                text: Resources.of(context).strings.noAreasAvailable,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: context.resources.color.colorGrey8,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: areas.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final area = areas[index];
                            final isSelected = isAreaSelected(area);
                            return GestureDetector(
                              onTap: () => toggleAreaSelection(area),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? context.resources.color.colorPrimary
                                          .withOpacity(0.1)
                                      : context.resources.color.colorWhite,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.resources.color.colorPrimary
                                        : context.resources.color.colorGrey2,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryText(
                                        text: area.name ?? '',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        textColor: isSelected
                                            ? context
                                                .resources.color.colorPrimary
                                            : context.resources.color.colorGrey,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color:
                                            context.resources.color.colorPrimary,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  PrimaryButton(
                    title: Resources.of(context).strings.apply,
                    onPressed: () {
                      widget.onAreasSelected(tempSelectedAreas);
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
