import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteScheduleController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<DateTime> selectedDates = <DateTime>[].obs;
  final RxBool isCalendarExpanded = true.obs;

  final RxBool isLoading = false.obs;
  final RxBool isRegistered = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRegistrationStatus();
  }

  Future<void> fetchRegistrationStatus() async {
    try {
      isLoading.value = true;
      final response = await _authRepository.getMemberBankSampah();
      isRegistered.value = response?.isRegistered == true;
    } catch (_) {
      isRegistered.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCalendarExpanded() {
    isCalendarExpanded.value = !isCalendarExpanded.value;
  }

  // Actions
  void nextMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  void previousMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  bool isDateSelected(DateTime date) {
    return selectedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }
}
