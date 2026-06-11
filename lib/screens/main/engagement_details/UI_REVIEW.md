# Engagement Details — UI Review (app vs design)

Design source: `Wazafk - New Design.pdf`. Implementation: `lib/screens/main/engagement_details/`.
Status key: ✅ matches · ⚠️ close / minor deviation · ❌ differs / not done.

The single old screen was split into a dispatcher + 3 type screens that share
`EngagementDetailsController`. Each screen composes the shared `components/` widgets.

---

## 1. Service booking — design p57 "Request" / p215 "Inquiry"
File: `service/service_engagement_details_screen.dart` → `components/service_package_body.dart`

| Element | Design | App | |
|---|---|---|---|
| Top bar | back + status pill (Request=blue / Inquiry=amber) | `EngagementBackBar` + `EngagementStatusPill` | ✅ |
| Title | "Service Name" + category path | header card title + category | ✅ |
| Member + price | avatar pill + "Budget: $X" chip | `EngagementMemberPriceRow` | ✅ |
| Brief | grey card | `EngagementSectionCard("Brief")` + info box | ✅ |
| Location | own card w/ pin | `EngagementLocationCard` | ✅ |
| Dates | own card, bullet list | `EngagementDatesCard` | ⚠️ shows start + due (2 bullets); design mockup lists 3 sample dates |
| Actions | **Accept (green) + Inquiry (blue) + Decline (red link)** | `EngagementActionButton` ×2 + decline link | ✅ (fixed) |
| Inquiry "Your booking request info" expander (p215) | blue expandable | — | ❌ not implemented |

## 2. Job application — design p213 "Application" / p56 "Upcoming"
File: `job/job_engagement_details_screen.dart`

| Element | Design | App | |
|---|---|---|---|
| Top bar | back + "Application" (amber) | same | ✅ |
| Header | title, category, Remote, "Applied …" | header card w/ inline location + dates | ⚠️ dates labelled Start/Due (not "Applied") |
| Member + price | pill + "Requested: $X" | `EngagementMemberPriceRow` | ✅ |
| Skills required | chips card | `EngagementSkillsCard` | ✅ |
| About the job | description (+ Requirements/Responsibilities) | `aboutTheJob` card + Responsibilities | ⚠️ Requirements bullets not split out (backend has no field) |
| Time estimation | "10 days" | label + `{estimatedHours} Hours` | ⚠️ backend supplies hours, not days |
| Attach your CV | dashed file card | `EngagementFileCard(dashed: true)` | ✅ |
| Message to Employer | grey box | label + info box | ✅ |
| Actions | **Accept (green) + Decline (red)** | `EngagementActionButton` ×2 | ✅ (fixed) |

## 3. Package booking — same engagement layout
File: `package/package_engagement_details_screen.dart` → shared `service_package_body.dart`

| Element | Design | App | |
|---|---|---|---|
| Layout | as service booking | shared body | ✅ |
| Chips card | "Services" (package services) | `EngagementSkillsCard` (PB → services) | ✅ |
| Actions | Accept + Inquiry + Decline | same as service | ✅ |

## 4. Inquiry compose — design p58
File: `inquiry/inquiry_screen.dart` (replaces the old negotiation bottom sheet)

| Element | Design | App | |
|---|---|---|---|
| App bar | centered "Inquiry" + back | `EngagementCenterAppBar` | ✅ |
| "Your Inquiry" card | white card | `EngagementSectionCard` | ✅ |
| Budget chip | "Clients Budget: $X" full-width blue | blue chip | ✅ |
| Amount request | field + "/ Job" suffix | TextField + suffix (`/ Hour` when hourly) | ✅ |
| Dates | card + edit pencil → calendar | `_DatesField` → `EditDatesSheet` | ✅ |
| Message | "Enter message to employer here" | `MultilineLabeledTextField` | ✅ |
| Send | "Send Inquiry" blue button | `PrimaryButton` (height 56, radius 14) | ✅ |

## 5. Active / in-progress — design p51/p55/p56
Bottom panel (`components/engagement_bottom_actions.dart`, status == 1)

| Element | Design | App | |
|---|---|---|---|
| Message {name} | blue primary | `EngagementMessageButton` → conversation | ✅ |
| Finalize Job | outlined (freelancer) | `PrimaryOutlinedButton` | ✅ |
| Submit Dispute | (kept for parity) | red underline link | ⚠️ not in design, preserved intentionally |
| Need Help? contact support | link | `EngagementNeedHelpLink` → support | ✅ |

---

## Button show/hide logic
Ported 1:1 from the original engagement screen (the proven reference). Service /
package bookings show **Accept + Inquiry + Decline** on the first request; once a
change request exists the rule `showInquiry = !hasChangeRequests && type != 'JA'`
drops Inquiry → **Accept + Decline**. Job applications are always Accept + Decline.
All other states (active, finish, dispute, rate) match the original conditions.

## Design pass (figma fidelity, logic unchanged)
- **Service / package** now match p57 exactly: title only (no category line), no
  skills card, and member pill + budget + Brief + Location + Dates all nested
  inside one outer **"Booking request"** card. Brief/Message/Milestones render as
  plain grey body text (grey filled boxes are a job-screen-only treatment).
- **Dates** sub-card gained its "Dates" label; package shows a "Services" chip
  card inside the outer card.
- Logic untouched: data sources, conditions, and the button show/hide rules are
  identical to the original screen.

## Fixes applied in earlier passes
- **Accept / Inquiry / Decline restyled** to the exact p57/p213 spec via
  `EngagementActionButton`: height 50, radius 12, 16px bold label, 8px gap, and
  the measured fills green `#6CC192` / blue `#4DA8ED` / red `#E45959` (Decline
  link also `#E45959`, 16px underlined). Previously the generic `PrimaryButton`
  (height 48, radius 8, app green/red tokens) was used.

## Design pass 2 — state-aware job body + rate screens
- **Job screen is now state-aware** (`job/job_engagement_details_screen.dart`):
  - status 0 (Application, p212): only the Time estimation + Attach CV +
    Message card — no skills/about, matching the mockup.
  - status 1 (Upcoming/active, p213): Skills required + About the job + a new
    **Start date** card ("Job will start in N days" / today / on-date).
  - other states (finish/rate/dispute): full detail + completed deliverables.
- **Rate screens** (p59 Rate Employer / p219 Rate Freelancer): real hero
  illustrations extracted from the PDF (`rate_freelancer.png` transparent /
  `rate_employer.png`), white hero band (was a blue tint), circle-outlined back
  button, and thin per-criterion divider lines. The live `RateEngagementScreen`
  picks the illustration by `targetUserType`; the legacy
  `EmployerRateMemberScreen` was rebuilt to the same layout.

## Known remaining gaps (low priority / data-driven)
- Job dates label "Applied …" vs Start/Due; "Time estimation" in days vs hours
  (backend returns hours) — wording only.
- Requirements bullets and the p215 "booking request info" expander are not
  modelled by the backend response.
- `Send Inquiry` / `Message {name}` / `Finalize Job` buttons now use the design's
  rounder pill (height 56, radius 14). The rest of the app's `PrimaryButton`s
  still default to 8px — bump globally if a consistent look is wanted.
