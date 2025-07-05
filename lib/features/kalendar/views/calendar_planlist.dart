// lib/features/kalendar/views/calendar_planlist.dart
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

// Import dengan path yang benar
import 'package:wanigo_nasabah/data/models/wasteplan_model.dart';
import 'package:wanigo_nasabah/essentials/app_colors.dart';
import 'package:wanigo_nasabah/features/kalendar/services/wasteplan_service.dart';
import 'package:wanigo_nasabah/features/kalendar/views/planoption.dart';

class CalendarPlanListScreen extends StatefulWidget {
  const CalendarPlanListScreen({Key? key}) : super(key: key);

  @override
  _CalendarPlanListScreenState createState() => _CalendarPlanListScreenState();
}

class _CalendarPlanListScreenState extends State<CalendarPlanListScreen> {
  final WastePlanService _wastePlanService = WastePlanService();
  List<WastePlan> _wastePlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWastePlans();
  }

  Future<void> _loadWastePlans() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final plans = await _wastePlanService.readWastePlans();
      setState(() {
        _wastePlans = plans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading waste plans: $e');
    }
  }

  // Delete a waste plan
  Future<void> _deletePlan(WastePlan plan) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Jadwal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal ${plan.typeDescription}?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: TextStyle(
                color: AppColors.gray600,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _wastePlanService.deleteWastePlan(plan.id);
      _loadWastePlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Daftar Jadwal Sampah',
          style: TextStyle(
            color: AppColors.blue600,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blue600),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.blue600),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanTypeScreen()),
              ).then((_) => _loadWastePlans());
            },
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _wastePlans.isEmpty 
          ? _buildEmptyState() 
          : _buildPlanList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/add_calendar1.png',
            width: 120,
            height: 120,
          ),
          const Gap(20),
          GlobalText(
            text: 'Belum Ada Jadwal Sampah',
            variant: TextVariant.h5,
          ),
          const Gap(10),
          GlobalText(
            text: 'Buat jadwal pemilahan atau setoran sampah untuk memulai',
            variant: TextVariant.mediumRegular,
            color: AppColors.gray400,
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          GlobalButton(
            text: "Buat Jadwal Baru",
            variant: ButtonVariant.large,
            style: ButtonStyle.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanTypeScreen()),
              ).then((_) => _loadWastePlans());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanList() {
    // Separate plans by type
    final pemilahSampahPlans = _wastePlans.where((plan) => plan.type == 1).toList();
    final setorSampahPlans = _wastePlans.where((plan) => plan.type == 2).toList();

    return ListView(
      padding: EdgeInsets.all(16.r),
      children: [
        // Pemilahan Sampah Section
        if (pemilahSampahPlans.isNotEmpty) ...[
          _buildPlanSection(
            title: 'Jadwal Pemilahan Sampah',
            plans: pemilahSampahPlans,
          ),
          Gap(20.h),
        ],

        // Setoran Sampah Section
        if (setorSampahPlans.isNotEmpty) ...[
          _buildPlanSection(
            title: 'Jadwal Setoran Sampah',
            plans: setorSampahPlans,
          ),
        ],
      ],
    );
  }

  Widget _buildPlanSection({
    required String title,
    required List<WastePlan> plans,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          text: title,
          variant: TextVariant.h5,
          color: AppColors.blue600,
        ),
        Gap(10.h),
        ...plans.map((plan) => _buildPlanCard(plan)).toList(),
      ],
    );
  }

  Widget _buildPlanCard(WastePlan plan) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    text: _getPlanDescription(plan),
                    variant: TextVariant.mediumSemiBold,
                    color: AppColors.blue600,
                  ),
                  Gap(8.h),
                  GlobalText(
                    text: 'Waktu: ${plan.startingHoursDescription}',
                    variant: TextVariant.smallRegular,
                    color: AppColors.gray400,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePlan(plan),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get plan description
  String _getPlanDescription(WastePlan plan) {
    if (plan.type == 1) {
      // Pemilahan Sampah
      return "${plan.typeDescription} - ${plan.frequencyDescription} "
             "mulai ${DateFormat('dd MMM yyyy').format(plan.startDate!)}";
    } else {
      // Setoran Sampah
      return "${plan.typeDescription} "
             "pada ${DateFormat('dd MMM yyyy').format(plan.planDate!)}";
    }
  }
}