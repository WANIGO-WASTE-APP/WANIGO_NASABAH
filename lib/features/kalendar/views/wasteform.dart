// lib/features/kalendar/views/wasteform.dart
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

// Import model dan service dengan path yang benar
import 'package:wanigo_nasabah/data/models/wasteplan_model.dart';
import 'package:wanigo_nasabah/features/kalendar/services/wasteplan_service.dart';
import 'package:wanigo_nasabah/features/kalendar/views/calendar_planlist.dart';

class WasteSortingScheduleForm extends StatefulWidget {
  const WasteSortingScheduleForm({Key? key}) : super(key: key);

  @override
  _WasteSortingScheduleFormState createState() => _WasteSortingScheduleFormState();
}

class _WasteSortingScheduleFormState extends State<WasteSortingScheduleForm> {
  // Frequency selection
  String _selectedFrequency = 'Harian';
  final List<String> _frequencies = ['Harian', 'Mingguan', 'Bulanan'];

  // Time selection
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  final List<String> _predefinedTimes = ['07.00', '09.00', '11.00', '17.00'];
  
  // Calendar variables
  late DateTime currentMonth;
  late DateTime selectedDate;
  late List<DateTime> datesGrid;
  CalendarView _currentView = CalendarView.monthly;
  
  // Calendar days of week
  final List<String> _daysOfWeek = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  
  // Service untuk menyimpan jadwal
  final WastePlanService _wastePlanService = WastePlanService();
  
  // ScrollController untuk halaman
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    currentMonth = DateTime(selectedDate.year, selectedDate.month);
    _updateDatesGrid();
    _scrollController = ScrollController();
  }

  void _updateDatesGrid() {
    setState(() {
      if (_currentView == CalendarView.monthly) {
        datesGrid = _generateDatesGrid(currentMonth);
      } else {
        datesGrid = _generateDatesGrid(null, weekOnly: true);
      }
    });
  }

  List<DateTime> _generateDatesGrid(DateTime? month, {bool weekOnly = false}) {
    if (weekOnly) {
      int weekdayAdjustment = selectedDate.weekday % 7;
      DateTime startOfWeek = selectedDate.subtract(Duration(days: weekdayAdjustment));
      return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    }

    final DateTime effectiveMonth = month ?? currentMonth;
    
    int numDays = DateTime(effectiveMonth.year, effectiveMonth.month + 1, 0).day;
    int firstWeekday = DateTime(effectiveMonth.year, effectiveMonth.month, 1).weekday % 7;
    List<DateTime> dates = [];

    DateTime previousMonth = DateTime(effectiveMonth.year, effectiveMonth.month - 1);
    int previousMonthLastDay =
        DateTime(previousMonth.year, previousMonth.month + 1, 0).day;
    for (int i = firstWeekday; i > 0; i--) {
      dates.add(DateTime(previousMonth.year, previousMonth.month,
          previousMonthLastDay - i + 1));
    }

    for (int day = 1; day <= numDays; day++) {
      dates.add(DateTime(effectiveMonth.year, effectiveMonth.month, day));
    }

    int remainingBoxes = 42 - dates.length;
    for (int day = 1; day <= remainingBoxes; day++) {
      dates.add(DateTime(effectiveMonth.year, effectiveMonth.month + 1, day));
    }

    return dates;
  }

  void _changeSelectedDate(int offset) {
    setState(() {
      if (_currentView == CalendarView.monthly) {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + offset);
        datesGrid = _generateDatesGrid(currentMonth);
      } else {
        // In weekly view, move forward or backward by 7 days (one week)
        selectedDate = selectedDate.add(Duration(days: 7 * offset));
        datesGrid = _generateDatesGrid(null, weekOnly: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan AppBar standar Flutter untuk menghindari masalah dengan GlobalAppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'JADWAL SAMPAH',
          style: TextStyle(
            color: AppColors.blue600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blue600),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        GlobalText(
                          text: "Form Jadwal Pemilahan",
                          variant: TextVariant.h5,
                          color: AppColors.blue600,
                        ),
                        SizedBox(height: 8.h),
                        GlobalText(
                          text: "Isi form dibawah ini untuk atur jadwal",
                          variant: TextVariant.mediumRegular,
                          color: AppColors.gray600,
                        ),
                        SizedBox(height: 30.h),

                        // Frequency Selection
                        GlobalText(
                          text: "Pilih Frekuensi Pemilahan Sampah",
                          variant: TextVariant.mediumBold,
                          color: AppColors.blue600,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: _frequencies.map((frequency) {
                            bool isSelected = _selectedFrequency == frequency;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedFrequency = frequency;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.blue600 : AppColors.gray100,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: GlobalText(
                                      text: frequency,
                                      variant: isSelected ? TextVariant.smallBold : TextVariant.smallRegular,
                                      color: isSelected ? Colors.white : AppColors.gray600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 30.h),

                        // Time Selection
                        GlobalText(
                          text: "Pilih Waktu Mulai Pemilahan Sampah",
                          variant: TextVariant.mediumBold,
                          color: AppColors.blue600,
                        ),
                        SizedBox(height: 10.h),
                        
                        // Custom Time Selector with side-by-side layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time display card on the left
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45, 
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.blue100,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GlobalText(
                                    text: "${_selectedTime.hour.toString().padLeft(2, '0')}",
                                    variant: TextVariant.largeBold,
                                    color: AppColors.blue600,
                                  ),
                                  SizedBox(width: 8.w),
                                  GlobalText(
                                    text: ".",
                                    variant: TextVariant.largeBold,
                                    color: AppColors.blue600,
                                  ),
                                  SizedBox(width: 8.w),
                                  GlobalText(
                                    text: "${_selectedTime.minute.toString().padLeft(2, '0')}",
                                    variant: TextVariant.largeBold,
                                    color: AppColors.blue600,
                                  ),
                                ],
                              ),
                            ),
                            
                            // Time options in a 2x2 grid on the right
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: 1.8,
                                mainAxisSpacing: 8.h,
                                crossAxisSpacing: 8.w,
                                children: [
                                  _buildTimeOption("07.00", isHighlighted: _selectedTime.hour == 7 && _selectedTime.minute == 0),
                                  _buildTimeOption("09.00", isHighlighted: _selectedTime.hour == 9 && _selectedTime.minute == 0),
                                  _buildTimeOption("11.00", isHighlighted: _selectedTime.hour == 11 && _selectedTime.minute == 0),
                                  _buildTimeOption("17.00", isHighlighted: _selectedTime.hour == 17 && _selectedTime.minute == 0),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

                        // Date Selection
                        GlobalText(
                          text: "Pilih tanggal mulai pemilahan sampah",
                          variant: TextVariant.mediumBold,
                          color: AppColors.blue600,
                        ),
                        SizedBox(height: 10.h),
                        
                        // Calendar header with monthly/weekly toggle
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => _changeSelectedDate(-1),
                                    child: Transform.scale(
                                      scaleX: -1,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.blue600,
                                        size: 24.r,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 160.w,
                                    child: Center(
                                      child: GlobalText(
                                        text: _currentView == CalendarView.monthly
                                          ? '${_getMonthName(currentMonth.month)} ${currentMonth.year}'
                                          : '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                                        variant: TextVariant.largeBold,
                                        color: AppColors.blue600,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _changeSelectedDate(1),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.blue600,
                                      size: 24.r,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_currentView == CalendarView.monthly) {
                                      _currentView = CalendarView.weekly;
                                    } else {
                                      _currentView = CalendarView.monthly;
                                    }
                                    _updateDatesGrid();
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColors.blue600,
                                      size: 24.r,
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      _currentView == CalendarView.monthly 
                                        ? Icons.keyboard_arrow_up 
                                        : Icons.keyboard_arrow_down,
                                      color: AppColors.gray600,
                                      size: 20.r,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Calendar container with white background
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: GlobalShadow.getShadow(ShadowVariant.xSmall),
                          ),
                          child: Column(
                            children: [
                              // Day names row
                              SizedBox(
                                height: 20.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(7, (index) {
                                    return Expanded(
                                      child: Center(
                                        child: GlobalText(
                                          text: _daysOfWeek[index],
                                          variant: TextVariant.smallSemiBold,
                                          color: AppColors.gray400,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              
                              SizedBox(height: 2.h),
                              
                              // Calendar Grid
                              _currentView == CalendarView.monthly 
                                ? _buildMonthlyView() 
                                : _buildWeeklyView(),
                            ],
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Create Schedule Button
                        GlobalButton(
                          text: "Buat Jadwal",
                          variant: ButtonVariant.large,
                          style: ButtonStyle.primary,
                          onPressed: _createSchedule,
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Bottom wave background - bisa diganti dengan komponen dari wanigo_ui jika ada
              Image.asset(
                'assets/icons/plan_typebg.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Monthly View Implementation
  Widget _buildMonthlyView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: datesGrid.length,
      itemBuilder: (context, index) {
        DateTime date = datesGrid[index];
        bool isCurrentMonth = date.month == currentMonth.month;
        bool isSelected = date.day == selectedDate.day && 
                         date.month == selectedDate.month && 
                         date.year == selectedDate.year;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue600 : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: GlobalText(
                text: date.day.toString(),
                variant: TextVariant.mediumBold,
                color: isSelected
                  ? Colors.white
                  : isCurrentMonth 
                    ? AppColors.blue600 
                    : AppColors.gray400,
              ),
            ),
          ),
        );
      },
    );
  }

  // Weekly View Implementation
  Widget _buildWeeklyView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: datesGrid.length,
      itemBuilder: (context, index) {
        DateTime date = datesGrid[index];
        bool isSelected = date.day == selectedDate.day && 
                         date.month == selectedDate.month && 
                         date.year == selectedDate.year;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue600 : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: GlobalText(
                text: date.day.toString(),
                variant: TextVariant.mediumBold,
                color: isSelected ? Colors.white : AppColors.blue600,
              ),
            ),
          ),
        );
      },
    );
  }

  // Build time option widget
  Widget _buildTimeOption(String time, {bool isHighlighted = false}) {
    return InkWell(
      onTap: () {
        final parts = time.split('.');
        setState(() {
          _selectedTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        });
      },
      child: Container(
        height: 30.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.blue600 : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: isHighlighted ? null : Border.all(color: AppColors.gray300),
        ),
        child: GlobalText(
          text: time,
          variant: TextVariant.xSmallBold,
          color: isHighlighted ? Colors.white : AppColors.gray600,
        ),
      ),
    );
  }

  // Helper method to get month name
  String _getMonthName(int monthNumber) {
    return [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ][monthNumber - 1];
  }

  // Method to handle schedule creation
  void _createSchedule() async {
    // Konversi frequency ke int
    int frequencyValue = 1; // default: Harian
    if (_selectedFrequency == 'Mingguan') {
      frequencyValue = 2;
    } else if (_selectedFrequency == 'Bulanan') {
      frequencyValue = 3;
    }
    
    // Format waktu
    String formattedTime = "${_selectedTime.hour.toString().padLeft(2, '0')}.${_selectedTime.minute.toString().padLeft(2, '0')}";
    
    try {
      // Generate ID baru
      int newId = await _wastePlanService.generateNewId();
      
      // Buat objek jadwal baru
      WastePlan newPlan = WastePlan(
        id: newId,
        type: 1, // 1 = Pemilahan Sampah
        frequency: frequencyValue,
        startingHours: formattedTime,
        startDate: selectedDate,
        planDate: null, // Tidak digunakan untuk jadwal pemilahan
        createdAt: DateTime.now(),
      );
      
      // Simpan jadwal
      await _wastePlanService.saveWastePlan(newPlan);
      
      // Tampilkan notifikasi berhasil
      GlobalModal.show(
        context: context,
        title: "Jadwal Berhasil Dibuat",
        message: "Jadwal pemilahan sampah berhasil dibuat untuk tanggal ${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year} pukul $formattedTime",
        primaryButtonText: "Lihat Semua Jadwal",
        secondaryButtonText: "Kembali ke Beranda",
        onPrimaryButtonPressed: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const CalendarPlanListScreen())
          );
        },
        onSecondaryButtonPressed: () {
          Navigator.pop(context); // Close modal
          Navigator.pop(context); // Back to previous screen
        },
      );
    } catch (e) {
      // Handle error
      GlobalModal.show(
        context: context,
        title: "Gagal Membuat Jadwal",
        message: "Terjadi kesalahan saat membuat jadwal. Silakan coba lagi.",
        primaryButtonText: "OK",
        onPrimaryButtonPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Calendar view enum
enum CalendarView {
  monthly,
  weekly
}