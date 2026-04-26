import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/file_upload_item.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../constants/route_constant.dart';
import '../../../model/LoginResponse.dart';
import '../../../utils/res/AppIcons.dart';
import '../../../utils/res/Resources.dart';
import '../../../utils/utils.dart';
import 'apply_job_controller.dart';
import 'components/apply_job_header.dart';
import 'components/verify_face_match_apply_job_bottom_sheet.dart';

class ApplyJobScreen extends StatelessWidget {
  const ApplyJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplyJobController());

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Obx(() {
          final job = controller.job.value;

          return Column(
            children: [
              job == null
                  ? Center(
                      child: PrimaryText(
                        text: context.resources.strings.jobDetailsNotAvailable,
                        fontSize: 14,
                        textColor: context.resources.color.colorGrey,
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ApplyJobHeader(job: controller.job.value!),

                            SizedBox(height: 20),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Employer info + price
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context
                                              .resources
                                              .color
                                              .colorWhite,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: context
                                                .resources
                                                .color
                                                .colorPrimary,
                                            width: 1,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (job.memberHashcode != null) {
                                              Get.toNamed(
                                                RouteConstant
                                                    .employerMemberProfileScreen,
                                                arguments: User(
                                                  hashcode: job.memberHashcode,
                                                  image: job.memberImage,
                                                  firstName:
                                                      job.memberFirstName,
                                                  lastName: job.memberLastName,
                                                  title: '',
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorPrimary,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  child: PrimaryNetworkImage(
                                                    url: job.memberImage
                                                        .toString(),
                                                    width: 35,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 6),

                                              PrimaryText(
                                                text:
                                                    '${job.memberFirstName} ${job.memberLastName}',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(width: 2),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    AppIcons.star2,
                                                    width: 12,
                                                  ),
                                                  SizedBox(width: 1),
                                                  PrimaryText(
                                                    text:
                                                        job.memberRating ??
                                                        'N/A',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimaryLight,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: PrimaryText(
                                          text:
                                              'Payment: \$${job.totalPrice ?? '0'}',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),

                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE5E5E5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (job.description != null &&
                                            job.description!.isNotEmpty) ...[
                                          PrimaryText(
                                            text:
                                                context.resources.strings.about,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorBlack,
                                          ),
                                          SizedBox(height: 4),
                                          PrimaryText(
                                            text: job.description!,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey31,
                                          ),
                                          SizedBox(height: 16),
                                        ],

                                        PrimaryText(
                                          text: context
                                              .resources
                                              .strings
                                              .responsibilities,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorBlack,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text:
                                              job.responsibilities ??
                                              context
                                                  .resources
                                                  .strings
                                                  .notAvailable,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey31,
                                        ),

                                        SizedBox(height: 16),

                                        PrimaryText(
                                          text: context
                                              .resources
                                              .strings
                                              .requirements,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorBlack,
                                        ),
                                        SizedBox(height: 4),
                                        PrimaryText(
                                          text:
                                              job.requirememts ??
                                              context
                                                  .resources
                                                  .strings
                                                  .notAvailable,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          textColor: context
                                              .resources
                                              .color
                                              .colorGrey31,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF358DED),
                                    Color.fromRGBO(60, 160, 237, 0.23),
                                  ],
                                  stops: [0.0438, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.resources.color.colorWhite,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 55,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  12,
                                                ),
                                            child: Image.asset(
                                              height: 55,
                                              AppIcons.applyBg,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),

                                          Positioned.fill(
                                            child: Container(
                                              margin: EdgeInsets.all(12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  PrimaryText(
                                                    text: context
                                                        .resources
                                                        .strings
                                                        .applyNow,
                                                    textColor: context
                                                        .resources
                                                        .color
                                                        .colorWhite,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),

                                                  Image.asset(
                                                    AppIcons.logo,
                                                    width: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 16),

                                          PrimaryText(
                                            text: context
                                                .resources
                                                .strings
                                                .amountRequiredForThisJob,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorBlack,
                                          ),
                                          SizedBox(height: 10),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: PrimaryTextField(
                                                  controller: controller
                                                      .budgetController,
                                                  hint: context
                                                      .resources
                                                      .strings
                                                      .amountInUsd,
                                                  fontSize: 12,
                                                  inputType:
                                                      TextInputType.number,
                                                  backgroundColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey28,
                                                  borderColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey28,
                                                  hintColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey7,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              PrimaryText(
                                                text: context
                                                    .resources
                                                    .strings
                                                    .perProject,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorPrimary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          PrimaryText(
                                            text:
                                                '${context.resources.strings.clientRequested}  \$${job.totalPrice ?? '0'}',
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey29,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),

                                          SizedBox(height: 16),

                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          10,
                                                        ),
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorPrimary,
                                                  ),
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: PrimaryText(
                                                              text: context
                                                                  .resources
                                                                  .strings
                                                                  .profit,
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              textColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorWhite,
                                                            ),
                                                          ),

                                                          Image.asset(AppIcons.netProfit,width: 23,)
                                                        ],
                                                      ),

                                                      PrimaryText(
                                                        text: context
                                                            .resources
                                                            .strings
                                                            .youllReceive,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        textColor: context
                                                            .resources
                                                            .color
                                                            .colorWhite,
                                                      ),

                                                      Container(
                                                        width: double.infinity,
                                                        height: 1,
                                                        color: context.resources.color.colorWhite.withAlpha(50),
                                                        margin: EdgeInsets.symmetric(vertical: 6),
                                                      ),
                                                      Obx(
                                                        () => PrimaryText(
                                                          text:
                                                              '${controller.youllReceive.value.toStringAsFixed(2)} \$',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          textColor: context
                                                              .resources
                                                              .color
                                                              .colorWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      10,
                                                    ),
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorGrey28,
                                                  ),
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: PrimaryText(
                                                              text: context
                                                                  .resources
                                                                  .strings
                                                                  .applicationCommissionFees,
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              textColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorBlack,
                                                            ),
                                                          ),

                                                          Image.asset(AppIcons.commission,width: 20,)
                                                        ],
                                                      ),

                                                      PrimaryText(
                                                        text:
                                                        '${controller.job.value?.commissionFees}% ${context.resources.strings.ofProfit}',

                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        textColor: context
                                                            .resources
                                                            .color
                                                            .colorPrimary,
                                                      ),

                                                      Container(
                                                        width: double.infinity,
                                                        height: 1,
                                                        color: context.resources.color.colorBlack.withAlpha(30),
                                                        margin: EdgeInsets.symmetric(vertical: 6),
                                                      ),
                                                      Obx(
                                                            () => PrimaryText(
                                                          text:
                                                          '${controller.applicationFees.value.toStringAsFixed(2)} \$',
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          textColor: context
                                                              .resources
                                                              .color
                                                              .colorBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Expanded(
                                              //   flex: 1,
                                              //   child: Container(
                                              //     decoration: BoxDecoration(
                                              //       borderRadius:
                                              //           BorderRadiusGeometry.circular(
                                              //             10,
                                              //           ),
                                              //       color: context
                                              //           .resources
                                              //           .color
                                              //           .colorGrey28,
                                              //     ),
                                              //     padding: EdgeInsets.all(16),
                                              //     child: Column(
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment
                                              //               .start,
                                              //       children: [
                                              //         PrimaryText(
                                              //           text:
                                              //               "${controller.job.value?.commissionFees}% ${context.resources.strings.applicationCommissionFees}",
                                              //           fontSize: 14,
                                              //           fontWeight:
                                              //               FontWeight.w900,
                                              //           textColor: context
                                              //               .resources
                                              //               .color
                                              //               .colorGrey,
                                              //         ),
                                              //         SizedBox(height: 8),
                                              //         Obx(
                                              //           () => PrimaryText(
                                              //             text:
                                              //                 '${controller.applicationFees.value.toStringAsFixed(2)} \$',
                                              //             fontSize: 14,
                                              //             fontWeight:
                                              //                 FontWeight.w900,
                                              //             textColor: context
                                              //                 .resources
                                              //                 .color
                                              //                 .colorGrey,
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),


                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: context.resources.color.colorGrey20,
                                            margin: EdgeInsets.symmetric(vertical: 16),
                                          ),



                                          PrimaryText(
                                            text: context
                                                .resources
                                                .strings
                                                .attachments,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorBlack,
                                          ),

                                          SizedBox(height: 8),

                                          Obx(
                                                () => FileUploadItem(
                                              label:'',
                                              isMandatory: true,
                                              isOptional: false,
                                              onClick: () {
                                                controller.pickCV(context);
                                              },
                                              imagePath:
                                              controller.cvFile.value?.path,
                                              isPdf: true,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          PrimaryText(
                                            text: context
                                                .resources
                                                .strings
                                                .maxFileSizeNote,
                                            textColor: context
                                                .resources
                                                .color
                                                .colorGrey29,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),

                                          Obx(() {
                                            if (controller.cvFile.value ==
                                                null) {
                                              return SizedBox.shrink();
                                            }

                                            return Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: DottedBorder(
                                                options:
                                                    RoundedRectDottedBorderOptions(
                                                      radius:
                                                          Radius.circular(10),
                                                      color: context
                                                          .resources
                                                          .color
                                                          .colorPrimary,
                                                      strokeWidth: 1.5,
                                                      dashPattern: [6.0, 4.0],
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .colorWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorPrimary
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Icon(
                                                          controller
                                                              .getFileIcon(),
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorPrimary,
                                                          size: 32,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            PrimaryText(
                                                              text:
                                                                  controller
                                                                      .cvFileName
                                                                      .value ??
                                                                  'CV.pdf',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              textColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorGrey,
                                                              maxLines: 1,
                                                            ),
                                                            SizedBox(height: 4),
                                                            PrimaryText(
                                                              text: controller
                                                                          .cvFileSize
                                                                          .value !=
                                                                      null
                                                                  ? controller
                                                                      .getFormattedFileSize(
                                                                        controller
                                                                            .cvFileSize
                                                                            .value!,
                                                                      )
                                                                  : '',
                                                              fontSize: 12,
                                                              textColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorGrey
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.close,
                                                          color: context
                                                              .resources
                                                              .color
                                                              .colorPrimary,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {
                                                          controller.removeCv();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),

                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: context.resources.color.colorGrey20,
                                            margin: EdgeInsets.symmetric(vertical: 16),
                                          ),


                                          MultilineLabeledTextField(
                                            controller: controller
                                                .descriptionController,
                                            label: context
                                                .resources
                                                .strings
                                                .messageToEmployer,
                                            hint: context
                                                .resources
                                                .strings
                                                .briefDescriptionSuitableCandidate,
                                            labelColor: context.resources.color.colorBlack,
                                            maxLines: 20,
                                            textColor: context.resources.color.colorGrey7,
                                            hintTextColor: context.resources.color.colorGrey7,
                                            background: context.resources.color.colorGrey28,
                                            borderColor: context.resources.color.colorGrey28,

                                            height: 100,
                                            labelFontSize: 14,
                                            margin: 0,
                                            labelFontWeight: FontWeight.w600,
                                            inputType: TextInputType.text,
                                            isPassword: false,
                                            isMandatory: true,
                                          ),


                                          SizedBox(height: 24),

                                          Obx(() {
                                            if (controller.isLoading.value) {
                                              return Center(
                                                child: ProgressBar(),
                                              );
                                            }

                                            return PrimaryButton(
                                              title: context
                                                  .resources
                                                  .strings
                                                  .submitApplication,
                                              onPressed: () {
                                                if (controller
                                                    .budgetController
                                                    .text
                                                    .trim()
                                                    .isEmpty) {
                                                  constants.showSnackBar(
                                                    Resources.of(Get.context!)
                                                        .strings
                                                        .pleaseEnterYourBudget,
                                                    SnackBarStatus.ERROR,
                                                  );
                                                  return;
                                                }

                                                if (controller
                                                    .descriptionController
                                                    .text
                                                    .trim()
                                                    .isEmpty) {
                                                  constants.showSnackBar(
                                                    Resources.of(
                                                      Get.context!,
                                                    ).strings.enterYourMessage,
                                                    SnackBarStatus.ERROR,
                                                  );
                                                  return;
                                                }

                                                Get.bottomSheet(
                                                  VerifyFaceMatchApplyJobBottomSheet(),
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                );
                                              },
                                            );
                                          }),

                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24),

                          ],
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
