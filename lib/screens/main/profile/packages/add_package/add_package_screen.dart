import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/category_chooser.dart';
import 'package:wazafak_app/components/form_choice_chip.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
import 'package:wazafak_app/screens/main/profile/packages/add_package/add_package_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

/// Work package form — design p113 ("Work Package") and p115 ("Edit").
class AddPackageScreen extends StatelessWidget {
  const AddPackageScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
    boxShadow: [
      BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset.zero),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPackageController());
    final homeController = Get.find<HomeController>();
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? strings.editPackageTitle
                    : strings.workPackageTitle,
                endWidget: controller.isEditMode.value
                    ? const _PackageStatusToggle()
                    : null,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Container(
                  width: double.infinity,
                  decoration: _cardDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledTextFiled(
                          controller: controller.titleController,
                          hint: strings.title,
                          label: strings.title,
                          isMandatory: true,
                          isPassword: false,
                          labelFontSize: 12,
                          inputType: TextInputType.text,
                        ),

                        const SizedBox(height: 10),

                        // Services the pack bundles — multi-select.
                        FormFieldLabel(text: strings.services, isMandatory: true),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (controller.isLoadingServices.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: ProgressBar()),
                            );
                          }
                          if (controller.services.isEmpty) {
                            return PrimaryText(
                              text: strings.noServicesAvailable,
                              fontSize: 13,
                              textColor: colors.colorGrey8,
                            );
                          }
                          final selectedHashcodes = controller.selectedServices
                              .map((s) => s.hashcode)
                              .toSet();
                          // Cap each chip at half the row so long service
                          // titles ellipsize and the chips keep wrapping in
                          // columns instead of stacking one per line.
                          return LayoutBuilder(
                            builder: (context, box) {
                              final maxChipWidth = (box.maxWidth - 6) / 2;
                              return Wrap(
                                spacing: 6,
                                runSpacing: 8,
                                children: controller.services
                                    .map(
                                      (service) => FormChoiceChip(
                                        label: service.title ?? '',
                                        selected: selectedHashcodes
                                            .contains(service.hashcode),
                                        maxWidth: maxChipWidth,
                                        onTap: () => controller
                                            .toggleServiceSelection(service),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          );
                        }),

                        const SizedBox(height: 16),

                        // Category dropdown + subcategory chips.
                        Obx(() {
                          if (homeController.categories.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: ProgressBar()),
                            );
                          }
                          return CategoryChooser(
                            label: strings.category,
                            text: strings.selectCategory,
                            isMandatory: true,
                            withArrow: true,
                            labelFontSize: 12,
                            list: homeController.categories,
                            selected: controller.selectedCategory.value,
                            onSelect: controller.selectCategory,
                          );
                        }),

                        Obx(() {
                          if (controller.isLoadingSubcategories.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: ProgressBar()),
                            );
                          }
                          if (controller.subcategories.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final selectedHashcode =
                              controller.selectedSubcategory.value?.hashcode;
                          return SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.subcategories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 6),
                              itemBuilder: (context, index) {
                                final sub = controller.subcategories[index];
                                return FormChoiceChip(
                                  label: sub.name ?? '',
                                  selected: selectedHashcode == sub.hashcode,
                                  onTap: () =>
                                      controller.selectSubcategory(sub),
                                );
                              },
                            ),
                          );
                        }),

                        const SizedBox(height: 16),

                        FormFieldLabel(
                          text: strings.amountRequiredForPackage,
                          isMandatory: true,
                        ),
                        const SizedBox(height: 8),
                        PrimaryTextField(
                          controller: controller.totalPriceController,
                          hint: strings.amountInUsd,
                          inputType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        const _PackageLocationRow(),

                        const SizedBox(height: 16),

                        MultilineLabeledTextField(
                          controller: controller.descController,
                          label: strings.description,
                          hint: strings.packDescriptionHint,
                          maxLines: 20,
                          height: 120,
                          margin: 0,
                          labelFontSize: 12,
                          inputType: TextInputType.text,
                          isPassword: false,
                          isMandatory: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => controller.isLoading.value
                    ? ProgressBar()
                    : PrimaryButton(
                        title: controller.isEditMode.value
                            ? strings.save
                            : strings.postWorkPackage,
                        onPressed: controller.addPackage,
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// "Location" — Remote / On-site chips (design p113). Hybrid only shows up
/// when an existing hybrid pack is open.
class _PackageLocationRow extends StatelessWidget {
  const _PackageLocationRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPackageController>();
    final strings = context.resources.strings;

    return Obx(() {
      final selected = controller.selectedWorkLocationType.value;
      final types = <String>[
        'Remote',
        'Onsite',
        if (selected == 'Hybrid') 'Hybrid',
      ];

      String label(String type) {
        switch (type) {
          case 'Remote':
            return strings.remote;
          case 'Hybrid':
            return strings.hybrid;
          default:
            return strings.onSite;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(text: strings.location),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final type in types) ...[
                  FormChoiceChip(
                    label: label(type),
                    selected: selected == type,
                    minWidth: 80,
                    onTap: () =>
                        controller.selectedWorkLocationType.value = type,
                  ),
                  if (type != types.last) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// Off / On segmented switch in the edit header (design p115).
class _PackageStatusToggle extends StatelessWidget {
  const _PackageStatusToggle();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPackageController>();
    final colors = context.resources.color;
    final strings = context.resources.strings;

    return Obx(() {
      final isActive = controller.isPackageActive.value;
      Widget segment(String label, bool active) {
        return GestureDetector(
          onTap: () => controller.setPackageActive(active),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isActive == active ? colors.colorWhite : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive == active
                    ? colors.colorPrimary
                    : Colors.transparent,
              ),
            ),
            child: PrimaryText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              textColor:
                  isActive == active ? colors.colorPrimary : colors.colorGrey8,
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colors.colorGrey4,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment(strings.offLabel, false),
            segment(strings.onLabel, true),
          ],
        ),
      );
    });
  }
}
