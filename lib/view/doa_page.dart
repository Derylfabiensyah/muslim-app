import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/doa_viewmodel.dart';
import 'package:flutter/services.dart';
import '../model/doa_model.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<DoaViewModel>(context, listen: false).getDoa();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copyDoa(Doa doa) {
    final textToCopy = "${doa.judul}\n\n${doa.arab}\n\nArtinya: ${doa.indo}";
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Doa \"${doa.judul}\" berhasil disalin!"),
            backgroundColor: const Color(0xFF546B41),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DoaViewModel>(context);

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
                  "Daftar Doa Harian",
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
                      hintText: "Cari Doa...",
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
                          onPressed: () => context.read<DoaViewModel>().getDoa(),
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

                final filteredDoa = vm.doaList.where((doa) {
                  final query = _searchQuery.toLowerCase();
                  return doa.judul.toLowerCase().contains(query) ||
                      doa.indo.toLowerCase().contains(query);
                }).toList();

                if (filteredDoa.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        "Doa tidak ditemukan",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
                  itemCount: filteredDoa.length,
                  itemBuilder: (context, index) {
                    final doa = filteredDoa[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF546B41),
                                width: 4,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      doa.judul,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy_rounded,
                                      color: Color(0xFF546B41),
                                      size: 18,
                                    ),
                                    onPressed: () => _copyDoa(doa),
                                    tooltip: "Salin Doa",
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              if (doa.arab.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    doa.arab,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                      height: 1.8,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              Text(
                                doa.indo.isEmpty ? "-" : doa.indo,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ],
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
