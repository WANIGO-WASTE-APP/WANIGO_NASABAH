import 'package:get/get.dart';

class WasteScheduleController extends GetxController {
  // Observables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<DateTime> selectedDates = <DateTime>[].obs;

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
