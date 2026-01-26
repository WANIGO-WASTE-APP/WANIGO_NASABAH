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
      if (kDebugMode)
        print(
            "DEBUG - MemberBankSampahResponse parsing started with type: ${json.runtimeType}");

      if (json is List) {
        if (kDebugMode)
          print(
              "DEBUG - MemberBankSampahResponse: json is List with length ${json.length}");
        isRegisteredFlag = json.isNotEmpty;
        for (var item in json) {
          if (item is Map) {
            try {
              final bank =
                  WasteBankModel.fromJson(Map<String, dynamic>.from(item));
              if (bank.name.isNotEmpty) {
                parsedBanks.add(bank);
              } else {
                if (kDebugMode)
                  print(
                      "DEBUG - MemberBankSampahResponse: Bank name is empty for item");
              }
            } catch (e) {
              if (kDebugMode)
                print("DEBUG - Error parsing bank item from list: $e");
            }
          }
        }
      } else if (json is Map) {
        if (kDebugMode) print("DEBUG - MemberBankSampahResponse: json is Map");
        isRegisteredFlag = json['is_registered'] == true ||
            json['is_member'] == true ||
            json['status_keanggotaan'] == 'aktif';

        // Choose the best candidate for the list of banks
        final listCandidate =
            json['bank_sampah'] ?? json['data'] ?? json['banks'];

        if (kDebugMode) {
          print(
              "DEBUG - MemberBankSampahResponse: listCandidate found: ${listCandidate != null}, type: ${listCandidate.runtimeType}");
          if (listCandidate is List)
            print(
                "DEBUG - MemberBankSampahResponse: listCandidate length: ${listCandidate.length}");
        }

        if (listCandidate is List) {
          for (var item in listCandidate) {
            if (item is Map) {
              try {
                final bank =
                    WasteBankModel.fromJson(Map<String, dynamic>.from(item));
                if (bank.name.isNotEmpty) {
                  parsedBanks.add(bank);
                } else {
                  if (kDebugMode)
                    print(
                        "DEBUG - MemberBankSampahResponse: Bank name is empty for item in list candidate");
                }
              } catch (e) {
                if (kDebugMode)
                  print("DEBUG - Error parsing list item candidate: $e");
              }
            }
          }
        } else {
          // Check if the root dynamic object itself is a bank bank (common in detail routes)
          if (kDebugMode)
            print(
                "DEBUG - MemberBankSampahResponse: Trying to parse root as bank");
          try {
            final rootBank =
                WasteBankModel.fromJson(Map<String, dynamic>.from(json));
            if (rootBank.name.isNotEmpty) {
              parsedBanks.add(rootBank);
            }
          } catch (e) {
            if (kDebugMode)
              print("DEBUG - MemberBankSampahResponse: Root is not a bank: $e");
          }
        }
      } else {
        if (kDebugMode)
          print(
              "DEBUG - MemberBankSampahResponse: Unknown json type: ${json.runtimeType}");
      }
    } catch (e) {
      if (kDebugMode)
        print("DEBUG - Critical error in MemberBankSampahResponse parsing: $e");
    }

    if (kDebugMode)
      print(
          "DEBUG - MemberBankSampahResponse: Finished parsing, found ${parsedBanks.length} banks");

    return MemberBankSampahResponse(
      isRegistered: isRegisteredFlag,
      bankSampah: parsedBanks,
    );
  }
}
