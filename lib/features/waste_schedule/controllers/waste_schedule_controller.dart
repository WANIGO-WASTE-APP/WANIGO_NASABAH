import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/network/api_service.dart';
import 'package:wanigo_nasabah/data/models/schedule_list_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteScheduleController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final ApiService _apiService = ApiService();

  // Observables
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<DateTime> selectedDates = <DateTime>[].obs;
  final RxBool isCalendarExpanded = true.obs;

  final RxBool isLoading = false.obs;
  final RxBool isRegistered = false.obs;
  final RxList<ScheduleItemModel> scheduleList = <ScheduleItemModel>[].obs;
  final RxBool hasSchedules = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRegistrationStatus();
    fetchScheduleList();
  }

  Future<void> fetchRegistrationStatus() async {
    try {
      isLoading.value = true;
      final response = await _authRepository.getMemberBankSampah();
      isRegistered.value = response?.isRegistered == true;
    } catch (_) {
      isRegistered.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchScheduleList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getJadwalSampahList();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        scheduleList.value =
            data.map((item) => ScheduleItemModel.fromJson(item)).toList();
        hasSchedules.value = scheduleList.isNotEmpty;
      } else {
        hasSchedules.value = false;
        scheduleList.clear();
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat jadwal: $e';
      hasSchedules.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchRegistrationStatus();
    await fetchScheduleList();
  }

  void toggleCalendarExpanded() {
    isCalendarExpanded.value = !isCalendarExpanded.value;
  }

  // Actions
  void nextMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  void previousMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  bool isDateSelected(DateTime date) {
    return selectedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  ScheduleItemModel? get pemilahanSchedule {
    try {
      return scheduleList.firstWhere(
        (s) => s.tipeJadwal.tipeJadwal.toLowerCase().contains('pemilahan'),
      );
    } catch (_) {
      return null;
    }
  }

  ScheduleItemModel? get setoranSchedule {
    try {
      return scheduleList.firstWhere(
        (s) => s.tipeJadwal.tipeJadwal.toLowerCase().contains('setoran'),
      );
    } catch (_) {
      return null;
    }
  }

  // Mark schedule as completed
  Future<Map<String, dynamic>> markScheduleCompleted(int jadwalSampahId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.markJadwalCompleted(jadwalSampahId);

      if (response['success'] == true) {
        // Refresh schedule list after marking as completed
        await fetchScheduleList();
      } else {
        errorMessage.value = response['statusMessage'] ??
            'Gagal menandai jadwal sebagai selesai';
      }

      return response;
    } catch (e) {
      errorMessage.value = 'Gagal menandai jadwal sebagai selesai: $e';
      return {
        'success': false,
        'statusMessage': e.toString(),
      };
    } finally {
      isLoading.value = false;
    }
  }
}
