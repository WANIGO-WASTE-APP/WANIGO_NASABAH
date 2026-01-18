import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';

class MemberBankSampahResponse {
  final bool isRegistered;
  final List<WasteBankModel> bankSampah;

  MemberBankSampahResponse({
    required this.isRegistered,
    required this.bankSampah,
  });

  factory MemberBankSampahResponse.fromJson(Map<String, dynamic> json) {
    return MemberBankSampahResponse(
      isRegistered: json['is_registered'] ?? false,
      bankSampah: (json['bank_sampah'] as List<dynamic>?)
              ?.map((e) => WasteBankModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
