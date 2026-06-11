import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/screens/main/engagement_details/engagement_details_controller.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../components/engagement_bottom_actions.dart';
import '../components/engagement_common.dart';
import '../components/engagement_content_cards.dart';
import '../components/engagement_header_card.dart';

/// Job application engagement details. The body adapts to the engagement state
/// to match the design:
///  • Application / pending (status 0, design p212): a single card with Time
///    estimation + Attach CV + Message to Employer — no skills/about.
///  • Upcoming / active (status 1, design p213): Skills required + About the job
///    + Start date card.
///  • Other states (finish / rate / dispute): the full detail view plus any
///    completed deliverables.
class JobEngagementDetailsScreen extends StatelessWidget {
  const JobEngagementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EngagementDetailsController>();
    final strings = Resources.of(context).strings;
    final engagement = controller.engagement.value!;
    final job = controller.job.value;
    final status = engagement.status;

    final hasDesc = (engagement.description ?? '').toString().trim().isNotEmpty;
    // NB: the backend field is misspelled `requirememts`.
    final hasReq = (job?.requirememts ?? '').toString().trim().isNotEmpty;
    final hasResp = (job?.responsibilities ?? '').toString().trim().isNotEmpty;
    final hasHours = engagement.estimatedHours != null;
    final hasCv =
        engagement.freelancerCv != null && engagement.freelancerCv!.isNotEmpty;
    final hasMsg =
        (engagement.messageToClient ?? '').toString().trim().isNotEmpty;

    final body = <Widget>[
      const EngagementHeaderCard(inlineLocationAndDates: true),
      const SizedBox(height: 12),
      const EngagementMemberPriceRow(),
      const SizedBox(height: 20),
    ];

    if (status == 0) {
      // Application / pending — show Skills + About the job (as in the
      // completed view) followed by the Time estimation + CV + Message card.
      body.addAll(_skillsAndAbout(context, strings, engagement, job,
          hasDesc: hasDesc, hasReq: hasReq, hasResp: hasResp));
      if (hasHours || hasCv || hasMsg) {
        body
          ..add(const SizedBox(height: 16))
          ..add(_applicationCard(context, strings, engagement,
              hasHours: hasHours, hasCv: hasCv, hasMsg: hasMsg));
      }
    } else if (status == 1) {
      // Upcoming / active — design p213.
      body.addAll(_skillsAndAbout(context, strings, engagement, job,
          hasDesc: hasDesc, hasReq: hasReq, hasResp: hasResp));
      final startCard = _startDateCard(context, strings, engagement);
      if (startCard != null) {
        body
          ..add(const SizedBox(height: 16))
          ..add(startCard);
      }
    } else {
      // Finish / rate / dispute — full detail + deliverables.
      body.addAll(_skillsAndAbout(context, strings, engagement, job,
          hasDesc: hasDesc, hasReq: hasReq, hasResp: hasResp));
      if (hasHours || hasCv || hasMsg) {
        body
          ..add(const SizedBox(height: 16))
          ..add(_applicationCard(context, strings, engagement,
              hasHours: hasHours, hasCv: hasCv, hasMsg: hasMsg));
      }
      body
        ..add(const SizedBox(height: 16))
        ..add(const EngagementDeliverablesCard());
    }

    body.add(const SizedBox(height: 24));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: body,
            ),
          ),
        ),
        const EngagementBottomActions(),
      ],
    );
  }

  /// Skills required + "About the job" cards (design p213).
  List<Widget> _skillsAndAbout(
    BuildContext context,
    dynamic strings,
    dynamic engagement,
    dynamic job, {
    required bool hasDesc,
    required bool hasReq,
    required bool hasResp,
  }) {
    return [
      const EngagementSkillsCard(),
      if (hasDesc || hasReq || hasResp) ...[
        const SizedBox(height: 16),
        EngagementSectionCard(
          title: strings.aboutTheJob,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasDesc) _body(context, engagement.description!),
              if (hasReq) ...[
                const SizedBox(height: 14),
                _heading(context, '${strings.requirements}:'),
                const SizedBox(height: 6),
                _bullets(context, job!.requirememts!),
              ],
              if (hasResp) ...[
                const SizedBox(height: 14),
                _heading(context, strings.responsibilities),
                const SizedBox(height: 6),
                _body(context, job!.responsibilities!),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  /// Time estimation + CV + Message card (design p212). Returns an empty box
  /// when there is nothing to show.
  Widget _applicationCard(
    BuildContext context,
    dynamic strings,
    dynamic engagement, {
    required bool hasHours,
    required bool hasCv,
    required bool hasMsg,
  }) {
    if (!hasHours && !hasCv && !hasMsg) return const SizedBox.shrink();
    return EngagementSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHours) ...[
            _label(context, strings.timeEstimation),
            const SizedBox(height: 6),
            EngagementInfoBox(
              text: '${engagement.estimatedHours} ${strings.hours}',
            ),
          ],
          if (hasCv) ...[
            if (hasHours) const SizedBox(height: 16),
            _label(context, strings.uploadCv),
            const SizedBox(height: 8),
            EngagementFileCard(
              titleText: strings.cvFile,
              url: engagement.freelancerCv!,
              dashed: true,
              onTap: () => engagementOpenFileInBrowser(
                  engagement.freelancerCv!, context),
            ),
          ],
          if (hasMsg) ...[
            if (hasHours || hasCv) const SizedBox(height: 16),
            _label(context, strings.messageToEmployer),
            const SizedBox(height: 6),
            EngagementInfoBox(text: engagement.messageToClient!),
          ],
        ],
      ),
    );
  }

  /// "Start date" card (design p213) — blue label + relative-or-absolute value.
  Widget? _startDateCard(
      BuildContext context, dynamic strings, dynamic engagement) {
    final DateTime? start = engagement.startDatetime;
    if (start == null) return null;

    final now = DateTime.now();
    final startDay = DateTime(start.year, start.month, start.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = startDay.difference(today).inDays;

    final String value;
    if (diff > 0) {
      value = strings.jobWillStartInDays(diff);
    } else if (diff == 0) {
      value = strings.jobStartsToday;
    } else {
      value = strings.jobWillStartOn(DateFormat('dd MMM yyyy').format(start));
    }

    return EngagementSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            text: strings.startDate,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: context.resources.color.colorPrimary,
          ),
          const SizedBox(height: 6),
          PrimaryText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: context.resources.color.colorGrey,
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) => PrimaryText(
        text: text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        textColor: context.resources.color.colorBlack,
      );

  // Bold black sub-heading inside the "About the job" card (design p219).
  Widget _heading(BuildContext context, String text) => PrimaryText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        textColor: context.resources.color.colorBlack,
      );

  // Plain grey body text (design p219).
  Widget _body(BuildContext context, String text) => PrimaryText(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textColor: context.resources.color.colorGrey,
      );

  // Grey bulleted list (design p219 "Requirements:"). Splits on new lines;
  // falls back to a single bullet for one-line content.
  Widget _bullets(BuildContext context, String text) {
    final items = text
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.replaceFirst(RegExp(r'^\s*[•\-\*]\s*'), '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: '•  ',
                    fontSize: 14,
                    textColor: context.resources.color.colorGrey,
                  ),
                  Expanded(child: _body(context, item)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
