import 'package:get/get.dart';

class WasteWithdrawBalanceController extends GetxController {
  final RxInt subTabIndex = 0.obs;

  void setSubTab(int index) {
    subTabIndex.value = index;
  }
}
