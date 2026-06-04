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
    Future.microtask(() {
      if (mounted) {
        context.read<DzikirViewModel>().getDzikir();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DzikirViewModel>();

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
                const Expanded(
                  child: Text(
                    "Bacaan Dzikir",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                              onPressed: () => context.read<DzikirViewModel>().getDzikir(),
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
                        padding: const EdgeInsets.only(bottom: 24, top: 8),
                        itemCount: vm.dzikirList.length,
                        itemBuilder: (context, index) {
                          final dzikir = vm.dzikirList[index];

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
                                  /// ULANG BADGE (IF EXISTS)
                                  if (dzikir.ulang.isNotEmpty)
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
                                            "Ulang: ${dzikir.ulang}x",
                                            style: const TextStyle(
                                              color: Color(0xFF546B41),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        if (dzikir.type != null && dzikir.type!.isNotEmpty)
                                          Text(
                                            dzikir.type!.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                      ],
                                    ),
                                  const SizedBox(height: 12),

                                  /// ARAB
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      dzikir.arab,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// TERJEMAHAN
                                  Text(
                                    dzikir.indo,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                      fontStyle: FontStyle.italic,
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
