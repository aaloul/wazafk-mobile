import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/screens/main/book_service/components/select_date_calendar_widget.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../components/labeled_text_field.dart';
import '../../../components/multiline_labeled_text_field.dart';
import '../../../components/primary_network_image.dart';
import '../../../constants/route_constant.dart';
import '../../../model/LoginResponse.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/utils.dart';
import 'book_service_controller.dart';
import 'components/address_list_widget.dart';
import 'components/service_type_radio_widget.dart';
import 'components/verify_face_match_book_service_bottom_sheet.dart';

class BookServiceScreen extends StatelessWidget {
  const BookServiceScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookServiceController());

    return FocusDetector(
      onFocusGained: () {
        controller.fetchAddresses();
      },
      child: Scaffold(
        backgroundColor: context.resources.color.background2,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.service.value == null &&
                      controller.package.value == null) {
                    return Center(child: ProgressBar());
                  }

                  final title = controller.isPackage.value
                      ? controller.package.value!.title
                      : controller.service.value!.title;

                  final unitPrice = controller.isPackage.value
                      ? controller.package.value!.totalPrice
                      : controller.service.value!.pricingType.toString() == 'U'
                          ? controller.service.value!.unitPrice
                          : controller.service.value!.totalPrice;

                  final priceTitle = controller.isPackage.value
                      ? context.resources.strings.totalPrice
                      : controller.service.value!.pricingType.toString() == 'U'
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
                  final memberHashcode = controller.isPackage.value
                      ? controller.package.value!.memberHashcode
                      : controller.service.value!.memberHashcode;

                  final categoryName = controller.isPackage.value
                      ? (controller.package.value!.services != null &&
                              controller.package.value!.services!.isNotEmpty
                          ? controller
                              .package.value!.services!.first.categoryName
                          : context.resources.strings.package)
                      : controller.service.value!.categoryName;
                  final parentCategoryName = controller.isPackage.value
                      ? (controller.package.value!.services != null &&
                              controller.package.value!.services!.isNotEmpty
                          ? controller.package.value!.services!.first
                              .parentCategoryName
                          : null)
                      : controller.service.value!.parentCategoryName;

                  final categoryText = parentCategoryName != null
                      ? '$parentCategoryName / $categoryName'
                      : categoryName ?? '';

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns:
                                                Utils().isRTL() ? 2 : 0,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Image.asset(
                                                AppIcons.back3,
                                                width: 38,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: PrimaryText(
                                                text: Resources.of(context)
                                                    .strings
                                                    .booking,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: context.resources
                                                    .color.colorBlack,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 38),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: PrimaryText(
                                        text: title ?? '',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        textColor:
                                            context.resources.color.colorBlack,
                                      ),
                                    ),
                                    if (categoryText.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: PrimaryText(
                                          text: categoryText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor: context
                                              .resources.color.colorGrey,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Profile + Price row
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteConstant
                                              .employerMemberProfileScreen,
                                          arguments: User(
                                            hashcode:
                                                memberHashcode?.toString(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context
                                              .resources.color.colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: context
                                                .resources.color.colorPrimary,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: context.resources.color
                                                      .colorPrimary,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: PrimaryNetworkImage(
                                                  url: memberImage
                                                          ?.toString() ??
                                                      '',
                                                  width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: PrimaryText(
                                                text:
                                                    '${memberFirstName ?? ''}\n${memberLastName ?? ''}',
                                                fontSize: 12,
                                                maxLines: 2,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Image.asset(AppIcons.star2,
                                                width: 12),
                                            const SizedBox(width: 2),
                                            PrimaryText(
                                              text:
                                                  memberRating?.toString() ??
                                                      'N/A',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context
                                            .resources.color.colorPrimaryLight,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: PrimaryText(
                                        text: '$priceTitle: \$$unitPrice',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        maxLines: 2,
                                        textColor: context
                                            .resources.color.colorPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: _cardDecoration,
                                      child: SelectDateCalendarWidget(),
                                    ),

                                    const SizedBox(height: 16),

                                    Container(
                                      width: double.infinity,
                                      decoration: _cardDecoration,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ServiceTypeRadioWidget(),


                                      Obx(
                                            () => controller.selectedServiceType
                                            .value ==
                                            'Onsite' ||
                                            controller
                                                .selectedServiceType
                                                .value ==
                                                'Hybrid'
                                            ?  Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: context.resources.color.colorGrey.withAlpha(25),
                                            margin: EdgeInsets.symmetric(horizontal: 16),
                                          ) :   const SizedBox.shrink()),


                                          Obx(
                                            () => controller.selectedServiceType
                                                            .value ==
                                                        'Onsite' ||
                                                    controller
                                                            .selectedServiceType
                                                            .value ==
                                                        'Hybrid'
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            12, 8, 12, 12),
                                                    child: AddressListWidget(),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    Obx(
                                      () => !controller.isPackage.value &&
                                              controller.service.value
                                                      ?.pricingType
                                                      .toString() ==
                                                  'U'
                                          ? Column(
                                              children: [
                                                LabeledTextFiled(
                                                  controller: controller
                                                      .estimatedHoursController,
                                                  label: Resources.of(context)
                                                      .strings
                                                      .estimatedHours,
                                                  hint: Resources.of(context)
                                                      .strings
                                                      .enterEstimatedHours,
                                                  inputType:
                                                      TextInputType.number,
                                                  isPassword: false,
                                                  isMandatory: true,
                                                  allowDecimals: true,
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      decoration: _cardDecoration,
                                      padding: const EdgeInsets.all(12),
                                      child: MultilineLabeledTextField(
                                        controller: controller.notesController,
                                        label: Resources.of(context)
                                            .strings
                                            .messageToClient,
                                        hint: Resources.of(context)
                                            .strings
                                            .briefDescription,
                                        maxLines: 20,
                                        height: 100,
                                        labelFontSize: 14,
                                        margin: 0,
                                        labelFontWeight: FontWeight.w600,
                                        labelColor: context.resources.color.colorBlack4,
                                        inputType: TextInputType.text,
                                        isPassword: false,
                                        isMandatory: false,
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(
                          () => controller.isLoading.value
                              ? ProgressBar()
                              : PrimaryButton(
                                  title:
                                      Resources.of(context).strings.request,
                                  onPressed: () {
                                    if (controller.service.value == null &&
                                        controller.package.value == null) {
                                      constants.showSnackBar(
                                        Resources.of(context)
                                            .strings
                                            .servicePackageInformationNotAvailable,
                                        SnackBarStatus.ERROR,
                                      );
                                      return;
                                    }

                                    if (controller.rangeStart.value == null) {
                                      constants.showSnackBar(
                                        Resources.of(context)
                                            .strings
                                            .pleaseSelectDateRange,
                                        SnackBarStatus.ERROR,
                                      );
                                      return;
                                    }

                                    if (controller.selectedServiceType.value ==
                                        null) {
                                      constants.showSnackBar(
                                        Resources.of(context)
                                            .strings
                                            .pleaseSelectServiceType,
                                        SnackBarStatus.ERROR,
                                      );
                                      return;
                                    }

                                    if (!controller.isPackage.value &&
                                        controller.service.value?.pricingType
                                                .toString() ==
                                            'U' &&
                                        controller.estimatedHoursController
                                            .text
                                            .trim()
                                            .isEmpty) {
                                      constants.showSnackBar(
                                        Resources.of(context)
                                            .strings
                                            .enterEstimatedHours,
                                        SnackBarStatus.ERROR,
                                      );
                                      return;
                                    }

                                    if ((controller.selectedServiceType
                                                    .value ==
                                                'Onsite' ||
                                            controller.selectedServiceType
                                                    .value ==
                                                'Hybrid') &&
                                        controller.selectedAddress.value ==
                                            null) {
                                      constants.showSnackBar(
                                        Resources.of(context)
                                            .strings
                                            .pleaseSelectLocation,
                                        SnackBarStatus.ERROR,
                                      );
                                      return;
                                    }

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
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
