import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/dzikir_viewmodel.dart';

class DzikirPage extends StatefulWidget {
  const DzikirPage({super.key});

  @override
  State<DzikirPage> createState() => _DzikirPageState();
}

class _DzikirPageState extends State<DzikirPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DzikirViewModel>().getDzikir());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DzikirViewModel>();

    return Scaffold(
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
            child: const Center(
              child: Text(
                "Dzikir",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                    ? Center(child: Text(vm.error!))
                    : ListView.builder(
                        itemCount: vm.dzikirList.length,
                        itemBuilder: (context, index) {
                          final dzikir = vm.dzikirList[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// ARAB
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      dzikir.arab,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  /// TERJEMAHAN
                                  Text(
                                    dzikir.indo,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  /// ULANG
                                  Text(
                                    dzikir.ulang.isNotEmpty
                                        ? 'Ulang: ${dzikir.ulang}'
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
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
