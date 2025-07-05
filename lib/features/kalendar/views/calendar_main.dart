// lib/features/kalendar/views/calendar_main.dart
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/features/kalendar/views/planoption.dart';
import 'package:wanigo_nasabah/features/kalendar/views/wasteform.dart';

// Import GlobalAppBar dengan path yang benar
import '../widgets/global_app_bar.dart';

// Model untuk Jadwal Sampah
class WasteSchedule {
  final int id;
  final String title;
  final ScheduleType type;
  final String startTime;
  ScheduleStatus status;

  WasteSchedule({
    required this.id,
    required this.title,
    required this.type,
    required this.startTime,
    required this.status,
  });
}

// Enum untuk tipe jadwal
enum ScheduleType {
  sorting,   // Pemilahan sampah
  deposit,   // Setoran sampah
}

// Enum untuk status jadwal
enum ScheduleStatus {
  upcoming,   // Akan datang
  ongoing,    // Sedang berlangsung
  completed,  // Selesai
}

// Calendar view enum
enum CalendarView {
  monthly,
  weekly
}

// Screen untuk menampilkan konfirmasi jadwal selesai
class ScheduleCompletedScreen extends StatelessWidget {
  final ScheduleType scheduleType;
  
  const ScheduleCompletedScreen({
    Key? key,
    required this.scheduleType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'LAPORAN',
          style: TextStyle(
            color: AppColors.blue600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: Container(), // Hide back button
      ),
      body: Container(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/task_complete.png',
              width: 120.r,
              height: 120.r,
            ),
            SizedBox(height: 24.h),
            GlobalText(
              text: scheduleType == ScheduleType.sorting
                ? "Pemilahan Sampah Sudah Selesai!"
                : "Setoran Sampah Sudah Selesai!",
              variant: TextVariant.h5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            GlobalText(
              text: "Jadwal ${scheduleType == ScheduleType.sorting ? 'pemilahan' : 'setoran'} sampah berhasil diselesaikan. Terima kasih telah berkontribusi menjaga kebersihan lingkungan! 🌏",
              variant: TextVariant.mediumRegular,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            GlobalButton(
              text: "Kembali",
              variant: ButtonVariant.large,
              style: ButtonStyle.primary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}

class CalendarMainScreen extends StatefulWidget {
  const CalendarMainScreen({Key? key}) : super(key: key);

  @override
  State<CalendarMainScreen> createState() => _CalendarMainScreenState();
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  late DateTime currentMonth;
  late DateTime selectedDate;
  late List<DateTime> datesGrid;
  final GlobalKey _calendarKey = GlobalKey();
  CalendarView _currentView = CalendarView.monthly;

  // Background color untuk aplikasi
  static const Color _backgroundColor = Color(0xFFE8ECFC);

  // SIMULASI DATA JADWAL - nantinya dari API/database
  // Format data: Map<String, List<WasteSchedule>>
  // Key: "yyyy-MM-dd", Value: List jadwal di tanggal tersebut
  final Map<String, List<WasteSchedule>> _schedules = {
    "2025-03-31": [
      WasteSchedule(
        id: 1, 
        title: "Pemilahan Sampah #1", 
        type: ScheduleType.sorting, 
        startTime: "07:00", 
        status: ScheduleStatus.ongoing,
      ),
    ],
    "2025-03-30": [
      WasteSchedule(
        id: 2, 
        title: "Setoran Sampah", 
        type: ScheduleType.deposit, 
        startTime: "10:00", 
        status: ScheduleStatus.upcoming,
      ),
    ],
    "2025-04-05": [
      WasteSchedule(
        id: 3,
        title: "Pemilahan Sampah #2",
        type: ScheduleType.sorting,
        startTime: "09:00",
        status: ScheduleStatus.upcoming,
      ),
    ],
  };
  
  // SIMULASI STATUS USER - nantinya dari user management
  bool _isRegisteredMember = true; // true = terdaftar, false = belum terdaftar
  bool _hasCreatedSchedule = true; // true = sudah ada jadwal, false = belum ada jadwal
  
  // Simulasi jadwal yang dipilih - nantinya dari API/database
  WasteSchedule? _selectedSchedule;

  // Flag untuk menampilkan popup
  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    currentMonth = DateTime(selectedDate.year, selectedDate.month);
    _updateDatesGrid();
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

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      
      // Cek apakah ada jadwal di tanggal yang dipilih
      String dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      
      if (_schedules.containsKey(dateKey) && _schedules[dateKey]!.isNotEmpty) {
        _selectedSchedule = _schedules[dateKey]![0]; // Ambil jadwal pertama
      } else {
        _selectedSchedule = null;
      }
    });
  }

  // Fungsi untuk menampilkan popup
  void _showSchedulePopup(WasteSchedule schedule) {
    setState(() {
      _selectedSchedule = schedule;
      _showPopup = true;
    });
  }

  // Fungsi untuk menutup popup
  void _hidePopup() {
    setState(() {
      _showPopup = false;
    });
  }

  // Fungsi untuk menandai jadwal selesai
  void _markScheduleComplete() {
    // Implementasi nantinya: update status jadwal ke database
    // Untuk demo, kita akan mengubah status jadwal di memory
    setState(() {
      if (_selectedSchedule != null) {
        _selectedSchedule!.status = ScheduleStatus.completed;
      }
      _showPopup = false;
    });
    
    // Demo: menampilkan halaman "Jadwal Selesai"
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleCompletedScreen(
          scheduleType: _selectedSchedule?.type ?? ScheduleType.sorting,
        ),
      ),
    );
  }

  // Helper untuk cek apakah tanggal memiliki jadwal
  bool _hasSchedule(DateTime date) {
    String dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return _schedules.containsKey(dateKey) && _schedules[dateKey]!.isNotEmpty;
  }

  // Helper untuk mendapatkan warna indikator jadwal
  Color _getScheduleIndicatorColor(DateTime date) {
    String dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    if (_schedules.containsKey(dateKey) && _schedules[dateKey]!.isNotEmpty) {
      // Jika ada lebih dari satu jadwal, prioritaskan yang sedang berlangsung
      WasteSchedule? ongoingSchedule = _schedules[dateKey]!
          .firstWhere((schedule) => schedule.status == ScheduleStatus.ongoing, 
                     orElse: () => _schedules[dateKey]![0]);
      
      return ongoingSchedule.type == ScheduleType.sorting 
          ? AppColors.blue600 
          : AppColors.green600;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'KALENDAR',
          style: TextStyle(
            color: AppColors.blue600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppColors.blue600),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Calendar header
              Container(
                color: _backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _changeSelectedDate(-1),
                          child: Icon(
                            Icons.chevron_left,
                            color: AppColors.blue600,
                            size: 24.r,
                          ),
                        ),
                        Container(
                          width: 160.w,
                          child: Center(
                            child: GlobalText(
                              text: _currentView == CalendarView.monthly
                                ? '${_monthName(currentMonth.month)} ${currentMonth.year}'
                                : '${_monthName(selectedDate.month)} ${selectedDate.year}',
                              variant: TextVariant.largeBold,
                              color: AppColors.blue600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _changeSelectedDate(1),
                          child: Icon(
                            Icons.chevron_right,
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

              // Calendar view dengan day names dan grid
              Container(
                // Height yang berbeda berdasarkan mode view
                height: _currentView == CalendarView.monthly ? 280.h : 100.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    
                    // Day names row
                    SizedBox(
                      height: 20.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(7, (index) {
                          final days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
                          return Expanded(
                            child: Center(
                              child: GlobalText(
                                text: days[index],
                                variant: TextVariant.smallSemiBold,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    SizedBox(height: 2.h),
                    
                    // Calendar Grid
                    Expanded(
                      child: _currentView == CalendarView.monthly 
                        ? _buildMonthlyView() 
                        : _buildWeeklyView(),
                    ),
                  ],
                ),
              ),

              // Bottom Content Section - conditional rendering based on user status
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _isRegisteredMember 
                    ? (_hasCreatedSchedule
                        ? _buildScheduleListSection()
                        : _buildNoScheduleSection())
                    : _buildNotRegisteredSection(),
                ),
              ),
            ],
          ),

          // Popup Dialog - hanya tampil jika _showPopup == true
          if (_showPopup && _selectedSchedule != null)
            _buildScheduleActionPopup(),
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
        bool isSelected = date.year == selectedDate.year && 
                         date.month == selectedDate.month && 
                         date.day == selectedDate.day;
        bool hasSchedule = _hasSchedule(date);
        
        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue600 : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GlobalText(
                  text: date.day.toString(),
                  variant: TextVariant.mediumBold,
                  color: isSelected 
                    ? Colors.white 
                    : (isCurrentMonth 
                        ? AppColors.blue600
                        : AppColors.gray400),
                ),
                if (hasSchedule)
                  Positioned(
                    bottom: 2.h,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: _getScheduleIndicatorColor(date),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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
        bool isSelected = date.year == selectedDate.year && 
                         date.month == selectedDate.month && 
                         date.day == selectedDate.day;
        bool hasSchedule = _hasSchedule(date);
        
        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue600 : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GlobalText(
                  text: date.day.toString(),
                  variant: TextVariant.mediumBold,
                  color: isSelected ? Colors.white : AppColors.blue600,
                ),
                if (hasSchedule)
                  Positioned(
                    bottom: 2.h,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: _getScheduleIndicatorColor(date),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Popup dialog ketika card jadwal diklik
  Widget _buildScheduleActionPopup() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          width: 300.w,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/trash_recycle.png',
                width: 80.r,
                height: 80.r,
              ),
              SizedBox(height: 16.h),
              GlobalText(
                text: "Mulai Pemilahan Sampah",
                variant: TextVariant.largeBold,
              ),
              SizedBox(height: 8.h),
              GlobalText(
                text: "Lapor hasil pemilahan sampah Anda untuk menyelesaikan jadwal pemilahan hari ini",
                variant: TextVariant.smallRegular,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              GlobalButton(
                text: "Tandai Selesai",
                variant: ButtonVariant.medium,
                style: ButtonStyle.primary,
                onPressed: _markScheduleComplete,
              ),
              SizedBox(height: 12.h),
              GlobalButton(
                text: "Kembali",
                variant: ButtonVariant.medium,
                style: ButtonStyle.secondary,
                onPressed: _hidePopup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Month name helper
  String _monthName(int monthNumber) {
    return [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ][monthNumber - 1];
  }
  
  // Bagian jika user belum terdaftar sebagai nasabah bank sampah
  Widget _buildNotRegisteredSection() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/jadi-nasabah.png',
            width: 100.r,
            height: 100.r,
          ),
          SizedBox(height: 24.h),
          GlobalText(
            text: "Daftar Jadi Nasabah Bank Sampah",
            variant: TextVariant.h5,
            textAlign: TextAlign.center,
          ),
          GlobalText(
            text: "Untuk Mulai Jadwal Pemilahan",
            variant: TextVariant.h5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          GlobalText(
            text: "Pastikan kamu menjadi nasabah bank sampah sebelum mengatur jadwal pemilahan. Daftar sekarang untuk memulai pengelolaan sampah",
            variant: TextVariant.mediumRegular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          GlobalButton(
            text: "Temukan Bank Sampah Terdekat",
            variant: ButtonVariant.large,
            style: ButtonStyle.primary,
            onPressed: () {
              // TODO: Navigate to bank sampah search screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => BankSampahSearchScreen()));
            },
          ),
        ],
      ),
    );
  }

  // Bagian jika user sudah terdaftar tapi belum membuat jadwal
  Widget _buildNoScheduleSection() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/add_calendar1.png',
            width: 90.r,
            height: 90.r,
          ),
          SizedBox(height: 12.h),
          GlobalText(
            text: "Jadwal Belum Dibuat",
            variant: TextVariant.h5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          GlobalText(
            text: "Buat jadwal pemilahan atau setoran sampah untuk memulai proses pengelolaan sampah yang lebih teratur dan efisien",
            variant: TextVariant.mediumRegular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          GlobalButton(
            text: "Buat Jadwal",
            variant: ButtonVariant.large,
            style: ButtonStyle.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanTypeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Bagian jika user sudah terdaftar dan sudah ada jadwal
  Widget _buildScheduleListSection() {
    // Jika ada tanggal yang dipilih dan tanggal tersebut memiliki jadwal
    String dateKey = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    bool hasSelectedDateSchedule = _schedules.containsKey(dateKey) && _schedules[dateKey]!.isNotEmpty;
    
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            text: hasSelectedDateSchedule 
              ? "Jadwal Sampah Sedang Berlangsung"
              : "Daftar Jadwal Sampah Sudah Terbuat",
            variant: TextVariant.mediumBold,
          ),
          SizedBox(height: 16.h),
          
          // Jika tanggal yang dipilih memiliki jadwal, tampilkan detailnya
          // Jika tidak, tampilkan jadwal terdekat
          if (hasSelectedDateSchedule)
            ..._schedules[dateKey]!.map((schedule) => _buildScheduleCard(schedule)).toList()
          else
            _buildSchedulesList(),
          
          Spacer(),
          GlobalButton(
            text: "Buat Jadwal Baru",
            variant: ButtonVariant.large,
            style: ButtonStyle.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanTypeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar jadwal (maks. 2 kartu jadwal)
  Widget _buildSchedulesList() {
    // Filter untuk mendapatkan jadwal pemilahan dan setoran
    List<WasteSchedule> sortingSchedules = [];
    List<WasteSchedule> depositSchedules = [];
    
    _schedules.forEach((date, schedules) {
      for (var schedule in schedules) {
        if (schedule.type == ScheduleType.sorting && sortingSchedules.isEmpty) {
          sortingSchedules.add(schedule);
        } else if (schedule.type == ScheduleType.deposit && depositSchedules.isEmpty) {
          depositSchedules.add(schedule);
        }
      }
    });
    
    return Column(
      children: [
        // Tampilkan jadwal pemilahan sampah (jika ada)
        if (sortingSchedules.isNotEmpty)
          _buildScheduleSummaryCard(
            sortingSchedules.first,
            "Jadwal Pemilahan Sampah",
            "Mulai tanggal ${_getDayAndMonth(sortingSchedules.first)}"
          ),
          
        SizedBox(height: sortingSchedules.isNotEmpty ? 12.h : 0),
        
        // Tampilkan jadwal setoran sampah (jika ada)
        if (depositSchedules.isNotEmpty)
          _buildScheduleSummaryCard(
            depositSchedules.first,
            "Jadwal Setoran Sampah",
            "Mulai tanggal ${_getDayAndMonth(depositSchedules.first)}"
          ),
          
        // Jika tidak ada jadwal sama sekali
        if (sortingSchedules.isEmpty && depositSchedules.isEmpty)
          Center(
            child: GlobalText(
              text: "Belum ada jadwal mendatang",
              variant: TextVariant.mediumRegular,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  // Helper untuk mendapatkan tanggal dari jadwal
  String _getDayAndMonth(WasteSchedule schedule) {
    // Ini hanya contoh. Dalam implementasi nyata, tanggal akan disimpan dalam jadwal
    for (var entry in _schedules.entries) {
      if (entry.value.contains(schedule)) {
        List<String> dateParts = entry.key.split('-');
        int day = int.parse(dateParts[2]);
        int month = int.parse(dateParts[1]);
        return "$day ${_monthName(month)}";
      }
    }
    return "?";
  }

// Card untuk jadwal di tanggal yang dipilih
  Widget _buildScheduleCard(WasteSchedule schedule) {
    return GestureDetector(
      onTap: () => _showSchedulePopup(schedule),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 40.h,
              color: schedule.type == ScheduleType.sorting 
                ? AppColors.blue600 
                : AppColors.green600,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    text: schedule.title,
                    variant: TextVariant.mediumSemiBold,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText(
                    text: "Dimulai pada pukul ${schedule.startTime} WIB",
                    variant: TextVariant.smallRegular,
                    color: AppColors.gray600,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: schedule.status == ScheduleStatus.ongoing
                  ? AppColors.blue600
                  : (schedule.status == ScheduleStatus.upcoming 
                      ? AppColors.gray400 
                      : AppColors.green600),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: GlobalText(
                text: schedule.status == ScheduleStatus.ongoing
                  ? "Berlangsung"
                  : (schedule.status == ScheduleStatus.upcoming 
                      ? "Akan Datang" 
                      : "Selesai"),
                variant: TextVariant.xSmallBold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Modifikasi pada _buildScheduleSummaryCard di calendar_main.dart
// Hapus parameter yang tidak didukung dan hanya gunakan push tanpa parameter tambahan

Widget _buildScheduleSummaryCard(WasteSchedule schedule, String title, String dateInfo) {
  return GestureDetector(
    onTap: () {
      // Arahkan ke halaman waste form tanpa parameter tambahan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WasteSortingScheduleForm(),
        ),
      ).then((_) {
        // Refresh data setelah kembali dari form
        setState(() {
          // Nanti akan diimplementasikan untuk refresh data dari backend
        });
      });
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.blue100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            color: schedule.type == ScheduleType.sorting 
              ? AppColors.blue600 
              : AppColors.green600,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  text: title,
                  variant: TextVariant.mediumSemiBold,
                ),
                SizedBox(height: 4.h),
                GlobalText(
                  text: dateInfo,
                  variant: TextVariant.smallRegular,
                  color: AppColors.gray600,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.blue600,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: GlobalText(
              text: "Rutin ${schedule.type == ScheduleType.sorting ? 'harian' : 'mingguan'}",
              variant: TextVariant.xSmallBold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

  // Card untuk jadwal terdekat (jika tanggal yang dipilih tidak memiliki jadwal)
  Widget _buildNextScheduleCard() {
    // Cari jadwal terdekat dari semua jadwal yang ada
    DateTime now = DateTime.now();
    WasteSchedule? nextSchedule;
    DateTime? nextScheduleDate;
    
    _schedules.forEach((dateStr, scheduleList) {
      if (scheduleList.isNotEmpty) {
        List<String> dateParts = dateStr.split('-');
        DateTime scheduleDate = DateTime(
          int.parse(dateParts[0]), 
          int.parse(dateParts[1]), 
          int.parse(dateParts[2])
        );
        
        if (scheduleDate.isAfter(now) || scheduleDate.day == now.day) {
          if (nextScheduleDate == null || scheduleDate.isBefore(nextScheduleDate!)) {
            nextScheduleDate = scheduleDate;
            nextSchedule = scheduleList[0]; // Ambil jadwal pertama
          }
        }
      }
    });
    
    if (nextSchedule != null && nextScheduleDate != null) {
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 40.h,
              color: nextSchedule!.type == ScheduleType.sorting 
                ? AppColors.blue600 
                : AppColors.green600,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    text: nextSchedule!.title,
                    variant: TextVariant.mediumSemiBold,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText(
                    text: "Mulai tanggal ${nextScheduleDate!.day} ${_monthName(nextScheduleDate!.month)} ${nextScheduleDate!.year}",
                    variant: TextVariant.smallRegular,
                    color: AppColors.gray600,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.blue600,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: GlobalText(
                text: "Jadwal Berikutnya",
                variant: TextVariant.xSmallBold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    
    // Jika tidak ada jadwal terdekat, tampilkan placeholder
    return Center(
      child: GlobalText(
        text: "Belum ada jadwal mendatang",
        variant: TextVariant.mediumRegular,
        color: Colors.grey,
      ),
    );
  }
}