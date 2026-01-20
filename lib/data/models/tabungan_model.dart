import 'package:intl/intl.dart';

class TabunganModel {
  final double saldo;
  final double beratSampah;

  TabunganModel({
    required this.saldo,
    required this.beratSampah,
  });

  String get formattedSaldo {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    ).format(saldo);
  }

  String get formattedBerat {
    if (beratSampah == beratSampah.toInt().toDouble()) {
      return '${beratSampah.toInt()} kilogram';
    }
    return '${beratSampah.toStringAsFixed(1)} kilogram';
  }
}
