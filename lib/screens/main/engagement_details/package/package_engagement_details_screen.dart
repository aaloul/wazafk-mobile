import 'package:flutter/material.dart';

import '../components/service_package_body.dart';

/// Package-booking engagement details (design p202/203 family — same engagement
/// layout as a service booking, with a "Services" chips card instead of skills).
class PackageEngagementDetailsScreen extends StatelessWidget {
  const PackageEngagementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => const ServicePackageEngagementBody();
}
