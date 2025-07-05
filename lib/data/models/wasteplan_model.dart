// lib/features/kalendar/models/wasteplan_model.dart
import 'package:intl/intl.dart';

class WastePlan {
  final int id;
  final int type;       // 1 = Pemilahan, 2 = Setoran
  final int frequency;  // 1 = Harian, 2 = Mingguan, 3 = Bulanan
  final String? startingHours;
  final DateTime? startDate;
  final DateTime? planDate;
  final DateTime createdAt;

  WastePlan({
    required this.id,
    required this.type,
    required this.frequency,
    this.startingHours,
    this.startDate,
    this.planDate,
    required this.createdAt,
  });

  factory WastePlan.fromJson(Map<String, dynamic> json) {
    return WastePlan(
      id: json['id'],
      type: json['type'],
      frequency: json['frequency'] ?? 1,
      startingHours: json['startingHours'],
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : null,
      planDate: json['planDate'] != null 
          ? DateTime.parse(json['planDate']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'frequency': frequency,
      'startingHours': startingHours,
      'startDate': startDate?.toIso8601String(),
      'planDate': planDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper getters for human-readable descriptions
  String get typeDescription {
    switch (type) {
      case 1:
        return 'Pemilahan Sampah';
      case 2:
        return 'Setoran Sampah';
      default:
        return 'Jadwal Sampah';
    }
  }

  String get frequencyDescription {
    switch (frequency) {
      case 1:
        return 'Harian';
      case 2:
        return 'Mingguan';
      case 3:
        return 'Bulanan';
      default:
        return '';
    }
  }

  String get startingHoursDescription {
    if (startingHours == null) return '-';
    return startingHours!;
  }

  @override
  String toString() {
    return 'WastePlan(id: $id, type: $type, frequency: $frequency, startingHours: $startingHours, startDate: $startDate, planDate: $planDate, createdAt: $createdAt)';
  }
}