import 'dart:developer';

import 'package:Al_Zab_township_guide/view/Size/ScreenSize.dart';
import 'package:Al_Zab_township_guide/view/screens/BooksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../provider/PdfViewerProvider.dart';

class PdfViewerScreen extends StatefulWidget {
  static final route = 'PdfViewerScreen';

  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool started = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!started) {
    //     final provider = Provider.of<PdfViewerProvider>(context, listen: false);
    //     final args = ModalRoute.of(context)?.settings.arguments;

    //     if (args is PdfViewerData) {
    //       // if (args.filePath != null && args.filePath!.isNotEmpty) {
    //       //   return;
    //       // }
    //       // set provider data; provider will download remote if needed
    //       provider.setData(args, context);
    //     }
    //     started = true;
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PdfViewerData;

    return Consumer<PdfViewerProvider>(
      builder: (context, provider, child) {
        final data = provider.data;
        final loading = provider.loading;
        final error = provider.error;
        final pages = provider.pages;
        final current = provider.currentPage;

        return  Scaffold(
          appBar: AppBar(
            title: Text(args.title),
            actions: [
              if (!loading && error == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text('${current + 1}/$pages'),
                  ),
                ),
              SizedBox(width: context.getWidth(10)),
              IconButton(
                onPressed: () async {
                  await Share.shareXFiles([
                    XFile(args.filePath ?? ''),
                  ], text: '📚 هذا الكتاب: ${args.title}');
                },
                icon: Icon(Icons.share),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (error == null &&
                  args.filePath != null &&
                  args.filePath!.isNotEmpty)
                PDFView(
                  filePath: args.filePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,            }
                  
                  onRender: (_pages) {
                    provider.updatePages(_pages ?? 0);
                  },
                  onError: (error) {
                    provider.reportError(error.toString());
                  },
                  onPageError: (page, error) {
                    provider.reportError('$page: ${error.toString()}');
                  },
                  onViewCreated: (controller) {},
                  onPageChanged: (int? page, int? total) {
                    provider.setCurrentPage(page ?? 0);
                  },
                ),

              if (loading) const Center(child: CircularProgressIndicator()),
              if (error != null) Center(child: Text('Error: $error')),
            ],
          ),
        );
      },
    );
  }
}
