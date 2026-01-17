class MemberBankSampahResponse {
  final bool isRegistered;
  final List<BankSampahModel> bankSampah;

  MemberBankSampahResponse({
    required this.isRegistered,
    required this.bankSampah,
  });

  factory MemberBankSampahResponse.fromJson(Map<String, dynamic> json) {
    return MemberBankSampahResponse(
      isRegistered: json['is_registered'] ?? false,
      bankSampah: (json['bank_sampah'] as List<dynamic>?)
              ?.map((e) => BankSampahModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class BankSampahModel {
  final int id;
  final String namaBankSampah;
  final String? alamatBankSampah;

  BankSampahModel({
    required this.id,
    required this.namaBankSampah,
    this.alamatBankSampah,
  });

  factory BankSampahModel.fromJson(Map<String, dynamic> json) {
    return BankSampahModel(
      id: json['id'],
      namaBankSampah: json['nama_bank_sampah'] ?? '',
      alamatBankSampah: json['alamat_bank_sampah'],
    );
  }
}
