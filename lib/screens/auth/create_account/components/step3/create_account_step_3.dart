import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../create_account_controller.dart';

class CreateAccountStep3 extends StatelessWidget {
  CreateAccountStep3({super.key});

  final CreateAccountController dataController = Get.find<CreateAccountController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 12),

          PrimaryText(
            text: Resources.of(context).strings.verifyFaceMatch,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            textColor: context.resources.color.colorBlackMain,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          PrimaryText(
            text: Resources.of(context).strings.takeASelfieToVerify,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          // Camera preview or captured image
          Expanded(
            child: Obx(() {
              final hasCapturedImage = dataController.faceImage.value != null;
              final isCameraInitialized =
                  dataController.isCameraInitialized.value;
              final isCameraInitializing =
                  dataController.isCameraInitializing.value;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.resources.color.colorGrey15,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasCapturedImage
                        ? context.resources.color.colorPrimary
                        : context.resources.color.colorGrey18,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: hasCapturedImage
                      ? Image.file(
                          File(dataController.faceImage.value!.path),
                          fit: BoxFit.cover,
                        )
                      : isCameraInitializing
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: context.resources.color.colorPrimary,
                                ),
                                SizedBox(height: 16),
                                PrimaryText(
                                  text: Resources
                                      .of(context)
                                      .strings
                                      .initializingCamera,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: context.resources.color.colorGrey,
                                ),
                              ],
                            )
                          : isCameraInitialized &&
                                  dataController.cameraController != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CameraPreview(
                                        dataController.cameraController!),
                                    // Face oval overlay
                                    CustomPaint(
                                      painter: FaceOvalPainter(
                                        color: context
                                            .resources.color.colorPrimary,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 80,
                                      color: context.resources.color.colorGrey7,
                                    ),
                                    SizedBox(height: 16),
                                    PrimaryText(
                                      text: Resources
                                          .of(context)
                                          .strings
                                          .cameraNotAvailable,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      textColor:
                                          context.resources.color.colorGrey,
                                    ),
                                    SizedBox(height: 8),
                                    PrimaryText(
                                      text: Resources
                                          .of(context)
                                          .strings
                                          .pleaseCheckCameraPermissions,
                                      fontSize: 14,
                                      textColor:
                                          context.resources.color.colorGrey7,
                                    ),
                                  ],
                                ),
                ),
              );
            }),
          ),

          SizedBox(height: 16),

          // Capture/Retake button
          Obx(() {
            final hasCapturedImage = dataController.faceImage.value != null;

            return PrimaryButton(
              title: hasCapturedImage
                  ? context.resources.strings.retakePhoto
                  : context.resources.strings.capturePhoto,
              onPressed: hasCapturedImage
                  ? dataController.retakeFacePicture
                  : dataController.takeFacePicture,
            );
          }),

          SizedBox(height: 12),

          // Next button
          Obx(
            () => dataController.isRegistering.value
                ? Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.resources.color.colorPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: context.resources.color.colorWhite,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : Opacity(
                    opacity: dataController.faceImage.value != null ? 1.0 : 0.5,
                    child: PrimaryButton(
                      title: Resources.of(context).strings.next,
                      onPressed: () {
                        dataController.verifyStep3();
                      },
                    ),
                  ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Custom painter for face oval overlay
class FaceOvalPainter extends CustomPainter {
  final Color color;

  FaceOvalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.6,
      height: size.height * 0.7,
    );

    canvas.drawOval(ovalRect, paint);

    // Draw semi-transparent overlay outside the oval
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(ovalRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(FaceOvalPainter oldDelegate) => false;
}
