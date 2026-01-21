import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  final RxBool isWeekly = true.obs;

  void toggleWeekly() {
    isWeekly.value = true;
  }

  void toggleMonthly() {
    isWeekly.value = false;
  }

  void setWeekly(bool value) {
    isWeekly.value = value;
  }
}
