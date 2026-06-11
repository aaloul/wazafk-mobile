import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

/// "Final submission" sheet (design p87): centered title + subtitle, clipboard
/// illustration, an "Upload file here" dashed dropzone, the selected file as a
/// dashed row, and a Submit button.
class FinishEngagementBottomSheet extends StatelessWidget {
  const FinishEngagementBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final colors = context.resources.color;
    final strings = Resources.of(context).strings;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: colors.colorWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle.
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: colors.colorGrey6,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: PrimaryText(
                        text: strings.finalSubmission,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: colors.colorBlack,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: PrimaryText(
                        text: strings.finalSubmissionSubtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        textColor: colors.colorGrey7,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Image.asset(
                        AppIcons.finalSubmissionIllustration,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 160),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: colors.colorGrey4),
                    const SizedBox(height: 20),
                    PrimaryText(
                      text: strings.uploadFileHere,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textColor: colors.colorGrey8,
                    ),
                    const SizedBox(height: 12),
                    _UploadDropzone(
                      onTap: () => controller.pickDeliverableFile(context),
                    ),
                    Obx(() {
                      if (controller.deliverableFile.value == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _SelectedFileRow(
                          name: controller.deliverableFileName.value ??
                              strings.tapToUploadFile,
                          size: controller.getDeliverableFileSize(),
                          onRemove: controller.removeDeliverableFile,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Submit button.
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Obx(() {
                if (controller.isFinishingEngagement.value) {
                  return Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: colors.colorPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: colors.colorWhite,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }
                return PrimaryButton(
                  title: strings.submitFeedback,
                  height: 52,
                  borderRadius: 14,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  onPressed: controller.finishEngagement,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed dropzone with a centered upload icon (design p87).
class _UploadDropzone extends StatelessWidget {
  const _UploadDropzone({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = context.resources.color.colorGrey18;
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(color: border, radius: 12),
        child: Container(
          width: double.infinity,
          height: 78,
          alignment: Alignment.center,
          child: Image.asset(
            AppIcons.upload,
            width: 26,
            height: 26,
            color: context.resources.color.colorGrey7,
          ),
        ),
      ),
    );
  }
}

/// Selected-file row drawn with the design's blue dashed border (design p87).
class _SelectedFileRow extends StatelessWidget {
  const _SelectedFileRow({
    required this.name,
    required this.size,
    required this.onRemove,
  });

  final String name;
  final String size;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final primary = context.resources.color.colorPrimary;
    return CustomPaint(
      foregroundPainter:
          _DashedBorderPainter(color: primary.withValues(alpha: 0.5), radius: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Image.asset(AppIcons.fileCv, width: 28, height: 28, color: primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: name,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textColor: context.resources.color.colorBlack,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  PrimaryText(
                    text: size,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: primary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.close, size: 20, color: primary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, this.radius = 8});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
