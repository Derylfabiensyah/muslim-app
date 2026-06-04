import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/quran_viewmodel.dart';
import 'detail_surat_page.dart';

class SuratPage extends StatefulWidget {
  const SuratPage({super.key});

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<QuranViewModel>().getSurat();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF546B41),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Al-Qur'an Digital",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Cari Surat...",
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ===== CONTENT =====
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vm.error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<QuranViewModel>().getSurat(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF546B41),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  );
                }

                final filteredSurat = vm.suratList.where((surat) {
                  final query = _searchQuery.toLowerCase();
                  return surat.namaLatin.toLowerCase().contains(query) ||
                      surat.nomor.toString() == query;
                }).toList();

                if (filteredSurat.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        "Surat tidak ditemukan",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSurat.length,
                  itemBuilder: (context, index) {
                    final surat = filteredSurat[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailSuratPage(
                                  nomor: surat.nomor,
                                  namaLatin: surat.namaLatin,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF546B41).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${surat.nomor}",
                                      style: const TextStyle(
                                        color: Color(0xFF546B41),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        surat.namaLatin,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${surat.tempatTurun.toUpperCase()} • ${surat.jumlahAyat} AYAT",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  surat.nama,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF546B41),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
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
}
