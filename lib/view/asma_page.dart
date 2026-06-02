import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/asma_viewmodel.dart';

class AsmaPage extends StatefulWidget {
  const AsmaPage({super.key});

  @override
  State<AsmaPage> createState() => _AsmaPageState();
}

class _AsmaPageState extends State<AsmaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AsmaViewModel>().getAsma();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AsmaViewModel>();

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
                const Expanded(
                  child: Text(
                    "Asmaul Husna",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                        itemCount: vm.asmaList.length,
                        itemBuilder: (context, index) {
                          final asma = vm.asmaList[index];

                          return Card(
                            color: Colors.white,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                // Gunakan Row agar nomor dan teks berjajar rapi
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFF546B41),
                                    child: Text("${index + 1}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // Arab di kanan
                                      children: [
                                        Text(
                                          asma.arab,
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Align(
                                          alignment: Alignment
                                              .centerLeft, // Latin & Arti di kiri
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(asma.latin,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.teal)),
                                              Text(asma.arti,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
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
