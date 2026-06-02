import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/catatan_ramadhan_viewmodel.dart';
import '../model/catatan_ramadhan_model.dart';
import 'catatan_ramadhan_detail_pages.dart';

class CatatanRamadhanPage extends StatelessWidget {
  const CatatanRamadhanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatatanRamadhanViewModel>();
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Shalat progress
    final shalat = vm.shalatReports.firstWhere(
      (r) => r.date == today,
      orElse: () => ShalatReport(date: today),
    );
    int shalatCount = 0;
    if (shalat.subuh) shalatCount++;
    if (shalat.dzuhur) shalatCount++;
    if (shalat.ashar) shalatCount++;
    if (shalat.maghrib) shalatCount++;
    if (shalat.isya) shalatCount++;

    // Ceramah & Infaq entries for today
    final todayCeramah =
        vm.ceramahEntries.where((e) => e.date == today).toList();
    final todayInfaq =
        vm.infaqEntries.where((e) => e.date == today).toList();

    bool hasCeramah = todayCeramah.isNotEmpty;
    bool hasInfaq = todayInfaq.isNotEmpty;
    final totalInfaq =
        todayInfaq.fold<double>(0, (sum, e) => sum + e.nominal);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: const Text('Catatan Ramadhan'),
        backgroundColor: const Color(0xFF546B41),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            title: 'Laporan Shalat',
            subtitle: 'Catat ibadah shalat fardhu 5 waktu hari ini',
            icon: Icons.mosque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CatatanDetailPage(initialTab: 0)),
            ),
            statusWidget: Row(
              children: [
                Text(
                  "$shalatCount/5 Selesai",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF546B41),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: ['S', 'D', 'A', 'M', 'I'].asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    bool active = false;
                    if (index == 0) active = shalat.subuh;
                    if (index == 1) active = shalat.dzuhur;
                    if (index == 2) active = shalat.ashar;
                    if (index == 3) active = shalat.maghrib;
                    if (index == 4) active = shalat.isya;
                    return Container(
                      margin: const EdgeInsets.only(left: 2),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? const Color(0xFF546B41) : Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: active ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          _buildMenuCard(
            context,
            title: 'Laporan Ceramah',
            subtitle: 'Tulis ringkasan ceramah/kajian ramadhan hari ini',
            icon: Icons.menu_book,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CatatanDetailPage(initialTab: 1)),
            ),
            statusWidget: hasCeramah
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF546B41).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, size: 12, color: Color(0xFF546B41)),
                        const SizedBox(width: 4),
                        Text(
                          '${todayCeramah.length} catatan',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF546B41),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    "Belum diisi",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
          ),
          _buildMenuCard(
            context,
            title: 'Laporan Infaq',
            subtitle: 'Catat amalan sedekah dan infaq harian Anda',
            icon: Icons.volunteer_activism,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CatatanDetailPage(initialTab: 2)),
            ),
            statusWidget: hasInfaq
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF546B41).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 12, color: Color(0xFF546B41)),
                        const SizedBox(width: 4),
                        Text(
                          "Rp ${totalInfaq.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF546B41),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    "Belum diisi",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Widget statusWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF546B41).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: const Color(0xFF546B41), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF454040),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hari Ini:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    statusWidget,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
