import 'package:get/get.dart';
import 'package:wazafak_app/model/LimitsResponse.dart';
import 'package:wazafak_app/repository/app/limits_repository.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';

/// Posting gates driven by `app/limits`.
///
/// An entity is blocked only when the backend says the next one is chargeable
/// *and* the wallet can't cover it — with funds in the wallet the flow
/// continues and the fee is settled there.
class PostingLimits {
  PostingLimits._();

  static Future<AppLimits> load() => AppLimitsCache.load();

  static AppLimits get current => AppLimitsCache.current;

  static double get walletBalance {
    try {
      return double.tryParse(Get.find<HomeController>().walletBalance.value) ??
          0;
    } catch (_) {
      return 0;
    }
  }

  /// Pulls the wallet again — call after anything that spends from it, so the
  /// balance shown on the profile and the summary steps stays correct.
  static void refreshWallet() {
    try {
      Get.find<HomeController>().fetchWallet();
    } catch (_) {
      // Home isn't in memory (deep link into a form) — nothing to refresh.
    }
  }

  static bool needsTopUp(EntityLimit limit) =>
      limit.chargeable && walletBalance < limit.price;

  static String priceLabel(EntityLimit limit) =>
      '\$${limit.price.toStringAsFixed(limit.price % 1 == 0 ? 0 : 2)}';
}
