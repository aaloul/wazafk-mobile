import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/file_upload_item.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_chooser.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/primary_text_field.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../utils/res/AppIcons.dart';
import 'apply_job_controller.dart';

class ApplyJobScreen extends StatelessWidget {
  const ApplyJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplyJobController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Obx(() {
          final job = controller.job.value;

          return Column(
            children: [
              TopHeader(title: 'Apply Now'),

              job == null
                  ? Center(
                      child: PrimaryText(
                        text: 'Job details not available',
                        fontSize: 14,
                        textColor: context.resources.color.colorGrey,
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),

                            Container(
                              color: context.resources.color.colorBlue4,
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99999),
                                    child: PrimaryNetworkImage(
                                      url: job.memberImage.toString(),
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),

                                  SizedBox(width: 10),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PrimaryText(
                                          text:
                                              "${job.memberFirstName} ${job.memberLastName}",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppIcons.star2,
                                              width: 16,
                                            ),
                                            SizedBox(width: 2),
                                            PrimaryText(
                                              text: job.rating.toString(),
                                              fontSize: 14,
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
                            SizedBox(height: 8),
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
                                          text: job.title ?? '',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            if (job.parentCategoryName != null)
                                              PrimaryText(
                                                text:
                                                    "${job.parentCategoryName}/",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                            PrimaryText(
                                              text: job.categoryName ?? '',
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
                                        text: '${job.unitPrice}\$' ?? '',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      ),
                                      SizedBox(height: 2),
                                      PrimaryText(
                                        text: 'Hourly Rate',
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

                            SizedBox(height: 24),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: "Amount Required for This Job",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  SizedBox(height: 10),

                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: PrimaryTextField(
                                          controller:
                                              controller.budgetController,
                                          hint: 'Amount in USD',
                                          fontSize: 12,
                                          inputType: TextInputType.number,
                                        ),
                                      ),

                                      SizedBox(width: 8),
                                      PrimaryText(
                                        text: "/ Hour",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        textColor:
                                            context.resources.color.colorGrey,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10,
                                                ),
                                            color: context
                                                .resources
                                                .color
                                                .colorBlue4,
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text: 'You’ll Receive',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                              PrimaryText(
                                                text: '(Profit)',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                              SizedBox(height: 8),
                                              PrimaryText(
                                                text: '0.00 \$',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6),

                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10,
                                                ),
                                            color: context
                                                .resources
                                                .color
                                                .colorGrey17,
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(
                                                text: '10% Application',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                              PrimaryText(
                                                text: 'Commission Fees',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                              SizedBox(height: 8),
                                              PrimaryText(
                                                text: '0.00 \$',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                textColor: context
                                                    .resources
                                                    .color
                                                    .colorGrey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16),

                                  PrimaryText(
                                    text: "How long Will It Take?",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),

                                  // Duration Dropdown
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: PrimaryChooser(
                                          label: 'Duration',
                                          text: 'Select duration',
                                          isMandatory: true,
                                          withArrow: true,
                                          isMultiSelect: false,
                                          list: controller.durationOptions,
                                          selected:
                                              controller.selectedDuration.value,
                                          onSelect: (value) {
                                            controller.selectedDuration.value =
                                                value;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        margin: EdgeInsets.only(top: 24),
                                        child: PrimaryText(
                                          text: "Hours",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          textColor:
                                              context.resources.color.colorGrey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16),

                                  PrimaryText(
                                    text: "Description",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),

                                  // Description
                                  MultilineLabeledTextField(
                                    controller:
                                        controller.descriptionController,
                                    label: 'Message To Employer',
                                    hint:
                                        'Brief Description of why you are a suitable candidate for this job',
                                    maxLines: 20,
                                    height: 100,
                                    labelFontSize: 14,
                                    margin: 0,
                                    labelFontWeight: FontWeight.w500,
                                    inputType: TextInputType.text,
                                    isPassword: false,
                                    isMandatory: true,
                                  ),

                                  SizedBox(height: 16),

                                  PrimaryText(
                                    text: "Attachments",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),

                                  SizedBox(height: 8),

                                  // CV Upload
                                  Obx(
                                    () => FileUploadItem(
                                      label: controller.cvFile.value != null
                                          ? 'CV Selected'
                                          : 'Upload CV',
                                      isMandatory: true,
                                      isOptional: false,
                                      onClick: () {
                                        controller.pickCV(context);
                                      },
                                      imagePath: controller.cvFile.value?.path,
                                      isPdf: true,
                                    ),
                                  ),

                                  // Show selected CV info
                                  Obx(() {
                                    if (controller.cvFile.value == null) {
                                      return SizedBox.shrink();
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(top: 8),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            context.resources.color.colorBlue4,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: context
                                              .resources
                                              .color
                                              .colorPrimary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: context
                                                  .resources
                                                  .color
                                                  .colorPrimary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.picture_as_pdf,
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                PrimaryText(
                                                  text:
                                                      controller
                                                          .cvFileName
                                                          .value ??
                                                      'CV.pdf',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  textColor: context
                                                      .resources
                                                      .color
                                                      .colorGrey,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 4),
                                                PrimaryText(
                                                  text:
                                                      controller
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
                                                      .withOpacity(0.7),
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
                                                  .colorGrey,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              controller.removeCv();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  SizedBox(height: 24),

                                  // Submit Button
                                  Obx(() {
                                    if (controller.isLoading.value) {
                                      return Center(child: ProgressBar());
                                    }

                                    return PrimaryButton(
                                      title: 'Submit Application',
                                      onPressed: controller.submitApplication,
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
            ],
          );
        }),
      ),
    );
  }
}
