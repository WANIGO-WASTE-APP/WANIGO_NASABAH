// lib/features/kalendar/services/wasteplan_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan path import sesuai dengan struktur folder
import 'package:wanigo_nasabah/data/models/wasteplan_model.dart';

class WastePlanService {
  static const String _wastePlansKey = 'waste_plans';

  // Baca semua jadwal sampah
  Future<List<WastePlan>> readWastePlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_wastePlansKey);
    
    if (jsonString == null) {
      return [];
    }
    
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => WastePlan.fromJson(json)).toList();
  }

  // Simpan jadwal sampah
  Future<void> saveWastePlan(WastePlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPlans = await readWastePlans();
    
    // Tambahkan jadwal baru
    existingPlans.add(plan);
    
    // Konversi ke JSON dan simpan
    final jsonList = existingPlans.map((plan) => plan.toJson()).toList();
    await prefs.setString(_wastePlansKey, jsonEncode(jsonList));
  }

  // Generate ID baru
  Future<int> generateNewId() async {
    final plans = await readWastePlans();
    if (plans.isEmpty) {
      return 1;
    }
    
    // Cari ID tertinggi dan tambahkan 1
    final highestId = plans.map((plan) => plan.id).reduce((a, b) => a > b ? a : b);
    return highestId + 1;
  }

  // Hapus jadwal sampah
  Future<void> deleteWastePlan(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPlans = await readWastePlans();
    
    // Filter jadwal yang ingin dihapus
    final updatedPlans = existingPlans.where((plan) => plan.id != id).toList();
    
    // Konversi ke JSON dan simpan
    final jsonList = updatedPlans.map((plan) => plan.toJson()).toList();
    await prefs.setString(_wastePlansKey, jsonEncode(jsonList));
  }

  // Update jadwal sampah
  Future<void> updateWastePlan(WastePlan updatedPlan) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPlans = await readWastePlans();
    
    // Cari dan update jadwal yang diinginkan
    final index = existingPlans.indexWhere((plan) => plan.id == updatedPlan.id);
    if (index != -1) {
      existingPlans[index] = updatedPlan;
      
      // Konversi ke JSON dan simpan
      final jsonList = existingPlans.map((plan) => plan.toJson()).toList();
      await prefs.setString(_wastePlansKey, jsonEncode(jsonList));
    }
  }

  // Cari jadwal sampah berdasarkan ID
  Future<WastePlan?> findWastePlanById(int id) async {
    final plans = await readWastePlans();
    try {
      return plans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }
}