import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodel/catatan_ramadhan_viewmodel.dart';
import '../model/catatan_ramadhan_model.dart';

const Color primaryColor = Color(0xFF4A6741);
const Color bgColor = Color(0xFFF0F2E8);
const Color cardLight = Color(0xFFEAF2E0);

// ─────────────────────────────────────────────
//  MAIN PAGE  (tab container)
// ─────────────────────────────────────────────
class CatatanDetailPage extends StatefulWidget {
  final int initialTab;
  const CatatanDetailPage({super.key, this.initialTab = 0});

  @override
  State<CatatanDetailPage> createState() => _CatatanDetailPageState();
}

class _CatatanDetailPageState extends State<CatatanDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Catatan',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              tabs: const [
                Tab(
                  icon: Icon(Icons.check_box_outlined, size: 20),
                  text: 'Shalat',
                  iconMargin: EdgeInsets.only(bottom: 2),
                ),
                Tab(
                  icon: Icon(Icons.menu_book, size: 20),
                  text: 'Ceramah',
                  iconMargin: EdgeInsets.only(bottom: 2),
                ),
                Tab(
                  icon: Icon(Icons.volunteer_activism, size: 20),
                  text: 'Infaq',
                  iconMargin: EdgeInsets.only(bottom: 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _ShalatTab(),
          _CeramahTab(),
          _InfaqTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHALAT TAB
// ─────────────────────────────────────────────
class _ShalatTab extends StatefulWidget {
  const _ShalatTab();

  @override
  State<_ShalatTab> createState() => _ShalatTabState();
}

class _ShalatTabState extends State<_ShalatTab> {
  bool _showHistory = false;

  static const List<Map<String, dynamic>> _prayers = [
    {'key': 'subuh', 'name': 'Subuh', 'icon': Icons.wb_twilight},
    {'key': 'dzuhur', 'name': 'Dzuhur', 'icon': Icons.wb_sunny},
    {'key': 'ashar', 'name': 'Ashar', 'icon': Icons.brightness_5},
    {'key': 'maghrib', 'name': 'Maghrib', 'icon': Icons.nightlight_round},
    {'key': 'isya', 'name': 'Isya', 'icon': Icons.nights_stay},
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatatanRamadhanViewModel>();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final shalat = vm.shalatReports.firstWhere(
      (r) => r.date == today,
      orElse: () => ShalatReport(date: today),
    );

    if (_showHistory) return _buildHistory(vm);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _DateCard(),
              const SizedBox(height: 14),
              _buildShalatCard(shalat, vm, today),
              const SizedBox(height: 80),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _showHistory = true),
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('Riwayat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShalatCard(
      ShalatReport shalat, CatatanRamadhanViewModel vm, String today) {
    final values = [
      shalat.subuh,
      shalat.dzuhur,
      shalat.ashar,
      shalat.maghrib,
      shalat.isya,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: List.generate(_prayers.length, (i) {
          final p = _prayers[i];
          final isChecked = values[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4EED9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(p['icon'] as IconData,
                          color: primaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isChecked
                                ? 'Sudah dikerjakan'
                                : 'Belum dikerjakan',
                            style: TextStyle(
                              fontSize: 12,
                              color: isChecked
                                  ? primaryColor
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isChecked,
                      activeColor: primaryColor,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      onChanged: (v) =>
                          vm.updateShalat(today, p['key'] as String, v!),
                    ),
                  ],
                ),
              ),
              if (i < _prayers.length - 1)
                const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 76,
                    endIndent: 16,
                    color: Color(0xFFF0F0F0)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHistory(CatatanRamadhanViewModel vm) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          elevation: 1,
          child: InkWell(
            onTap: () => setState(() => _showHistory = false),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: primaryColor),
                  const SizedBox(width: 10),
                  const Text('Riwayat Shalat',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: vm.shalatReports.isEmpty
              ? Center(
                  child: Text('Belum ada riwayat',
                      style: TextStyle(color: Colors.grey[500])))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.shalatReports.length,
                  itemBuilder: (ctx, i) {
                    final r = vm.shalatReports[i];
                    final count = [
                      r.subuh,
                      r.dzuhur,
                      r.ashar,
                      r.maghrib,
                      r.isya
                    ].where((v) => v).length;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 16, color: primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(r.date,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500))),
                          Text(
                            '$count/5 shalat',
                            style: TextStyle(
                              color: count == 5
                                  ? primaryColor
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  DATE CARD (shared)
// ─────────────────────────────────────────────
class _DateCard extends StatelessWidget {
  static const _days = [
    'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = _days[now.weekday % 7];
    final monthName = _months[now.month - 1];
    final dateStr =
        '$dayName, ${now.day.toString().padLeft(2, '0')} $monthName ${now.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EED9),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.calendar_today, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hari Ini',
                  style: TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w600)),
              Text(dateStr,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CERAMAH TAB
// ─────────────────────────────────────────────
class _CeramahTab extends StatelessWidget {
  const _CeramahTab();

  String _fmtDate(String date) {
    final p = date.split('-');
    if (p.length != 3) return date;
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${p[2]} ${m[int.parse(p[1]) - 1]} ${p[0]}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatatanRamadhanViewModel>();
    final entries = vm.ceramahEntries;

    return Stack(
      children: [
        entries.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_outlined,
                        size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('Belum ada catatan ceramah',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Ketuk tombol di bawah untuk menambah',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: entries.length,
                itemBuilder: (ctx, i) {
                  final e = entries[i];
                  return Dismissible(
                    key: Key(e.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 26),
                    ),
                    confirmDismiss: (_) => _confirmDelete(ctx),
                    onDismissed: (_) =>
                        context.read<CatatanRamadhanViewModel>().deleteCeramah(e.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.judul.isNotEmpty ? e.judul : '(Tanpa judul)',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  size: 14, color: Colors.black45),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  e.penceramah.isNotEmpty
                                      ? e.penceramah
                                      : '-',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                              ),
                              Text(_fmtDate(e.date),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500])),
                            ],
                          ),
                          if (e.ringkasanMateri.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Divider(
                                height: 1, color: Color(0xFFCFDEC4)),
                            const SizedBox(height: 10),
                            Text(
                              e.ringkasanMateri,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 24,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () => _showSheet(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Catatan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _confirmDelete(BuildContext ctx) {
    return showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content:
            const Text('Catatan ceramah ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus')),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context) {
    final vm = context.read<CatatanRamadhanViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: const _CeramahSheet(),
      ),
    );
  }
}

class _CeramahSheet extends StatefulWidget {
  const _CeramahSheet();

  @override
  State<_CeramahSheet> createState() => _CeramahSheetState();
}

class _CeramahSheetState extends State<_CeramahSheet> {
  final _judulCtrl = TextEditingController();
  final _penceramahCtrl = TextEditingController();
  final _ringkasanCtrl = TextEditingController();

  @override
  void dispose() {
    _judulCtrl.dispose();
    _penceramahCtrl.dispose();
    _ringkasanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAF5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Catat Ceramah',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _Field(
              controller: _judulCtrl,
              hint: 'Judul / Tema Materi',
              prefixIcon: Icons.title,
              maxLen: 200,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _penceramahCtrl,
              hint: 'Penceramah / Ustadz',
              prefixIcon: Icons.person_outline,
              maxLen: 100,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _ringkasanCtrl,
              hint: 'Ringkasan Catatan Materi',
              maxLen: 5000,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _simpan() {
    context.read<CatatanRamadhanViewModel>().addCeramah(
          _judulCtrl.text.trim(),
          _penceramahCtrl.text.trim(),
          _ringkasanCtrl.text.trim(),
        );
    Navigator.pop(context);
  }
}

// ─────────────────────────────────────────────
//  INFAQ TAB
// ─────────────────────────────────────────────
class _InfaqTab extends StatelessWidget {
  const _InfaqTab();

  String _fmtDate(String date) {
    final p = date.split('-');
    if (p.length != 3) return date;
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${p[2]} ${m[int.parse(p[1]) - 1]} ${p[0]}';
  }

  String _fmtNominal(double nominal) {
    final s = nominal.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatatanRamadhanViewModel>();
    final entries = vm.infaqEntries;

    return Stack(
      children: [
        entries.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volunteer_activism_outlined,
                        size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text('Belum ada catatan infaq',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Ketuk tombol di bawah untuk menambah',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: entries.length,
                itemBuilder: (ctx, i) {
                  final e = entries[i];
                  return Dismissible(
                    key: Key(e.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 26),
                    ),
                    confirmDismiss: (_) => _confirmDelete(ctx),
                    onDismissed: (_) =>
                        context.read<CatatanRamadhanViewModel>().deleteInfaq(e.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4E6C3),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(Icons.volunteer_activism,
                                color: primaryColor, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _fmtNominal(e.nominal),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                if (e.keterangan.isNotEmpty)
                                  Text(e.keterangan,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54)),
                                Text(_fmtDate(e.date),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 24,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () => _showSheet(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Catatan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> _confirmDelete(BuildContext ctx) {
    return showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content:
            const Text('Catatan infaq ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus')),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context) {
    final vm = context.read<CatatanRamadhanViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: const _InfaqSheet(),
      ),
    );
  }
}

class _InfaqSheet extends StatefulWidget {
  const _InfaqSheet();

  @override
  State<_InfaqSheet> createState() => _InfaqSheetState();
}

class _InfaqSheetState extends State<_InfaqSheet> {
  final _nominalCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();

  @override
  void dispose() {
    _nominalCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAF5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Catat Sedekah / Infaq',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Nominal
            TextField(
              controller: _nominalCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Nominal Rupiah',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixText: 'Rp  ',
                prefixStyle: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _Field(
              controller: _keteranganCtrl,
              hint: 'Keterangan (Penerima / Peruntukan...)',
              prefixIcon: Icons.info_outline,
              maxLen: 500,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _simpan() {
    final nominal = double.tryParse(_nominalCtrl.text) ?? 0;
    context
        .read<CatatanRamadhanViewModel>()
        .addInfaq(nominal, _keteranganCtrl.text.trim());
    Navigator.pop(context);
  }
}

// ─────────────────────────────────────────────
//  SHARED: Input Field Widget
// ─────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final int maxLen;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    required this.maxLen,
    this.maxLines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.grey[500])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            '${controller.text.length}/$maxLen',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BACKWARD COMPAT WRAPPERS
// ─────────────────────────────────────────────
class ShalatReportPage extends StatelessWidget {
  const ShalatReportPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const CatatanDetailPage(initialTab: 0);
}

class CeramahReportPage extends StatelessWidget {
  const CeramahReportPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const CatatanDetailPage(initialTab: 1);
}

class InfaqReportPage extends StatelessWidget {
  const InfaqReportPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const CatatanDetailPage(initialTab: 2);
}
