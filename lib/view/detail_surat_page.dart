import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/detail_surat_viewmodel.dart';
import 'package:flutter/services.dart';

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
    Future.microtask(() {
      if (mounted) {
        context.read<DetailSuratViewModel>().getDetailSurat(widget.nomor);
      }
    });
  }

  void _copyAyat(Map<String, dynamic> ayat) {
    final textToCopy = "${ayat['teksArab']}\n\n${ayat['teksLatin']}\n\nArtinya: ${ayat['teksIndonesia']} (QS. ${widget.namaLatin}: ${ayat['nomorAyat']})";
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ayat ${ayat['nomorAyat']} berhasil disalin!"),
            backgroundColor: const Color(0xFF546B41),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Widget _buildBismillahCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF546B41),
            fontFamily: 'Amiri',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailSuratViewModel>();
    final showBismillah = widget.nomor != 1 && widget.nomor != 9;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.namaLatin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Surat ke-${widget.nomor}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48), // spacer
              ],
            ),
          ),

          /// CONTENT
          Expanded(
            child: vm.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF546B41),
                    ),
                  )
                : vm.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              vm.error!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => context.read<DetailSuratViewModel>().getDetailSurat(widget.nomor),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF546B41),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Coba Lagi"),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: showBismillah ? vm.ayatList.length + 1 : vm.ayatList.length,
                        itemBuilder: (context, index) {
                          if (showBismillah && index == 0) {
                            return _buildBismillahCard();
                          }
                          final realIndex = showBismillah ? index - 1 : index;
                          final ayat = vm.ayatList[realIndex];

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// NOMOR AYAT & ACTION
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF546B41).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Ayat ${ayat['nomorAyat']}",
                                          style: const TextStyle(
                                            color: Color(0xFF546B41),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.copy_rounded,
                                          color: Color(0xFF546B41),
                                          size: 18,
                                        ),
                                        onPressed: () => _copyAyat(ayat),
                                        tooltip: "Salin Ayat",
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  /// ARAB
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      ayat['teksArab'],
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                        height: 1.8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// LATIN
                                  Text(
                                    ayat['teksLatin'],
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.teal[700],
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  /// ARTI
                                  Text(
                                    ayat['teksIndonesia'],
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
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
