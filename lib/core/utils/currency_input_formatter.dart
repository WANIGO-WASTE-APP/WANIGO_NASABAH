import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.trim().isEmpty) {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    }

    if (newText.length > 1 && newText.startsWith('0')) {
      newText = newText.substring(1);
    }

    double value = double.parse(newText);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );

    String formattedText = formatter.format(value).trim();

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
