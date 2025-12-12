import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/utils.dart';

class VerifyFaceMatchBottomSheet extends StatefulWidget {
  const VerifyFaceMatchBottomSheet({super.key});

  @override
  State<VerifyFaceMatchBottomSheet> createState() =>
      _VerifyFaceMatchBottomSheetState();
}

class _VerifyFaceMatchBottomSheetState
    extends State<VerifyFaceMatchBottomSheet> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<EngagementDetailsController>();
    // Initialize camera when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeCamera();
    });
  }

  @override
  void dispose() {
    final controller = Get.find<EngagementDetailsController>();
    controller.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.resources.color.colorGrey15,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryText(
                    text: 'Verify Face Match',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorGrey,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: context.resources.color.colorGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),

                  // Info text
                  PrimaryText(
                    text: 'Take a selfie to verify your identity',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  PrimaryText(
                    text:
                        'Please use your camera to capture a clear photo of your face to proceed with finishing this engagement',
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey7,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),

                  // Camera preview or captured image
                  Obx(() {
                    final hasCapturedImage =
                        controller.faceMatchImage.value != null;
                    final isCameraInitialized =
                        controller.isCameraInitialized.value;
                    final isCameraInitializing =
                        controller.isCameraInitializing.value;

                    return Container(
                      width: double.infinity,
                      height: 350,
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
                                File(controller.faceMatchImage.value!.path),
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
                                    text: 'Initializing camera...',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                ],
                              )
                            : isCameraInitialized &&
                                  controller.cameraController != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  CameraPreview(controller.cameraController!),
                                  // Face oval overlay
                                  CustomPaint(
                                    painter: FaceOvalPainter(
                                      color:
                                          context.resources.color.colorPrimary,
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
                                    text: 'Camera not available',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        context.resources.color.colorGrey,
                                  ),
                                  SizedBox(height: 8),
                                  PrimaryText(
                                    text: 'Please check camera permissions',
                                    fontSize: 14,
                                    textColor:
                                        context.resources.color.colorGrey7,
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),

                  SizedBox(height: 24),

                  // Capture/Retake button
                  Obx(() {
                    final hasCapturedImage =
                        controller.faceMatchImage.value != null;

                    return PrimaryButton(
                      title: hasCapturedImage
                          ? 'Retake Photo'
                          : 'Capture Photo',
                      onPressed: hasCapturedImage
                          ? controller.retakePicture
                          : controller.takePictureFromCamera,
                    );
                  }),
                ],
              ),
            ),

            // Bottom Button
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(() {
                if (controller.isVerifyingFaceMatch.value) {
                  return Container(
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
                  );
                }

                final hasImage = controller.faceMatchImage.value != null;

                return Opacity(
                  opacity: hasImage ? 1.0 : 0.5,
                  child: PrimaryButton(
                    title: 'Verify & Continue',
                    onPressed: hasImage
                        ? controller.verifyFaceMatch
                        : () {
                            constants.showSnackBar(
                              'Please capture an image first',
                              SnackBarStatus.ERROR,
                            );
                          },
                  ),
                );
              }),
            ),
          ],
        ),
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
