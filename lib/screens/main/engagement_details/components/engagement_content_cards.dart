import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import 'engagement_common.dart';

/// Skills (job) or services (package) chips card. Service bookings don't show a
/// skills card (design p57). Returns an empty box when there is nothing to show.
class EngagementSkillsCard extends StatelessWidget {
  const EngagementSkillsCard({super.key, this.margin});

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;
    final type = engagement.type.toString();

    List<String> chips = [];
    String title = context.resources.strings.skills;

    if (type == 'JA' &&
        engagement.job != null &&
        engagement.job!.skills != null) {
      chips = engagement.job!.skills!
          .map((s) => s.name ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    } else if (type == 'PB' &&
        engagement.package != null &&
        engagement.package!.services != null) {
      title = context.resources.strings.services;
      chips = engagement.package!.services!
          .map((s) => s.title ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return EngagementSectionCard(
      title: title,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: chips
            .map(
              (text) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: context.resources.color.colorPrimaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: PrimaryText(
                  text: text,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorPrimary,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Location card (service / package) — design p57/p215.
class EngagementLocationCard extends StatelessWidget {
  const EngagementLocationCard({super.key, this.margin});

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;

    final lines = <String>[];
    if (engagement.workLocationType.toString().isNotEmpty) {
      lines.add(
          engagementWorkLocationTypeName(context, engagement.workLocationType));
    }
    if (engagement.workLocationType?.toString() != 'RMT' &&
        engagement.address != null) {
      final a = engagement.address!;
      for (final part in [a.city, a.street, a.address]) {
        if (part != null && part.toString().trim().isNotEmpty) {
          lines.add(part.toString());
        }
      }
      final buildingApt =
          '${a.building ?? ''} ${a.apartment ?? ''}'.trim();
      if (buildingApt.isNotEmpty) lines.add(buildingApt);
    }

    if (lines.isEmpty) return const SizedBox.shrink();

    return EngagementSectionCard(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.location,
              width: 18, color: context.resources.color.colorPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: context.resources.strings.location,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey,
                ),
                const SizedBox(height: 2),
                ...lines.map(
                  (l) => PrimaryText(
                    text: l,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: context.resources.color.colorBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dates card (service / package) — design p57/p215 bullet list.
class EngagementDatesCard extends StatelessWidget {
  const EngagementDatesCard({super.key, this.margin});

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;

    final dates = <String>[];
    if (engagement.startDatetime != null) {
      dates.add(DateFormat('dd MMMM yyyy').format(engagement.startDatetime!));
    }
    if (engagement.expiryDatetime != null) {
      dates.add(DateFormat('dd MMMM yyyy').format(engagement.expiryDatetime!));
    }

    if (dates.isEmpty) return const SizedBox.shrink();

    return EngagementSectionCard(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.calendar,
              width: 18, color: context.resources.color.colorPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: context.resources.strings.dates,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: context.resources.color.colorGrey,
                ),
                const SizedBox(height: 2),
                ...dates
                  .map(
                    (d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          PrimaryText(
                            text: '•  ',
                            fontSize: 14,
                            textColor: context.resources.color.colorBlack,
                          ),
                          PrimaryText(
                            text: d,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: context.resources.color.colorBlack,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A file row (CV / deliverable). [dashed] draws a dashed-style border to match
/// the design's "Attach your CV" card (p213).
class EngagementFileCard extends StatelessWidget {
  const EngagementFileCard({
    super.key,
    required this.titleText,
    required this.url,
    required this.onTap,
    this.dashed = false,
  });

  final String titleText;
  final String url;
  final VoidCallback onTap;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.resources.color.colorPrimary.withOpacity(0.4);
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: dashed
            ? _DashedBorderPainter(color: borderColor, radius: 8)
            : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.resources.color.colorPrimaryLight,
            borderRadius: BorderRadius.circular(8),
            border: dashed
                ? null
                : Border.all(color: borderColor, width: 1),
          ),
          child: Row(
          children: [
            Image.asset(AppIcons.fileCv,
                width: 28,
                height: 28,
                color: context.resources.color.colorPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: titleText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: context.resources.color.colorGrey,
                  ),
                  const SizedBox(height: 4),
                  PrimaryText(
                    text: url.split('/').last,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: context.resources.color.colorGrey7,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(AppIcons.fileDownload,
                width: 22,
                height: 22,
                color: context.resources.color.colorPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Completed-deliverables card (status 4 / 10). Renders an inline preview for
/// image deliverables and a downloadable file row otherwise.
class EngagementDeliverablesCard extends StatelessWidget {
  const EngagementDeliverablesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final engagement = controller.engagement.value!;
    final url = engagement.completedDeliverables;

    final isVisible = (engagement.status == 4 || engagement.status == 10) &&
        url != null &&
        url.isNotEmpty;
    if (!isVisible) return const SizedBox.shrink();

    return EngagementSectionCard(
      title: context.resources.strings.completedDeliverables,
      child: engagementIsImageFile(url)
          ? GestureDetector(
              onTap: () => engagementShowExpandedImage(context, url),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: PrimaryNetworkImage(
                  url: url,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            )
          : EngagementFileCard(
              titleText: context.resources.strings.deliverablesFile,
              url: url,
              onTap: () => engagementOpenFileInBrowser(url, context),
            ),
    );
  }
}

/// Paints a dashed rounded-rectangle border (design's "Attach your CV" card).
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
