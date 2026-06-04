import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';

class ShalatPage extends StatefulWidget {
  static const routeName = '/shalat';
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  final int cityId = 1206;
  late int selectedYear;
  late int selectedMonth;

  final List<String> _months = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  final List<int> _years = List.generate(11, (index) => 2020 + index); // 2020 to 2030

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSchedule();
    });
  }

  void _loadSchedule() {
    context.read<ShalatViewModel>().fetchMonthlySchedule(
          cityId: cityId,
          year: selectedYear,
          month: selectedMonth,
        );
  }

  Widget _buildFilterCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Bulan",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF546B41)),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text(
                          _months[index],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedMonth = val;
                        });
                        _loadSchedule();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Tahun",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF546B41)),
                    items: _years.map((y) {
                      return DropdownMenuItem<int>(
                        value: y,
                        child: Text(
                          "$y",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedYear = val;
                        });
                        _loadSchedule();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 40, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF546B41),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Jadwal Shalat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // spacer
              ],
            ),
          ),

          /// FILTER CARD
          _buildFilterCard(),

          /// CONTENT
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF546B41),
                    ),
                  );
                }

                if (vm.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gagal memuat data\n${vm.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadSchedule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF546B41),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
                  itemCount: vm.schedules.length,
                  itemBuilder: (context, i) {
                    final d = vm.schedules[i];
                    final bool isToday = (selectedYear == now.year && selectedMonth == now.month && (i + 1) == now.day);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isToday ? const Color(0xFF546B41).withValues(alpha: 0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: isToday
                            ? Border.all(color: const Color(0xFF546B41), width: 1.5)
                            : Border.all(color: Colors.transparent, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TANGGAL
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16,
                                      color: isToday ? const Color(0xFF546B41) : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      d.tanggal,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isToday ? const Color(0xFF546B41) : const Color(0xFF333333),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isToday)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF546B41),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "HARI INI",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const Divider(height: 24),

                            _timeRow('Imsak', d.imsak, isToday),
                            _timeRow('Subuh', d.subuh, isToday),
                            _timeRow('Terbit', d.terbit, isToday),
                            _timeRow('Dhuha', d.dhuha, isToday),
                            _timeRow('Dzuhur', d.dzuhur, isToday),
                            _timeRow('Ashar', d.ashar, isToday),
                            _timeRow('Maghrib', d.maghrib, isToday),
                            _timeRow('Isya', d.isya, isToday),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(String label, String time, bool isToday) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              color: isToday ? const Color(0xFF3D5230) : const Color(0xFF555555),
              fontWeight: isToday ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          Text(
            time.isEmpty ? '-' : time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isToday ? const Color(0xFF546B41) : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
