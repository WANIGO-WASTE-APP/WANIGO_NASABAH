import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/services/location_service.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteBankSearchController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxList<WasteBankModel> allWasteBanks = <WasteBankModel>[].obs;
  final RxList<WasteBankModel> filteredWasteBanks = <WasteBankModel>[].obs;
  final RxString searchQuery = ''.obs;

  final RxnString wasteTypeFilter = RxnString();

  final RxBool sortByDistanceEnabled = false.obs;
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    fetchAvailableWasteBanks();
  }

  Future<void> fetchAvailableWasteBanks() async {
    try {
      isLoading.value = true;

      final allBanks = await _authRepository.getAvailableBankSampah();

      final memberResponse = await _authRepository.getMemberBankSampah();
      final List<int> registeredIds =
          memberResponse?.bankSampah.map((b) => b.id).toList() ?? [];

      final crossReferencedBanks = allBanks.map((bank) {
        if (registeredIds.contains(bank.id)) {
          return bank.copyWith(isVerified: true);
        }
        return bank;
      }).toList();

      crossReferencedBanks.sort((a, b) => a.id.compareTo(b.id));

      allWasteBanks.assignAll(crossReferencedBanks);
      filteredWasteBanks.assignAll(crossReferencedBanks);
    } catch (e) {
      print("Error fetching available waste banks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchWasteBanks(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setWasteTypeFilter(String? type) {
    if (wasteTypeFilter.value == type) {
      wasteTypeFilter.value = null;
    } else {
      wasteTypeFilter.value = type;
    }
    _applyFilters();
  }

  Future<void> toggleSortByDistance() async {
    sortByDistanceEnabled.value = !sortByDistanceEnabled.value;
    if (sortByDistanceEnabled.value) {
      await _sortByDistance();
    } else {
      _applyFilters();
    }
  }

  Future<void> _sortByDistance() async {
    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      print('DEBUG - Cannot sort by distance: location not available');
      return;
    }

    var results = filteredWasteBanks.toList();

    results.sort((a, b) {
      final distA = _locationService.calculateDistance(
          position.latitude, position.longitude, a.latitude, a.longitude);
      final distB = _locationService.calculateDistance(
          position.latitude, position.longitude, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });

    filteredWasteBanks.assignAll(results);
  }

  void _applyFilters() {
    var results = allWasteBanks.toList();

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      results = results
          .where((wb) =>
              wb.name.toLowerCase().contains(query) ||
              wb.address.toLowerCase().contains(query))
          .toList();
    }

    if (wasteTypeFilter.value != null) {
      final filter = wasteTypeFilter.value!;
      results = results.where((wb) {
        final insight = (wb.insight ?? '').toLowerCase();
        if (filter == 'kering') {
          return insight.contains('kering') ||
              insight.contains('plastik') ||
              insight.contains('kertas') ||
              insight.contains('logam') ||
              insight.contains('kaca') ||
              insight.contains('anorganik');
        } else if (filter == 'basah') {
          return insight.contains('basah') ||
              insight.contains('organik') ||
              insight.contains('sisa makanan') ||
              insight.contains('daun');
        }
        return true;
      }).toList();
    }

    filteredWasteBanks.assignAll(results);

    if (sortByDistanceEnabled.value) {
      _sortByDistance();
    }
  }
}
