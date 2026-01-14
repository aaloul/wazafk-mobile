import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/screens/main/book_service/components/select_date_calendar_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/multiline_labeled_text_field.dart';
import '../../../components/primary_network_image.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/utils.dart';
import 'book_service_controller.dart';
import 'components/address_list_widget.dart';
import 'components/service_type_radio_widget.dart';
import 'components/verify_face_match_book_service_bottom_sheet.dart';

class BookServiceScreen extends StatelessWidget {
  const BookServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookServiceController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchAddresses();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background,
        body: SafeArea(
          child: Column(
            children: [
              TopHeader(
                hasBack: true,
                title: Resources.of(context).strings.booking,
              ),
              SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Information Section
                      SizedBox(
                        width: double.infinity,

                        child: Obx(() {
                          if (controller.service.value == null &&
                              controller.package.value == null) {
                            return Center(child: ProgressBar());
                          }

                          // Get data from either service or package
                          final title = controller.isPackage.value
                              ? controller.package.value!.title
                              : controller.service.value!.title;
                          final unitPrice = controller.isPackage.value
                              ? controller.package.value!.totalPrice
                              :
                          controller.service.value!.pricingType
                                        .toString() ==
                                    'U'
                              ? controller.service.value!.unitPrice
                              : controller.service.value!.totalPrice;

                          final priceTitle = controller.isPackage.value
                              ? context.resources.strings.totalPrice
                              : controller.service.value!.pricingType
                                        .toString() ==
                                    'U'
                              ? context.resources.strings.hourlyRate
                              : context.resources.strings.totalPrice;

                          final memberFirstName = controller.isPackage.value
                              ? controller.package.value!.memberFirstName
                              : controller.service.value!.memberFirstName;
                          final memberLastName = controller.isPackage.value
                              ? controller.package.value!.memberLastName
                              : controller.service.value!.memberLastName;
                          final memberImage = controller.isPackage.value
                              ? controller.package.value!.memberImage
                              : controller.service.value!.memberImage;
                          final memberRating = controller.isPackage.value
                              ? controller.package.value!.memberRating
                              : controller.service.value!.memberRating;
                          final categoryName = controller.isPackage.value
                              ? (controller.package.value!.services != null &&
                                        controller
                                            .package
                                            .value!
                                            .services!
                                            .isNotEmpty
                                    ? controller
                                          .package
                                          .value!
                                          .services!
                                          .first
                                          .categoryName
                                    : context.resources.strings.package)
                              : controller.service.value!.categoryName;
                          final parentCategoryName = controller.isPackage.value
                              ? (controller.package.value!.services != null &&
                                        controller
                                            .package
                                            .value!
                                            .services!
                                            .isNotEmpty
                                    ? controller
                                          .package
                                          .value!
                                          .services!
                                          .first
                                          .parentCategoryName
                                    : null)
                              : controller.service.value!.parentCategoryName;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: context.resources.color.colorBlue4,
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(
                                            text: title ?? '',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            children: [
                                              if (parentCategoryName != null)
                                                Expanded(
                                                  child: PrimaryText(
                                                    text:
                                                        "$parentCategoryName/$categoryName",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    textColor: context
                                                        .resources
                                                        .color
                                                        .colorGrey,
                                                  ),
                                                ),
                                              if (parentCategoryName == null)
                                                PrimaryText(
                                                  text: categoryName ?? '',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text: '${unitPrice}\$',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                        SizedBox(height: 2),
                                        PrimaryText(
                                          text: priceTitle,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                color: context.resources.color.colorBlue4,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        99999,
                                      ),
                                      child: PrimaryNetworkImage(
                                        url: memberImage.toString(),
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),

                                    SizedBox(width: 8),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(
                                            text:
                                                "$memberFirstName $memberLastName",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey,
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppIcons.star2,
                                                width: 14,
                                              ),
                                              SizedBox(width: 2),
                                              PrimaryText(
                                                text: memberRating.toString(),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),

                      SizedBox(height: 20),

                      SelectDateCalendarWidget(),

                      SizedBox(height: 16),

                      // Work Location Type Section
                      ServiceTypeRadioWidget(),

                      SizedBox(height: 16),

                      // Show estimated hours field only when service pricing type is U
                      Obx(
                        () => !controller.isPackage.value &&
                                controller.service.value?.pricingType.toString() == 'U'
                            ? Column(
                                children: [
                                  LabeledTextFiled(
                                    controller: controller.estimatedHoursController,
                                    label: Resources.of(context).strings.estimatedHours,
                                    hint: Resources.of(context).strings.enterEstimatedHours,
                                    inputType: TextInputType.number,
                                    isPassword: false,
                                    isMandatory: true,
                                    allowDecimals: true,
                                  ),
                                  SizedBox(height: 16),
                                ],
                              )
                            : SizedBox.shrink(),
                      ),

                      // Show address selection only when Onsite is selected
                      Obx(
                        () =>
                            controller.selectedServiceType.value == 'Onsite' ||
                                controller.selectedServiceType.value == 'Hybrid'
                            ? Column(
                                children: [
                                  AddressListWidget(),
                                  SizedBox(height: 24),
                                ],
                              )
                            : SizedBox(height: 8),
                      ),

                      // Notes Section

                      // Description
                      MultilineLabeledTextField(
                        controller: controller.notesController,
                        label: Resources.of(context).strings.messageToClient,
                        hint: Resources.of(context).strings.briefDescription,
                        maxLines: 20,
                        height: 100,
                        labelFontSize: 14,
                        margin: 0,
                        labelFontWeight: FontWeight.w500,
                        inputType: TextInputType.text,
                        isPassword: false,
                        isMandatory: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: EdgeInsets.all(16),
                child: Obx(
                  () => controller.isLoading.value
                      ? ProgressBar()
                      : PrimaryButton(
                          title: Resources.of(context).strings.bookNow,
                          onPressed: () {
                            if (controller.service.value == null &&
                                controller.package.value == null) {
                              constants.showSnackBar(
                                Resources.of(context).strings.servicePackageInformationNotAvailable,
                                SnackBarStatus.ERROR,
                              );
                              return;
                            }

                            if (controller.rangeStart.value == null) {
                              constants.showSnackBar(
                                Resources.of(context).strings.pleaseSelectDateRange,
                                SnackBarStatus.ERROR,
                              );
                              return;
                            }

                            if (controller.selectedServiceType.value == null) {
                              constants.showSnackBar(
                                Resources.of(context).strings.pleaseSelectServiceType,
                                SnackBarStatus.ERROR,
                              );
                              return;
                            }

                            // Validate estimated hours for service with pricing type U
                            if (!controller.isPackage.value &&
                                controller.service.value?.pricingType.toString() == 'U' &&
                                controller.estimatedHoursController.text.trim().isEmpty) {
                              constants.showSnackBar(
                                Resources.of(context).strings.enterEstimatedHours,
                                SnackBarStatus.ERROR,
                              );
                              return;
                            }

                            // Validate address only for Onsite service type
                            if ((controller.selectedServiceType.value ==
                                        'Onsite' ||
                                    controller.selectedServiceType.value ==
                                        'Hybrid') &&
                                controller.selectedAddress.value == null) {
                              constants.showSnackBar(
                                Resources.of(context).strings.pleaseSelectLocation,
                                SnackBarStatus.ERROR,
                              );
                              return;
                            }

                            // Open face verification bottom sheet
                            Get.bottomSheet(
                              VerifyFaceMatchBookServiceBottomSheet(),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
