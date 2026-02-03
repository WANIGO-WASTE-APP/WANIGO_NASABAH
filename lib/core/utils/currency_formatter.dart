import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(dynamic amount) {
    if (amount == null) return 'Rp0,00';

    double value;
    if (amount is String) {
      value = double.tryParse(amount) ?? 0.0;
    } else if (amount is num) {
      value = amount.toDouble();
    } else {
      value = 0.0;
    }

    if (value == 0) return 'Rp0';

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );

    return formatter.format(value).replaceAll(' ', '');
  }
}
