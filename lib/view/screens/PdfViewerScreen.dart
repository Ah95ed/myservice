import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const PdfViewerScreen({Key? key, required this.filePath, required this.title})
    : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (isReady)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text('${currentPage + 1}/$pages'),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                pages = _pages!;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (controller) {
              // optional: store controller if you want programmatic jumps
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page ?? 0;
              });
            },
          ),
          if (!isReady) const Center(child: CircularProgressIndicator()),
          if (errorMessage.isNotEmpty)
            Center(child: Text('Error: $errorMessage')),
        ],
      ),
    );
  }
}
