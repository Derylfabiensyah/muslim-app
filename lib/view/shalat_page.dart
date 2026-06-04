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
  final int year = 2025;
  final int month = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShalatViewModel>().fetchMonthlySchedule(
            cityId: cityId,
            year: year,
            month: month,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF546B41),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                /// TOMBOL BACK
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 8),

                /// TITLE
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

                /// SPACER AGAR TITLE TETAP TENGAH
                const SizedBox(width: 48),
              ],
            ),
          ),


          /// CONTENT
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gagal memuat data\n${vm.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context
                              .read<ShalatViewModel>()
                              .fetchMonthlySchedule(
                                cityId: cityId,
                                year: year,
                                month: month,
                              ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.schedules.length,
                  itemBuilder: (context, i) {
                    final d = vm.schedules[i];
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TANGGAL
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  d.tanggal,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 24),

                            _timeRow('Imsak', d.imsak),
                            _timeRow('Subuh', d.subuh),
                            _timeRow('Terbit', d.terbit),
                            _timeRow('Dhuha', d.dhuha),
                            _timeRow('Dzuhur', d.dzuhur),
                            _timeRow('Ashar', d.ashar),
                            _timeRow('Maghrib', d.maghrib),
                            _timeRow('Isya', d.isya),
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

  Widget _timeRow(String label, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            time.isEmpty ? '-' : time,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
