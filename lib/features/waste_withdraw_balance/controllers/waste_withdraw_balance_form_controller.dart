import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WasteWithdrawBalanceFormController extends GetxController {
  final amountController = TextEditingController(text: '0');
  final RxString amountText = '0'.obs;
  final RxString selectedMethod = ''.obs;
  final List<String> methods = [
    'Transfer Bank',
    'Penarikan di Tempat',
    'Dompet Digital'
  ];

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(() {
      amountText.value = amountController.text.replaceAll('.', '');
    });
  }

  bool get isFormValid =>
      selectedMethod.value.isNotEmpty &&
      amountText.value.isNotEmpty &&
      amountText.value != '0';

  void selectMethod(String? value) {
    if (value != null) {
      selectedMethod.value = value;
    }
  }

  void setAmount(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    amountController.text = formatter.format(amount).trim();
  }

  void clearAmount() {
    amountController.text = '0';
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
