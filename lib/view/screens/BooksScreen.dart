import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Service/r2_config.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as AWSHttpRequest;
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart' as xml;

import '../../Service/CloudflareService.dart';
import '../../provider/PdfViewerProvider.dart';
import 'PdfViewerScreen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  bool loading = true;
  String? error;
  List args = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> listFolders() async {
    const region = 'auto'; // Cloudflare ما يحتاج region فعلي
    const service = 's3';

    final host = '${R2_ACCOUNT_ID}.r2.cloudflarestorage.com';
    final url = Uri.https(host, '/${R2_BUCKET}', {'delimiter': '/'});

    Logger.logger('Request URL: ${url.toString()}');

    final signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY),
      ),
    );

    final request = AWSHttpRequest.get(url, headers: {'host': host});

    // final signedRequest = await signer.sign(
    //   request as AWSBaseHttpRequest,
    //   credentialScope: AWSCredentialScope(
    //     region: region,
    //     // service:AWSServic,
    //   ),
    // );

    final response = await http.get(
      url,

      // headers: signedRequest.headers,
    );

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final prefixes = document.findAllElements('Prefix');
      final folders = prefixes.map((e) => e.text.replaceAll('/', '')).toList();
      Logger.logger('Folders found: ${folders.toString()}');
      return folders;
    } else {
      Logger.logger('Error: ${response.statusCode}');
      print('Error: ${response.statusCode}');
      print(response.body);
      return [];
    }
  }
  // Future<List<String>> listFolders() async {
  //   final url = Uri.parse(
  //     'https://${R2_ACCOUNT_ID}.r2.cloudflarestorage.com/${R2_BUCKET}?delimiter=/',
  //   );
  //   Logger.logger(url.toString());
  //   final response = await http.get(
  //     url,
  //     headers: {'Authorization': 'AWS $R2_ACCESS_KEY_ID:$R2_SECRET_ACCESS_KEY',},
  //   );

  //   if (response.statusCode == 200) {
  //     final document = xml.XmlDocument.parse(response.body);
  //     final prefixes = document.findAllElements('Prefix');
  //     final folders = prefixes.map((e) => e.text.replaceAll('/', '')).toList();
  //     Logger.logger('message ==== ${folders.toString()}');
  //     return folders;
  //   } else {
  //     Logger.logger('message ==== ${response.statusCode}');
  //     print('Error: ${response.statusCode}');
  //     print(response.body);
  //     return [];
  //   }
  // }

  Future<void> _loadBooks() async {
    try {
      final list = await CloudflareService.fetchBooks();
      setState(() {
        // books = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as List;
    // Logger.logger('message == ${args[0]}');
  }

  @override
  Widget build(BuildContext context) {
    if (args.isEmpty)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('الكتب'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'التصنيفات',
            onPressed: () {
              Navigator.pushNamed(context, '/GradesScreen');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.99,
          ),
          itemCount: args.length,
          itemBuilder: (context, index) {
            final book = args;
            return InkWell(
              onTap: () {
                // Logger.logger('message === ${book[index]['name']}');
                // Logger.logger('message == ${book.title}');
                managerScreen(
                  PdfViewerScreen.route,
                  context,
                  object: PdfViewerData(
                    title: book[index]['name'],
                    remoteUrl: book[index]['url'],
                  ),
                );
                // Navigator.pushNamed(
                //   context,
                //   PdfViewerScreen.route,
                //   arguments: PdfViewerData(
                //     remoteUrl: book.urlBook,
                //     title: book.first.toString(),
                //   ),
                // );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // log('open ${book[index]['url']}');
                              // await downloadAndOpenByUrl(
                              //   context,
                              //   book[index]['url']!,
                              //   book[index]['name']!,
                              // );
                            },
                            child: Center(
                              child: Text(
                                book[index]['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // log('download ${book.urlBook}');
                                await downloadAndOpenByUrl(
                                  context,
                                  book[index]['url']!,
                                  book[index]['name']!,
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('اختر مكان التنزيل'),
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
    );
  }
}

Future<void> downloadAndOpenByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  String? dir = '';
  try {
    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);
    if (shared!.getString('path')!.isEmpty ||
        shared!.getString('path') == null) {
      dir = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'اختر مجلد لحفظ الملف',
      );
    }else{
      dir = shared!.getString('path')! + '/books';
    }
    
    // Ask for directory first (works on Android & desktop). If null, fallback to temp.

    if (dir == null) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }
    final bytes = response.bodyBytes;

    String savedPath;
    final path = p.join(dir, suggestedName);
    final file = File(path);
    await file.writeAsBytes(bytes);
    savedPath = path;

    try {
      Navigator.pop(context);
    } catch (_) {}

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الكتاب: $savedPath')),
    );
    // Open in-app PDF viewer if PDF, otherwise fallback to external
    if (_extensionFromUrl(savedPath).toLowerCase().contains('pdf')) {
      Navigator.pushNamed(
        context,
        PdfViewerScreen.route,
        arguments: PdfViewerData(filePath: savedPath, title: title),
      );
    } else {
      await OpenFile.open(savedPath);
    }
  } catch (e, st) {
    try {
      Navigator.pop(context);
    } catch (_) {}
    // log('download error', error: e, stackTrace: st);
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

String _extensionFromUrl(String url) {
  final idx = url.lastIndexOf('.');
  if (idx == -1) return '.pdf';
  return url.substring(idx);
}
