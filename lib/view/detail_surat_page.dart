import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/detail_surat_viewmodel.dart';

class DetailSuratPage extends StatefulWidget {
  final int nomor;
  final String namaLatin;

  const DetailSuratPage({
    super.key,
    required this.nomor,
    required this.namaLatin,
  });

  @override
  State<DetailSuratPage> createState() => _DetailSuratPageState();
}

class _DetailSuratPageState extends State<DetailSuratPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DetailSuratViewModel>().getDetailSurat(widget.nomor));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailSuratViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
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
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    widget.namaLatin,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 48),
              ],
            ),
          ),

          /// CONTENT
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                    ? Center(child: Text(vm.error!))
                    : ListView.builder(
                        itemCount: vm.ayatList.length,
                        itemBuilder: (context, index) {
                          final ayat = vm.ayatList[index];

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// NOMOR AYAT
                                  Text(
                                    "Ayat ${ayat['nomorAyat']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// ARAB
                                  Text(
                                    ayat['teksArab'],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 22),
                                  ),

                                  const SizedBox(height: 8),

                                  /// LATIN
                                  Text(
                                    ayat['teksLatin'],
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// ARTI
                                  Text(ayat['teksIndonesia']),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
