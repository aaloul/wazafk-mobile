import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/date_chooser.dart';
import 'package:wazafak_app/components/labeled_text_field.dart';
import 'package:wazafak_app/components/multiline_labeled_text_field.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_chooser.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/screens/main/profile/profile_controller.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';
import 'package:wazafak_app/utils/utils.dart';

import 'personal_information_controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInformationController());
    final profileController = Get.put(ProfileController());
    final colors = context.resources.color;
    final strings = Resources.of(context).strings;

    return Scaffold(
      backgroundColor: colors.background2,
      body: SafeArea(
        child: Column(
          children: [
            _HeroHeader(controller: controller),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _Card(
                      child: MultilineLabeledTextField(
                        label: strings.about,
                        hint: strings.tellUsAboutYourself,
                        inputType: TextInputType.multiline,
                        isPassword: false,
                        isMandatory: false,
                        controller: controller.aboutController,
                        height: 110,
                        margin: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          LabeledTextFiled(
                            label: strings.firstName,
                            hint: strings.firstName,
                            inputType: TextInputType.text,
                            isPassword: false,
                            isMandatory: true,
                            controller: controller.firstNameController,
                          ),
                          LabeledTextFiled(
                            label: strings.lastName,
                            hint: strings.lastName,
                            inputType: TextInputType.text,
                            isPassword: false,
                            isMandatory: true,
                            controller: controller.lastNameController,
                          ),
                          LabeledTextFiled(
                            label: strings.title,
                            hint: strings.title,
                            inputType: TextInputType.text,
                            isPassword: false,
                            isMandatory: false,
                            controller: controller.titleController,
                          ),
                          Obx(
                            () => PrimaryChooser(
                              label: strings.gender,
                              text: strings.gender,
                              selected:
                                  controller.selectedGender.value.isNotEmpty
                                      ? controller.selectedGender.value
                                      : null,
                              onSelect: (value) {
                                controller.selectedGender.value = value;
                              },
                              withArrow: true,
                              isMandatory: true,
                              list: controller.genders,
                              isMultiSelect: false,
                            ),
                          ),
                          Obx(
                            () => DateChooser(
                              text: controller.selectedDate.value == null
                                  ? 'dd/MM/yyyy'
                                  : DateFormat('dd/MM/yyyy')
                                      .format(controller.selectedDate.value!),
                              isMandatory: false,
                              onSelectDate: (d) {
                                controller.selectedDate.value = d;
                              },
                              label: strings.dateOfBirth,
                              minDate: DateTime(1900),
                              maxDate: DateTime.now()
                                  .subtract(const Duration(days: 18 * 365 + 4)),
                            ),
                          ),
                          LabeledTextFiled(
                            label: strings.portfolioLink,
                            hint: strings.portfolioLink,
                            inputType: TextInputType.url,
                            isPassword: false,
                            isMandatory: false,
                            controller: controller.portfolioLinkController,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => controller.isLoading.value
                                ? const ProgressBar()
                                : PrimaryButton(
                                    title: strings.save,
                                    onPressed: controller.updateProfile,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          _ContactRow(
                            label: strings.emailAddress,
                            value: Prefs.getEmail,
                            onEdit: () async {
                              await Get.toNamed(
                                  RouteConstant.updateEmailScreen);
                            },
                          ),
                          _ThinDivider(),
                          _ContactRow(
                            label: strings.phoneNumber,
                            value: Prefs.getMobile,
                            onEdit: null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _NavRow(
                            icon: AppIcons.changePassword,
                            label: strings.changePassword,
                            onTap: () =>
                                Get.toNamed(RouteConstant.changePasswordScreen),
                          ),
                          _ThinDivider(),
                          _NavRow(
                            icon: AppIcons.menuDelete,
                            label: strings.deleteAccount,
                            onTap: profileController.deleteAccount,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      padding: EdgeInsets.zero,
                      child: _NavRow(
                        icon: AppIcons.menuLogout,
                        label: strings.logout,
                        labelColor: colors.colorRed2,
                        iconColor: colors.colorRed2,
                        onTap: profileController.logout,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.controller});

  final PersonalInformationController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    final strings = Resources.of(context).strings;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.colorPrimaryLight, colors.colorWhite],
        ),
      ),
      child: Column(
        children: [
          TopHeader(
            hasBack: true,
            title: strings.profile,
            backgroundColor: Colors.transparent,
          ),
          GestureDetector(
            onTap: () => controller.showImageSourceDialog(context),
            child: Obx(() {
              Widget avatar;
              if (controller.profileImage.value != null) {
                avatar = Image.file(
                  File(controller.profileImage.value!.path),
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                );
              } else if (Prefs.getAvatar.isNotEmpty) {
                avatar = CachedNetworkImage(
                  imageUrl: Prefs.getAvatar,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ProgressBar(),
                  errorWidget: (context, url, error) => Image.asset(
                    AppIcons.addImage,
                    width: 96,
                    height: 96,
                  ),
                );
              } else {
                avatar = Image.asset(
                  AppIcons.addImage,
                  width: 96,
                  height: 96,
                );
              }
              return Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.colorWhite, width: 3),
                ),
                child: ClipOval(child: avatar),
              );
            }),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => controller.showImageSourceDialog(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 14, color: colors.colorPrimary),
                const SizedBox(width: 4),
                PrimaryText(
                  text: strings.editImage,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding =
        const EdgeInsets.fromLTRB(16, 12, 16, 12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ThinDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: context.resources.color.colorGrey4,
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: label,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  textColor: colors.colorGrey,
                ),
                const SizedBox(height: 2),
                PrimaryText(
                  text: value.isEmpty ? '-' : value,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: colors.colorBlack,
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.edit, size: 18, color: colors.colorPrimary),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.resources.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 18,
              color: iconColor ?? colors.colorGrey,
            ),
            Container(
              width: 1,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: colors.colorGrey4,
            ),
            Expanded(
              child: PrimaryText(
                text: label,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                textColor: labelColor ?? colors.colorBlack,
              ),
            ),
            if (labelColor == null)
              RotatedBox(
                quarterTurns: Utils().isRTL() ? 2 : 0,
                child: Image.asset(
                  AppIcons.arrowRight2,
                  width: 14,
                  color: colors.colorGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
