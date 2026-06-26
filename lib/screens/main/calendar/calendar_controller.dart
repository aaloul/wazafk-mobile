import 'package:get/get.dart';
import 'package:wazafak_app/model/EngagementsResponse.dart';
import 'package:wazafak_app/repository/engagement/engagements_list_repository.dart';
import 'package:wazafak_app/utils/Prefs.dart';

class CalendarController extends GetxController {
  final _repository = EngagementsListRepository();

  var isLoading = false.obs;

  /// True during any fetch (including month-change refreshes) — drives the small
  /// loader shown above the calendar.
  var isFetching = false.obs;

  /// Engagements whose due date falls within the focused month.
  var engagements = <Engagement>[].obs;

  /// First day of the month currently shown in the grid.
  late Rx<DateTime> focusedMonth;

  /// The day the user has tapped (drives the "Today's Schedule" list).
  late Rx<DateTime> selectedDate;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    focusedMonth = DateTime(now.year, now.month).obs;
    selectedDate = DateTime(now.year, now.month, now.day).obs;
    fetchEngagements();
  }

  /// Fetches engagements for the focused month using the calendar params.
  Future<void> fetchEngagements({bool isRefresh = false}) async {
    try {
      isFetching.value = true;
      isLoading.value = !isRefresh;
      final m = focusedMonth.value;

      // Scope to the current portal: freelancer mode filters by freelancer,
      // employer mode filters by client.
      final isFreelancer = Prefs.getUserMode == 'freelancer';

      final response = await _repository.getEngagements(filters: {
        if (isFreelancer)
          'freelancer': Prefs.getId
        else
          'client': Prefs.getId,
        'calendar_year': m.year.toString(),
        'calendar_month': m.month.toString(),
      });

      if (response.success == true && response.data?.list != null) {
        engagements.value = response.data!.list!;
      } else {
        engagements.value = [];
      }
    } catch (e) {
      print('Error fetching engagements: $e');
    } finally {
      isLoading.value = false;
      isFetching.value = false;
    }
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Whether [e] starts on [day] (based on start_datetime).
  bool _startsOn(Engagement e, DateTime day) {
    final s = e.startDatetime;
    if (s == null) return false;
    return _dateOnly(s) == _dateOnly(day);
  }

  /// Engagements starting on [day], sorted by start time.
  List<Engagement> engagementsForDay(DateTime day) {
    final list = engagements.where((e) => _startsOn(e, day)).toList();
    list.sort((a, b) => (a.startDatetime ?? DateTime(0))
        .compareTo(b.startDatetime ?? DateTime(0)));
    return list;
  }

  /// Number of engagements on [day] (used for the dots under a date cell).
  int engagementCountForDay(DateTime day) => engagementsForDay(day).length;

  void selectDate(DateTime day) {
    selectedDate.value = DateTime(day.year, day.month, day.day);
  }

  void goToPreviousMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month - 1);
    // Refetch for the new month without the full-screen loader (keep the grid).
    fetchEngagements(isRefresh: true);
  }

  void goToNextMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month + 1);
    fetchEngagements(isRefresh: true);
  }

  bool get isSelectedToday {
    final now = DateTime.now();
    return _dateOnly(selectedDate.value) == _dateOnly(now);
  }
}
