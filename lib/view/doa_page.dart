import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/doa_viewmodel.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoaViewModel>(context, listen: false).getDoa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DoaViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF546B41),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: const Center(
              child: Text(
                "Daftar Doa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// ===== CONTENT =====
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.error != null) {
                  return Center(child: Text(vm.error!));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.doaList.length,
                  itemBuilder: (context, index) {
                    final doa = vm.doaList[index];

                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// JUDUL DOA
                            Text(
                              doa.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const Divider(height: 20),

                            /// AYAT ARAB
                            Text(
                              doa.arab.isEmpty ? "-" : doa.arab,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.8,
                              ),
                              textAlign: TextAlign.right,
                            ),

                            const SizedBox(height: 10),

                            /// ARTI
                            Text(
                              doa.indo.isEmpty ? "-" : doa.indo,
                              style: const TextStyle(fontSize: 14),
                            ),
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
}
