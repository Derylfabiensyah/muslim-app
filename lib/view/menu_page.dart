import 'package:flutter/material.dart';
import 'package:muslim_app/view/dzikir_page.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/model/shalat_schedule_response.dart';
import 'package:muslim_app/view/asma_page.dart';
import 'package:muslim_app/view/chat_page.dart';
import 'package:muslim_app/view/doa_page.dart';
import 'package:muslim_app/view/kiblat_page.dart';
import 'package:muslim_app/view/quran_page.dart';
import 'package:muslim_app/view/tasbih_page.dart';
import 'package:muslim_app/view/shalat_page.dart';
import 'package:muslim_app/viewmodel/shalat_view_model.dart';

import 'package:muslim_app/view/catatan_ramadhan_page.dart';
import 'package:muslim_app/view/quran_quote_card.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShalatViewModel>().fetchMonthlySchedule(
            cityId: 1206,
            year: DateTime.now().year,
            month: DateTime.now().month,
          );
    });
  }

  void _setPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shalatVm = context.watch<ShalatViewModel>();
    final schedule = shalatVm.scheduleToday;

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MenuPage(onNavigate: _setPage, schedule: schedule),
          const DoaPage(),
          const SuratPage(),
          const KiblatPage(),
          const AsmaPage(),
          const TasbihPage(),
          const ShalatPage(),
          const DzikirPage()
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(
                context,
                Icons.home,
                'home',
                active: _currentIndex == 0,
                onTap: () => _setPage(0),
              ),
              _navItem(
                context,
                Icons.bookmarks,
                'doa',
                active: _currentIndex == 1,
                onTap: () => _setPage(1),
              ),
              const SizedBox(width: 72),
              _navItem(
                context,
                Icons.menu_book,
                'quran',
                active: _currentIndex == 2,
                onTap: () => _setPage(2),
              ),
              _navItem(
                context,
                Icons.explore,
                'kiblat',
                active: _currentIndex == 3,
                onTap: () => _setPage(3),
              ),
            ],
          ),
          Positioned(
            top: -24,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: Colors.white24,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: ChatPage(hideAppBar: true),
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF99AD7A), Color(0xFF546B41)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white54,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.forum,
                              color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Chat AI',
                        style: TextStyle(
                          color: Color(0xFF546B41),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool active = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? const Color(0xFF546B41) : Colors.grey),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? const Color(0xFF546B41) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  final ShalatDaySchedule? schedule;

  const MenuPage({super.key, required this.onNavigate, required this.schedule});

  String get _todayLabel {
    final now = DateTime.now();
    final weekDays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return weekDays[now.weekday - 1];
  }

  String _upcomingPrayerLabel(ShalatDaySchedule? schedule) {
    if (schedule == null) return 'Subuh';

    final now = DateTime.now();
    final prayers = {
      'Subuh': schedule.subuh,
      'Dzuhur': schedule.dzuhur,
      'Ashar': schedule.ashar,
      'Maghrib': schedule.maghrib,
      'Isya': schedule.isya,
    };

    for (final entry in prayers.entries) {
      final prayerTime = _parseTime(entry.value, now);
      if (prayerTime != null && now.isBefore(prayerTime)) {
        return entry.key;
      }
    }

    return 'Subuh';
  }

  DateTime? _parseTime(String timeText, DateTime today) {
    final parts = timeText.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(today.year, today.month, today.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _buildTopCard(schedule),
                  const SizedBox(height: 16),
                  _buildRamadhanCard(context),
                  const SizedBox(height: 16),
                  _buildGridMenu(context),
                  const SizedBox(height: 16),
                  const QuranQuoteCard(),
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF546B41),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/muslim-logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assalamu\'alaikum',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Semoga hari ini membawa berkah dan ketenangan.',
                  style: TextStyle(
                    color: Color(0xFF99AD7A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard(ShalatDaySchedule? schedule) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Bagian Atas: Info Shalat & Hari
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, // Menjaga elemen tetap rata atas
              children: [
                // Kolom Kiri: Menunjukkan waktu shalat berikutnya
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_filled, size: 14, color: Color(0xFF546B41)),
                        SizedBox(width: 4),
                        Text(
                          "Menjelang",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _upcomingPrayerLabel(schedule),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hari", 
                      style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      _todayLabel,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -1),
                    ),
                  ],
                ),
                 
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF546B41),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
                    ]
                  ),
                  child: const Icon(Icons.mosque, color: Colors.white, size: 28),
                )
              ],
            ),
            
            const Divider(height: 30, thickness: 1, color: Color(0xFFEEEEEE)),

            // Bagian Ikon Shalat 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _prayerTimeItem(
                  "Isya", 
                  schedule?.isya ?? "--:--", 
                  Icons.nightlight_round,
                  const Color(0xFFE8EAF6),
                  const Color(0xFF1A237E),
                ),
                _prayerTimeItem(
                  "Subuh", 
                  schedule?.subuh ?? "--:--", 
                  Icons.wb_twilight, 
                  const Color(0xFFFBE9E7),
                  const Color(0xFF00695C),
                ),
                _prayerTimeItem(
                  "Dzuhur", 
                  schedule?.dzuhur ?? "--:--", 
                  Icons.wb_sunny, 
                  const Color(0xFFFFF3E0),
                  const Color(0xFFF57C00),
                ),
                _prayerTimeItem(
                  "Ashar", 
                  schedule?.ashar ?? "--:--", 
                  Icons.wb_sunny_outlined, 
                  const Color(0xFFE0F2F1),
                  const Color(0xFF2E7D32),
                ),
                _prayerTimeItem(
                  "Magrib", 
                  schedule?.maghrib ?? "--:--", 
                  Icons.wb_cloudy_rounded, 
                  const Color(0xFFF3E5F5),
                  const Color(0xFF6D4C41),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _prayerTimeItem(String name, String time, IconData icon, Color bg, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bg, 
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            size: 20, 
            color: iconColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name, 
          style: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time, 
          style: TextStyle(
            fontSize: 11, 
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRamadhanCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CatatanRamadhanPage()),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF546B41).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF546B41),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Catatan Ramadhan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF454040),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Siapkan amalan terbaik, perbanyak doa dan dzikir selama bulan suci ini.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF605B51),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          'Isi Jurnal Ramadhan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF546B41),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF546B41),
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF99AD7A), Color(0xFF546B41)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF546B41).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: [
        _gridItem(
          context,
          icon: Icons.auto_awesome,
          title: 'Asmaul Husna',
          iconColor: const Color(0xFF546B41),
          bgColor: const Color.fromARGB(255, 226, 238, 208),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AsmaPage())),
        ),
        _gridItem(
          context,
          icon: Icons.auto_awesome_motion,
          title: 'Tasbih',
          iconColor: const Color(0xFF546B41),
          bgColor: const Color.fromARGB(255, 226, 238, 208),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TasbihPage())),
        ),
        _gridItem(
          context,
          icon: Icons.self_improvement,
          title: 'Dzikir',
          iconColor: const Color(0xFF546B41),
          bgColor: const Color.fromARGB(255, 226, 238, 208),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DzikirPage())),
        ),
        _gridItem(
          context,
          icon: Icons.watch_later,
          title: 'Jadwal Shalat',
          iconColor: const Color(0xFF546B41),
          bgColor: const Color.fromARGB(255, 226, 238, 208),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShalatPage())),
        ),
      ],
    );
  }

  Widget _gridItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor, // Parameter baru
    required Color bgColor,   // Parameter baru
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        // Padding dikurangi sedikit agar tidak terlalu sesak (opsional)
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor, // Warna latar belakang ikon (soft)
                borderRadius: BorderRadius.circular(20), // Lebih membulat sesuai gambar
              ),
              child: Icon(icon, color: iconColor, size: 30), // Warna ikon kontras
            ),
            const SizedBox(height: 12), // Jarak antara ikon dan teks
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
