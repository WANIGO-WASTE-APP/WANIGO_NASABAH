import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/network/api_service.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/schedule_success_screen.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class CreatePemilahanScheduleScreen extends StatefulWidget {
  const CreatePemilahanScheduleScreen({super.key});

  @override
  State<CreatePemilahanScheduleScreen> createState() =>
      _CreatePemilahanScheduleScreenState();
}

class _CreatePemilahanScheduleScreenState
    extends State<CreatePemilahanScheduleScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = false;
  String selectedFrequency = 'Harian';
  String selectedTime = '07.00';
  DateTime selectedDate = DateTime.now();
  bool isCalendarExpanded = true;

  final List<String> frequencies = ['Harian', 'Mingguan', 'Bulanan'];
  final List<String> timeSlots = ['07.00', '09.00', '11.00', '17.00'];

  void toggleCalendarExpanded() {
    setState(() {
      isCalendarExpanded = !isCalendarExpanded;
    });
  }

  Future<void> _createSchedule() async {
    setState(() {
      isLoading = true;
    });

    final frequencyValue = selectedFrequency.toLowerCase();
    final timeValue = selectedTime.replaceAll('.', ':');
    final dateValue = selectedDate.toIso8601String().split('T')[0];

    // Debug: print payload
    print('DEBUG - Payload:');
    print('  frekuensi: $frequencyValue');
    print('  waktu_mulai: $timeValue');
    print('  tanggal_mulai: $dateValue');

    final response = await _apiService.createJadwalPemilahan(
      frekuensi: frequencyValue,
      waktuMulai: timeValue,
      tanggalMulai: dateValue,
    );

    // Debug: print response
    print('DEBUG - Response: $response');

    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {
      Get.to(() => const ScheduleSuccessScreen());
    } else {
      Get.snackbar(
        'Error',
        response['statusMessage'] ?? 'Gagal membuat jadwal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(
        enableShadow: true,
      ),
      body: Stack(
        children: [
          // Background image at bottom - behind all content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/icons/plan_typebg.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Header
                GlobalText(
                  text: 'Form Jadwal Pemilahan',
                  variant: TextVariant.h4,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 8),
                GlobalText(
                  text: 'Isi form dibawah ini untuk atur jadwal',
                  variant: TextVariant.mediumMedium,
                  color: AppColors.gray600,
                ),
                const SizedBox(height: 24),

                // Frequency Selection
                GlobalText(
                  text: 'Pilih Frekuensi Pemilahan Sampah',
                  variant: TextVariant.largeSemiBold,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 12),
                Row(
                  children: frequencies.map((freq) {
                    final isSelected = selectedFrequency == freq;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: freq != 'Bulanan' ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFrequency = freq;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.blue700
                                  : AppColors.gray100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: GlobalText(
                                text: freq,
                                variant: TextVariant.mediumSemiBold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.gray600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Time Selection
                GlobalText(
                  text: 'Pilih Waktu Mulai Pemilahan Sampah',
                  variant: TextVariant.largeSemiBold,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Selected time display - tap to edit
                    GestureDetector(
                      onTap: _showTimePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.blue200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GlobalText(
                              text: selectedTime.split('.')[0],
                              variant: TextVariant.h3,
                              color: AppColors.blue700,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.blue700,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            GlobalText(
                              text: selectedTime.split('.')[1],
                              variant: TextVariant.h3,
                              color: AppColors.blue700,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Time options - 2x2 grid (taller)
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTimeChip('07.00'),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: _buildTimeChip('09.00'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTimeChip('11.00'),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: _buildTimeChip('17.00'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Date Selection
                GlobalText(
                  text: 'Pilih tanggal mulai pemilahan sampah',
                  variant: TextVariant.largeSemiBold,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 12),
                // Month selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month - 1,
                                selectedDate.day,
                              );
                            });
                          },
                          icon: const Icon(Icons.chevron_left,
                              color: AppColors.gray600),
                        ),
                        GlobalText(
                          text: _getMonthYearText(),
                          variant: TextVariant.largeSemiBold,
                          color: AppColors.blue700,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month + 1,
                                selectedDate.day,
                              );
                            });
                          },
                          icon: const Icon(Icons.chevron_right,
                              color: AppColors.gray600),
                        ),
                      ],
                    ),
                    // Toggle calendar expand/collapse button
                    IconButton(
                      onPressed: toggleCalendarExpanded,
                      icon: Icon(
                        isCalendarExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.gray600,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Weekday headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                      .map((day) => GlobalText(
                            text: day,
                            variant: TextVariant.smallMedium,
                            color: day == 'Sab' || day == 'Min'
                                ? AppColors.blue700
                                : AppColors.gray600,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                // Calendar grid
                _buildCalendarGrid(),
                const SizedBox(height: 32),
                // Button in column
                GlobalButton(
                  text: isLoading ? 'Membuat Jadwal...' : 'Buat Jadwal',
                  variant: ButtonVariant.large,
                  onPressed: isLoading ? null : _createSchedule,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthYearText() {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${months[selectedDate.month - 1]} ${selectedDate.year}';
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final firstWeekday =
        DateTime(selectedDate.year, selectedDate.month, 1).weekday % 7;

    List<Widget> dayWidgets = [];

    // Days from previous month to fill the first week
    final prevMonthLastDay =
        DateTime(selectedDate.year, selectedDate.month, 0).day;
    for (int i = 0; i < firstWeekday; i++) {
      final prevDay = prevMonthLastDay - firstWeekday + 1 + i;
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(
                selectedDate.year,
                selectedDate.month - 1,
                prevDay,
              );
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: GlobalText(
                text: '$prevDay',
                variant: TextVariant.mediumMedium,
                color: AppColors.gray400,
              ),
            ),
          ),
        ),
      );
    }

    // Day cells - current month
    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = day == selectedDate.day;
      final isToday = day == 30 && selectedDate.month == 3;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate =
                  DateTime(selectedDate.year, selectedDate.month, day);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue700 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: GlobalText(
                text: '$day',
                variant: TextVariant.mediumMedium,
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.blue700
                        : AppColors.gray700,
              ),
            ),
          ),
        ),
      );
    }

    // Add days from next month only to complete the week of the last day
    final totalCells = dayWidgets.length;
    final remainingSlots = (7 - (totalCells % 7)) % 7;

    for (int i = 1; i <= remainingSlots; i++) {
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(
                selectedDate.year,
                selectedDate.month + 1,
                i,
              );
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: GlobalText(
                text: '$i',
                variant: TextVariant.mediumMedium,
                color: AppColors.gray400,
              ),
            ),
          ),
        ),
      );
    }

    // If collapsed, show only the week containing selected date
    if (!isCalendarExpanded) {
      final selectedDayIndex = firstWeekday + selectedDate.day - 1;
      final weekStartIndex = (selectedDayIndex ~/ 7) * 7;
      dayWidgets = dayWidgets.sublist(
        weekStartIndex,
        (weekStartIndex + 7).clamp(0, dayWidgets.length),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: dayWidgets,
    );
  }

  void _showTimePicker() async {
    final hour = int.parse(selectedTime.split('.')[0]);
    final minute = int.parse(selectedTime.split('.')[1]);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.gray700,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final hourStr = picked.hour.toString().padLeft(2, '0');
        final minuteStr = picked.minute.toString().padLeft(2, '0');
        selectedTime = '$hourStr.$minuteStr';
      });
    }
  }

  Widget _buildTimeChip(String time) {
    final isSelected = selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue700 : AppColors.gray100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: GlobalText(
            text: time,
            variant: TextVariant.smallRegular,
            color: isSelected ? Colors.white : AppColors.gray600,
          ),
        ),
      ),
    );
  }
}
