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
                    "Asmaul Husna",
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
                              onPressed: () => context.read<AsmaViewModel>().getAsma(),
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
                        itemCount: vm.asmaList.length,
                        itemBuilder: (context, index) {
                          final asma = vm.asmaList[index];

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
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF546B41).withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          color: Color(0xFF546B41),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          asma.arab,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                asma.latin,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF546B41),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                asma.arti,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  height: 1.3,
                                                ),
                                              ),
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
