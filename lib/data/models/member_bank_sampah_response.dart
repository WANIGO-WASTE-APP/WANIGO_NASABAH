import 'package:flutter/foundation.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';

class MemberBankSampahResponse {
  final bool isRegistered;
  final List<WasteBankModel> bankSampah;

  MemberBankSampahResponse({
    required this.isRegistered,
    required this.bankSampah,
  });

  factory MemberBankSampahResponse.fromJson(dynamic json) {
    List<WasteBankModel> parsedBanks = [];
    bool isRegisteredFlag = false;

    try {
      if (json is List) {
        isRegisteredFlag = json.isNotEmpty;
        for (var item in json) {
          if (item is Map<String, dynamic>) {
            try {
              final bank = WasteBankModel.fromJson(item);
              if (bank.name.isNotEmpty) {
                parsedBanks.add(bank);
              }
            } catch (e) {
              if (kDebugMode) print("DEBUG - Error parsing bank item: $e");
            }
          }
        }
      } else if (json is Map<String, dynamic>) {
        isRegisteredFlag = json['is_registered'] == true ||
            json['is_member'] == true ||
            json['status_keanggotaan'] == 'aktif';

        // Choose the best candidate for the list of banks
        final listCandidate =
            json['bank_sampah'] ?? json['data'] ?? json['banks'];

        if (listCandidate is List) {
          for (var item in listCandidate) {
            if (item is Map<String, dynamic>) {
              try {
                final bank = WasteBankModel.fromJson(item);
                if (bank.name.isNotEmpty) {
                  parsedBanks.add(bank);
                }
              } catch (e) {
                if (kDebugMode) print("DEBUG - Error parsing list item: $e");
              }
            }
          }
        } else {
          // Check if the root dynamic object itself is a bank bank (common in detail routes)
          final rootBank = WasteBankModel.fromJson(json);
          if (rootBank.name.isNotEmpty) {
            parsedBanks.add(rootBank);
          }
        }
      }
    } catch (e) {
      if (kDebugMode)
        print("DEBUG - Critical error in MemberBankSampahResponse parsing: $e");
    }

    return MemberBankSampahResponse(
      isRegistered: isRegisteredFlag,
      bankSampah: parsedBanks,
    );
  }
}
