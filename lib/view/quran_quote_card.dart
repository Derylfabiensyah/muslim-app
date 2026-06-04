import 'package:flutter/material.dart';
import '../model/quran_quote.dart';
import '../repository/quran_repository.dart';

class QuranQuoteCard extends StatefulWidget {
  const QuranQuoteCard({super.key});

  @override
  State<QuranQuoteCard> createState() => _QuranQuoteCardState();
}

class _QuranQuoteCardState extends State<QuranQuoteCard> {
  final QuranQuoteRepository _repository = QuranQuoteRepository();
  QuranQuote? _quote;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final quote = await _repository.fetchRandomQuote();
      if (mounted) {
        setState(() {
          _quote = quote;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Gagal memuat kutipan Al-Quran. Ketuk untuk mencoba lagi.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.format_quote_rounded,
                size: 120,
                color: const Color(0xFF546B41).withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _isLoading
                  ? _buildLoading()
                  : _error != null
                      ? _buildError()
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF546B41),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Memuat kutipan...",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _fetchQuote,
              icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF546B41)),
              label: const Text(
                "Coba Lagi",
                style: TextStyle(
                  color: Color(0xFF546B41),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_quote == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF546B41).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF546B41),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Kutipan Al-Quran",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.autorenew_rounded,
                color: Color(0xFF546B41),
                size: 20,
              ),
              onPressed: _fetchQuote,
              tooltip: "Acak Kutipan",
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: Text(
            _quote!.arab,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _quote!.translation,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.4,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF546B41).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "QS. ${_quote!.surahName}: ${_quote!.ayahNumber}",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF546B41),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
