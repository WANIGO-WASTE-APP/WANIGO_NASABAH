import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/network/api_service.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/schedule_success_screen.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/select_bank_screen.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class CreateSetoranScheduleScreen extends StatefulWidget {
  const CreateSetoranScheduleScreen({super.key});

  @override
  State<CreateSetoranScheduleScreen> createState() =>
      _CreateSetoranScheduleScreenState();
}

class _CreateSetoranScheduleScreenState
    extends State<CreateSetoranScheduleScreen> {
  final ApiService _apiService = ApiService();
  bool isLoading = false;
  String selectedTime = '07.00';
  DateTime selectedDate = DateTime.now();
  bool isCalendarExpanded = true;
  WasteBankModel? selectedBank;

  final List<String> timeSlots = ['07.00', '09.00', '11.00', '17.00'];

  Future<void> _selectBank() async {
    final result = await Get.to(() => const SelectBankScreen());
    if (result != null && result is WasteBankModel) {
      setState(() {
        selectedBank = result;
      });
    }
  }

  void toggleCalendarExpanded() {
    setState(() {
      isCalendarExpanded = !isCalendarExpanded;
    });
  }

  Future<void> _createSchedule() async {
    if (selectedBank == null) {
      Get.snackbar(
        'Error',
        'Silakan pilih bank sampah terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final timeValue = selectedTime.replaceAll('.', ':');
    final dateValue = selectedDate.toIso8601String().split('T')[0];

    // Debug: print payload
    print('DEBUG - Setoran Payload:');
    print('  bank_sampah_id: ${selectedBank!.id}');
    print('  waktu_mulai: $timeValue');
    print('  tanggal_mulai: $dateValue');

    final response = await _apiService.createJadwalSetoran(
      bankSampahId: selectedBank!.id,
      waktuMulai: timeValue,
      tanggalMulai: dateValue,
    );

    // Debug: print response
    print('DEBUG - Response: $response');

    setState(() {
      isLoading = false;
    });

    if (response['success'] == true) {
      Get.to(() => const ScheduleSuccessScreen(
            title: 'Yeay! Jadwal Setoran Berhasil Dibuat 🎉',
            description:
                'Jadwal setoran sampah Anda telah berhasil diset untuk dimulai. Terima kasih telah berpartisipasi dalam menjaga kebersihan lingkungan!',
          ));
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
            child: SvgPicture.asset(
              'assets/images/plants_image.svg',
              fit: BoxFit.fitWidth,
            ),
          ),
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                GlobalText(
                  text: 'Form Jadwal Setoran',
                  variant: TextVariant.h3,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 8),
                GlobalText(
                  text: 'Isi form dibawah ini untuk atur jadwal',
                  variant: TextVariant.mediumRegular,
                  color: AppColors.gray600,
                ),
                const SizedBox(height: 24),

                GlobalText(
                  text: 'Pilih Bank Sampah Tujuan',
                  variant: TextVariant.largeSemiBold,
                  color: AppColors.gray700,
                ),
                const SizedBox(height: 12),
                selectedBank != null
                    ? GestureDetector(
                        onTap: _selectBank,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.gray100),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GlobalText(
                                      text: selectedBank!.name,
                                      variant: TextVariant.mediumSemiBold,
                                      color: AppColors.gray700,
                                    ),
                                    const SizedBox(height: 4),
                                    GlobalText(
                                      text: selectedBank!.address,
                                      variant: TextVariant.smallRegular,
                                      color: AppColors.gray600,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_circle_right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: _selectBank,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GlobalText(
                                  text: 'Pilih Bank Sampah Tujuan',
                                  variant: TextVariant.mediumBold,
                                  color: AppColors.gray600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.blue100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.blue700,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                const SizedBox(height: 24),

                // Time Selection
                GlobalText(
                  text: 'Pilih Waktu Mulai Rencana Setoran',
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
                  text: 'Pilih tanggal mulai rencana setoran',
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
      final isToday = day == DateTime.now().day &&
          selectedDate.month == DateTime.now().month &&
          selectedDate.year == DateTime.now().year;

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

    // Filter for collapsed view - show only the week containing selected date
    if (!isCalendarExpanded) {
      final selectedDayIndex = dayWidgets.indexWhere((widget) {
        if (widget is GestureDetector) {
          final container = widget.child as Container;
          final decoration = container.decoration as BoxDecoration;
          return decoration.color == AppColors.blue700;
        }
        return false;
      });

      if (selectedDayIndex != -1) {
        final weekStart = (selectedDayIndex ~/ 7) * 7;
        final weekEnd = weekStart + 7;
        dayWidgets = dayWidgets.sublist(
          weekStart.clamp(0, dayWidgets.length),
          weekEnd.clamp(0, dayWidgets.length),
        );
      }
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
